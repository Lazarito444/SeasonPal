import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/features/discovery/data/discovery_repository.dart';
import 'package:seasonpal/features/discovery/domain/discovery_models.dart';

const _unset = Object();

/// The ingredients the cook currently has. Shared by Home's pantry shelf and the
/// pantry screen so a shortcut can seed the search before the screen opens.
final pantryIngredientsProvider = NotifierProvider<PantryIngredientsController, List<String>>(
  PantryIngredientsController.new,
);

final class PantryIngredientsController extends Notifier<List<String>> {
  static const maxTerms = 30;
  static const maxTermLength = 100;

  @override
  List<String> build() => const [];

  /// Replaces the shelf with comma-separated or already-split terms. Used by
  /// Home's shortcut so the pantry screen opens with a ready search.
  void replace(Iterable<String> values) {
    final terms = <String>[];
    for (final value in values) {
      for (final part in value.split(',')) {
        _append(terms, part);
      }
    }

    state = List.unmodifiable(terms);
  }

  void add(String value) => replace([...state, value]);

  void remove(String value) {
    final normalized = value.trim().toLowerCase();
    state = List.unmodifiable(
      state.where((term) => term.toLowerCase() != normalized),
    );
  }

  void clear() => state = const [];

  void _append(List<String> terms, String raw) {
    final term = raw.trim();
    if (term.isEmpty || term.length > maxTermLength) {
      return;
    }

    final exists = terms.any(
      (existing) => existing.toLowerCase() == term.toLowerCase(),
    );
    if (!exists && terms.length < maxTerms) {
      terms.add(term);
    }
  }
}

/// One page of pantry matches plus its next-page state.
final class PantryResultsPage {
  const PantryResultsPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<PantryMatch> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool loadingMore;
  final Object? loadMoreError;

  bool get hasNextPage => page * pageSize < totalCount;

  PantryResultsPage copyWith({
    List<PantryMatch>? items,
    int? page,
    int? pageSize,
    int? totalCount,
    bool? loadingMore,
    Object? loadMoreError = _unset,
  }) => PantryResultsPage(
    items: items ?? this.items,
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    totalCount: totalCount ?? this.totalCount,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: identical(loadMoreError, _unset) ? this.loadMoreError : loadMoreError,
  );
}

/// Re-runs the match whenever the shelf changes. A null page means the shelf is
/// empty and the screen should show its starting prompt instead of an empty
/// result.
final pantryResultsProvider = AsyncNotifierProvider.autoDispose<PantryResultsController, PantryResultsPage?>(PantryResultsController.new);

final class PantryResultsController extends AsyncNotifier<PantryResultsPage?> {
  @override
  Future<PantryResultsPage?> build() {
    final ingredients = ref.watch(pantryIngredientsProvider);
    return _load(ingredients);
  }

  /// Re-runs the current shelf from page one. Reads the terms instead of
  /// watching them because a pull-to-refresh is not a new build.
  Future<void> refresh() async {
    final ingredients = List<String>.of(ref.read(pantryIngredientsProvider));
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() => _load(ingredients));

    if (!listEquals(ref.read(pantryIngredientsProvider), ingredients)) {
      return;
    }

    state = next;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasNextPage) {
      return;
    }

    state = AsyncData(current.copyWith(loadingMore: true, loadMoreError: null));

    final ingredients = List<String>.of(
      ref.read(pantryIngredientsProvider),
    );
    try {
      final next = await _load(
        ingredients,
        page: current.page + 1,
        pageSize: current.pageSize,
      );

      if (next == null || !listEquals(ref.read(pantryIngredientsProvider), ingredients)) {
        return;
      }

      final knownIds = current.items.map((item) => item.recipe.id).toSet();
      state = AsyncData(
        current.copyWith(
          items: [
            ...current.items,
            ...next.items.where(
              (item) => !knownIds.contains(item.recipe.id),
            ),
          ],
          page: next.page,
          pageSize: next.pageSize,
          totalCount: next.totalCount,
          loadingMore: false,
          loadMoreError: null,
        ),
      );
    } on Object catch (error) {
      if (!listEquals(ref.read(pantryIngredientsProvider), ingredients)) {
        return;
      }

      state = AsyncData(
        current.copyWith(loadingMore: false, loadMoreError: error),
      );
    }
  }

  Future<PantryResultsPage?> _load(
    List<String> ingredients, {
    int page = 1,
    int pageSize = 20,
  }) async {
    if (ingredients.isEmpty) {
      return null;
    }

    final result = await ref.read(discoveryRepositoryProvider).pantry(ingredients: ingredients, page: page, pageSize: pageSize);

    return PantryResultsPage(
      items: result.items,
      page: result.page,
      pageSize: result.pageSize,
      totalCount: result.totalCount,
    );
  }
}
