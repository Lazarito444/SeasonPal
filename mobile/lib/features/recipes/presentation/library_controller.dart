import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

enum LibraryTab { own, saved }

const _unset = Object();

/// One loaded page plus the next-page state. Kept immutable so the UI can show
/// the current recipes while a "load more" request is in flight.
final class LibraryPage {
  const LibraryPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<RecipeSummary> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool loadingMore;
  final Object? loadMoreError;

  bool get hasNextPage => page * pageSize < totalCount;

  LibraryPage copyWith({
    List<RecipeSummary>? items,
    int? page,
    int? pageSize,
    int? totalCount,
    bool? loadingMore,
    Object? loadMoreError = _unset,
  }) => LibraryPage(
    items: items ?? this.items,
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    totalCount: totalCount ?? this.totalCount,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: identical(loadMoreError, _unset) ? this.loadMoreError : loadMoreError,
  );
}

final libraryControllerProvider = AsyncNotifierProvider.autoDispose.family<LibraryController, LibraryPage, LibraryTab>(LibraryController.new);

/// Paginated own/saved recipe list. Each tab keeps its own page and append
/// state, so switching tabs never throws away what was already loaded.
final class LibraryController extends AsyncNotifier<LibraryPage> {
  LibraryController(this.tab);

  final LibraryTab tab;

  @override
  Future<LibraryPage> build() async {
    final repository = ref.read(recipeRepositoryProvider);
    final page = await switch (tab) {
      LibraryTab.own => repository.listOwn(),
      LibraryTab.saved => repository.listSaved(),
    };

    return LibraryPage(
      items: page.items,
      page: page.page,
      pageSize: page.pageSize,
      totalCount: page.totalCount,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasNextPage) {
      return;
    }

    state = AsyncData(current.copyWith(loadingMore: true, loadMoreError: null));

    try {
      final repository = ref.read(recipeRepositoryProvider);
      final next = await switch (tab) {
        LibraryTab.own => repository.listOwn(page: current.page + 1),
        LibraryTab.saved => repository.listSaved(page: current.page + 1),
      };
      final knownIds = current.items.map((item) => item.id).toSet();

      state = AsyncData(
        current.copyWith(
          items: [
            ...current.items,
            ...next.items.where((item) => !knownIds.contains(item.id)),
          ],
          page: next.page,
          pageSize: next.pageSize,
          totalCount: next.totalCount,
          loadingMore: false,
        ),
      );
    } on Object catch (error) {
      state = AsyncData(
        current.copyWith(loadingMore: false, loadMoreError: error),
      );
    }
  }
}
