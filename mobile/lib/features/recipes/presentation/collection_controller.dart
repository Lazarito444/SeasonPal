import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

/// A collection plus the recipes loaded so far, with its own append state so a
/// removal can drop one row without refetching the page.
final class CollectionView {
  const CollectionView({
    required this.id,
    required this.name,
    required this.isDefaultFavorites,
    required this.recipeCount,
    required this.createdAt,
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    this.description,
    this.loadingMore = false,
    this.loadMoreError,
  });

  factory CollectionView.fromDetail(CollectionDetail detail) => CollectionView(
    id: detail.id,
    name: detail.name,
    description: detail.description,
    isDefaultFavorites: detail.isDefaultFavorites,
    recipeCount: detail.recipeCount,
    createdAt: detail.createdAt,
    items: detail.recipes.items,
    page: detail.recipes.page,
    pageSize: detail.recipes.pageSize,
    totalCount: detail.recipes.totalCount,
  );

  final String id;
  final String name;
  final String? description;
  final bool isDefaultFavorites;
  final int recipeCount;
  final DateTime createdAt;
  final List<RecipeSummary> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool loadingMore;
  final Object? loadMoreError;

  bool get hasNextPage => page * pageSize < totalCount;

  CollectionView copyWith({
    List<RecipeSummary>? items,
    int? page,
    int? pageSize,
    int? totalCount,
    int? recipeCount,
    bool? loadingMore,
    Object? loadMoreError = _unset,
  }) => CollectionView(
    id: id,
    name: name,
    description: description,
    isDefaultFavorites: isDefaultFavorites,
    recipeCount: recipeCount ?? this.recipeCount,
    createdAt: createdAt,
    items: items ?? this.items,
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    totalCount: totalCount ?? this.totalCount,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: identical(loadMoreError, _unset) ? this.loadMoreError : loadMoreError,
  );
}

const _unset = Object();

/// Auto-disposed with the collection screen so returning to it always sees
/// membership changes made elsewhere.
final collectionViewProvider = AsyncNotifierProvider.autoDispose.family<CollectionViewController, CollectionView, String>(
  CollectionViewController.new,
);

final class CollectionViewController extends AsyncNotifier<CollectionView> {
  CollectionViewController(this.collectionId);

  final String collectionId;

  @override
  Future<CollectionView> build() async {
    final detail = await ref.read(recipeRepositoryProvider).getCollection(collectionId);
    return CollectionView.fromDetail(detail);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  /// Drops one row immediately; the API already confirmed the removal.
  void removeLocally(String recipeId) {
    final current = state.value;
    if (current == null) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        items: current.items.where((item) => item.id != recipeId).toList(growable: false),
        recipeCount: (current.recipeCount - 1).clamp(0, 1 << 30),
        totalCount: (current.totalCount - 1).clamp(0, 1 << 30),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasNextPage) {
      return;
    }

    state = AsyncData(current.copyWith(loadingMore: true, loadMoreError: null));

    try {
      final next = await ref.read(recipeRepositoryProvider).getCollection(collectionId, page: current.page + 1);
      final knownIds = current.items.map((item) => item.id).toSet();

      state = AsyncData(
        current.copyWith(
          items: [
            ...current.items,
            ...next.recipes.items.where(
              (item) => !knownIds.contains(item.id),
            ),
          ],
          page: next.recipes.page,
          pageSize: next.recipes.pageSize,
          totalCount: next.recipes.totalCount,
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
