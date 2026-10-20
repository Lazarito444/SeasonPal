import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

/// Full recipe for the detail screen. Auto-disposed after the route closes, and
/// invalidated explicitly after edits or save-state changes.
final recipeDetailProvider = FutureProvider.autoDispose.family<RecipeDetail, String>(
  (ref, id) => ref.watch(recipeRepositoryProvider).get(id),
);

final collectionsProvider = FutureProvider.autoDispose<Paged<CollectionSummary>>(
  (ref) => ref.watch(recipeRepositoryProvider).listCollections(),
);

final collectionDetailProvider = FutureProvider.autoDispose.family<CollectionDetail, String>(
  (ref, id) => ref.watch(recipeRepositoryProvider).getCollection(id),
);
