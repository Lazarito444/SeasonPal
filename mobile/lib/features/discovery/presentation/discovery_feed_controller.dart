import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/features/discovery/data/discovery_repository.dart';
import 'package:seasonpal/features/discovery/presentation/discovery_filters.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

const _unset = Object();

/// One loaded page of the discover feed plus its next-page state.
final class DiscoveryFeedPage {
  const DiscoveryFeedPage({
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

  DiscoveryFeedPage copyWith({
    List<RecipeSummary>? items,
    int? page,
    int? pageSize,
    int? totalCount,
    bool? loadingMore,
    Object? loadMoreError = _unset,
  }) => DiscoveryFeedPage(
    items: items ?? this.items,
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    totalCount: totalCount ?? this.totalCount,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: identical(loadMoreError, _unset) ? this.loadMoreError : loadMoreError,
  );
}

final discoveryFeedProvider = AsyncNotifierProvider.autoDispose<DiscoveryFeedController, DiscoveryFeedPage>(
  DiscoveryFeedController.new,
);

/// Watches the chips and reloads from page one whenever they change; appends
/// the next page without dropping the recipes already on screen.
final class DiscoveryFeedController extends AsyncNotifier<DiscoveryFeedPage> {
  @override
  Future<DiscoveryFeedPage> build() => _load(ref.watch(discoveryFiltersProvider));

  /// Re-runs the current filters from page one. Reads the filters instead of
  /// watching them because a pull-to-refresh is not a new build.
  Future<void> refresh() async {
    final filters = ref.read(discoveryFiltersProvider);
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() => _load(filters));

    // A chip or query change during the request starts a fresh feed; the
    // stale page must not overwrite it.
    if (ref.read(discoveryFiltersProvider) != filters) {
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

    final filters = ref.read(discoveryFiltersProvider);
    try {
      final next = await _load(
        filters,
        page: current.page + 1,
        pageSize: current.pageSize,
      );

      if (ref.read(discoveryFiltersProvider) != filters) {
        return;
      }

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
          loadMoreError: null,
        ),
      );
    } on Object catch (error) {
      if (ref.read(discoveryFiltersProvider) != filters) {
        return;
      }

      state = AsyncData(
        current.copyWith(loadingMore: false, loadMoreError: error),
      );
    }
  }

  Future<DiscoveryFeedPage> _load(
    DiscoveryFilters filters, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await ref
        .read(discoveryRepositoryProvider)
        .feed(
          query: filters.query,
          cuisine: filters.cuisine,
          diet: filters.diet,
          mealType: filters.mealType,
          difficulty: filters.difficulty,
          maxTotalTimeMinutes: filters.maxTotalTimeMinutes,
          page: page,
          pageSize: pageSize,
        );

    return DiscoveryFeedPage(
      items: result.items,
      page: result.page,
      pageSize: result.pageSize,
      totalCount: result.totalCount,
    );
  }
}
