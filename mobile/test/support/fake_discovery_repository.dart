import 'dart:math';

import 'package:seasonpal/features/discovery/data/discovery_repository.dart';
import 'package:seasonpal/features/discovery/domain/discovery_models.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

/// One recorded feed request; tests assert the combined filters without
/// reaching into Dio.
typedef DiscoveryFeedCall = ({
  String? query,
  String? cuisine,
  String? diet,
  MealType? mealType,
  RecipeDifficulty? difficulty,
  int? maxTotalTimeMinutes,
  int page,
  int pageSize,
});

/// In-memory discovery transport for widget tests. Pages are sliced from the
/// supplied lists so load-more behavior can be exercised without a server.
final class FakeDiscoveryRepository implements DiscoveryRepository {
  FakeDiscoveryRepository({
    this.feedItems = const [],
    this.homeResult = const DiscoveryHome(
      trending: [],
      newest: [],
      recommended: [],
      hasTasteProfile: false,
    ),
    this.pantryItems = const [],
    this.feedError,
    this.homeError,
    this.pantryError,
  });

  final List<RecipeSummary> feedItems;
  final DiscoveryHome homeResult;
  final List<PantryMatch> pantryItems;
  final Object? feedError;
  final Object? homeError;
  final Object? pantryError;

  int feedCalls = 0;
  int homeCalls = 0;
  int pantryCalls = 0;
  DiscoveryFeedCall? lastFeed;
  List<String>? lastPantryIngredients;

  @override
  Future<Paged<RecipeSummary>> feed({
    String? query,
    String? cuisine,
    String? diet,
    MealType? mealType,
    RecipeDifficulty? difficulty,
    int? maxTotalTimeMinutes,
    int page = 1,
    int pageSize = 20,
  }) async {
    feedCalls++;
    lastFeed = (
      query: query,
      cuisine: cuisine,
      diet: diet,
      mealType: mealType,
      difficulty: difficulty,
      maxTotalTimeMinutes: maxTotalTimeMinutes,
      page: page,
      pageSize: pageSize,
    );

    if (feedError != null) {
      throw feedError!;
    }

    return Paged<RecipeSummary>(
      items: _page(feedItems, page, pageSize),
      page: page,
      pageSize: pageSize,
      totalCount: feedItems.length,
    );
  }

  @override
  Future<DiscoveryHome> home() async {
    homeCalls++;
    if (homeError != null) {
      throw homeError!;
    }

    return homeResult;
  }

  @override
  Future<Paged<PantryMatch>> pantry({
    required List<String> ingredients,
    int page = 1,
    int pageSize = 20,
  }) async {
    pantryCalls++;
    lastPantryIngredients = List.unmodifiable(ingredients);
    if (pantryError != null) {
      throw pantryError!;
    }

    return Paged<PantryMatch>(
      items: _page(pantryItems, page, pageSize),
      page: page,
      pageSize: pageSize,
      totalCount: pantryItems.length,
    );
  }

  List<T> _page<T>(List<T> all, int page, int pageSize) {
    final start = (page - 1) * pageSize;
    if (start >= all.length) {
      return const [];
    }

    return all.sublist(start, min(start + pageSize, all.length));
  }
}

/// Builds a pantry result with sensible defaults for widget tests.
PantryMatch fakePantryMatch({
  RecipeSummary? recipe,
  int matchedCount = 2,
  int missingCount = 0,
  List<String> matchedIngredients = const ['lemon', 'orzo'],
  List<String> missingIngredients = const [],
  int matchPercent = 100,
  bool canCook = true,
}) {
  return PantryMatch(
    recipe:
        recipe ??
        RecipeSummary(
          id: 'pantry-1',
          title: 'Pantry pasta',
          mealType: MealType.dinner,
          servings: 2,
          difficulty: RecipeDifficulty.easy,
          visibility: RecipeVisibility.public,
          status: RecipeStatus.published,
          isAiGenerated: false,
          authorId: 'user-2',
          authorDisplayName: 'Ben',
          updatedAt: DateTime(2026, 10, 20),
        ),
    matchedCount: matchedCount,
    missingCount: missingCount,
    matchedIngredients: matchedIngredients,
    missingIngredients: missingIngredients,
    matchPercent: matchPercent,
    canCook: canCook,
  );
}
