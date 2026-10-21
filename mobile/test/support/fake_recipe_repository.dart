import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

/// Builds a list-ready recipe with sensible defaults; tests override only the
/// fields they assert on.
RecipeSummary fakeRecipeSummary({
  String id = 'recipe-1',
  String title = 'Roast chicken',
  String? description,
  String? cuisine,
  String? coverImageUrl,
  MealType mealType = MealType.dinner,
  int servings = 2,
  RecipeDifficulty difficulty = RecipeDifficulty.easy,
  RecipeVisibility visibility = RecipeVisibility.private,
  RecipeStatus status = RecipeStatus.draft,
  bool isAiGenerated = false,
  String authorId = 'user-1',
  String authorDisplayName = 'Ava',
  int? totalTimeMinutes = 40,
  List<String> tags = const [],
  List<String> dietaryTags = const [],
  DateTime? savedAt,
}) {
  return RecipeSummary(
    id: id,
    title: title,
    description: description,
    cuisine: cuisine,
    coverImageUrl: coverImageUrl,
    mealType: mealType,
    servings: servings,
    totalTimeMinutes: totalTimeMinutes,
    difficulty: difficulty,
    visibility: visibility,
    status: status,
    isAiGenerated: isAiGenerated,
    tags: tags,
    dietaryTags: dietaryTags,
    authorId: authorId,
    authorDisplayName: authorDisplayName,
    savedAt: savedAt,
    updatedAt: DateTime(2026, 10, 20),
  );
}

/// Builds a full recipe for detail and editor tests.
RecipeDetail fakeRecipeDetail({
  String id = 'recipe-1',
  String title = 'Roast chicken',
  String? description,
  String? cuisine,
  String? coverImageUrl,
  MealType mealType = MealType.dinner,
  int servings = 2,
  RecipeDifficulty difficulty = RecipeDifficulty.easy,
  RecipeVisibility visibility = RecipeVisibility.private,
  RecipeStatus status = RecipeStatus.draft,
  bool isAiGenerated = false,
  bool isSaved = false,
  String authorId = 'user-1',
  String authorDisplayName = 'Ava',
  List<String> tags = const [],
  List<String> dietaryTags = const [],
  List<RecipeIngredient> ingredients = const [],
  List<RecipeStep> steps = const [],
  List<RecipeMedia> media = const [],
}) {
  return RecipeDetail(
    id: id,
    author: RecipeAuthor(id: authorId, displayName: authorDisplayName),
    title: title,
    description: description,
    cuisine: cuisine,
    coverImageUrl: coverImageUrl,
    mealType: mealType,
    servings: servings,
    difficulty: difficulty,
    visibility: visibility,
    status: status,
    isAiGenerated: isAiGenerated,
    isSaved: isSaved,
    tags: tags,
    dietaryTags: dietaryTags,
    ingredients: ingredients,
    steps: steps,
    media: media,
    createdAt: DateTime(2026, 10, 1),
    updatedAt: DateTime(2026, 10, 20),
  );
}

/// In-memory repository for widget tests. It records the last write so tests
/// can assert the form produced the expected API payload.
class FakeRecipeRepository implements RecipeRepository {
  FakeRecipeRepository({
    this.own = const [],
    this.saved = const [],
    this.ownError,
    this.savedError,
    Map<String, RecipeDetail>? details,
    this.collectionDetail,
    this.createResult,
    this.updateResult,
  }) : details = details ?? {};

  List<RecipeSummary> own;
  List<RecipeSummary> saved;
  Object? ownError;
  Object? savedError;
  final Map<String, RecipeDetail> details;
  CollectionDetail? collectionDetail;
  RecipeDetail? createResult;
  RecipeDetail? updateResult;

  RecipeWriteInput? lastCreate;
  RecipeWriteInput? lastUpdate;
  String? lastUpdatedId;
  String? lastDeletedId;
  String? lastSavedId;
  String? lastSavedCollectionId;
  String? lastUnsavedId;
  String? lastPublishedId;
  String? lastUnpublishedId;
  String? lastRemovedCollectionId;
  String? lastRemovedRecipeId;
  int listOwnCalls = 0;
  int listSavedCalls = 0;

  @override
  Future<Paged<RecipeSummary>> listOwn({
    int page = 1,
    int pageSize = 20,
  }) async {
    listOwnCalls++;
    if (ownError != null) {
      throw ownError!;
    }

    return Paged(
      items: own,
      page: page,
      pageSize: pageSize,
      totalCount: own.length,
    );
  }

  @override
  Future<Paged<RecipeSummary>> listSaved({
    int page = 1,
    int pageSize = 20,
  }) async {
    listSavedCalls++;
    if (savedError != null) {
      throw savedError!;
    }

    return Paged(
      items: saved,
      page: page,
      pageSize: pageSize,
      totalCount: saved.length,
    );
  }

  @override
  Future<RecipeDetail> get(String id) async => details[id] ?? fakeRecipeDetail(id: id, title: 'Recipe $id');

  @override
  Future<RecipeDetail> create(RecipeWriteInput input) async {
    lastCreate = input;
    return createResult ?? fakeRecipeDetail(id: 'created-recipe', title: input.title);
  }

  @override
  Future<RecipeDetail> update(String id, RecipeWriteInput input) async {
    lastUpdate = input;
    lastUpdatedId = id;
    return updateResult ?? fakeRecipeDetail(id: id, title: input.title);
  }

  @override
  Future<void> delete(String id) async {
    lastDeletedId = id;
  }

  @override
  Future<void> save(String id, {String? collectionId}) async {
    lastSavedId = id;
    lastSavedCollectionId = collectionId;
  }

  @override
  Future<void> unsave(String id) async {
    lastUnsavedId = id;
  }

  @override
  Future<void> publish(String id) async {
    lastPublishedId = id;
  }

  @override
  Future<void> unpublish(String id) async {
    lastUnpublishedId = id;
  }

  @override
  Future<MediaUpload> upload(UploadCandidate candidate) async => throw UnimplementedError('Media upload is covered by API tests.');

  @override
  Future<Paged<CollectionSummary>> listCollections({
    int page = 1,
    int pageSize = 50,
  }) async {
    return Paged(
      items: const [],
      page: page,
      pageSize: pageSize,
      totalCount: 0,
    );
  }

  @override
  Future<CollectionSummary> createCollection({
    required String name,
    String? description,
  }) async {
    return CollectionSummary(
      id: 'collection-1',
      name: name,
      description: description,
      isDefaultFavorites: false,
      recipeCount: 0,
      createdAt: DateTime(2026, 10, 20),
    );
  }

  @override
  Future<CollectionSummary> updateCollection(
    String id, {
    required String name,
    String? description,
  }) async {
    return CollectionSummary(
      id: id,
      name: name,
      description: description,
      isDefaultFavorites: false,
      recipeCount: 0,
      createdAt: DateTime(2026, 10, 20),
    );
  }

  @override
  Future<void> deleteCollection(String id) async {}

  @override
  Future<CollectionDetail> getCollection(
    String id, {
    int page = 1,
    int pageSize = 20,
  }) async {
    return collectionDetail ??
        CollectionDetail(
          id: id,
          name: 'Collection',
          isDefaultFavorites: false,
          recipeCount: 0,
          createdAt: DateTime(2026, 10, 20),
          recipes: Paged(
            items: const [],
            page: page,
            pageSize: pageSize,
            totalCount: 0,
          ),
        );
  }

  @override
  Future<void> addToCollection(String collectionId, String recipeId) async {}

  @override
  Future<void> removeFromCollection(
    String collectionId,
    String recipeId,
  ) async {
    lastRemovedCollectionId = collectionId;
    lastRemovedRecipeId = recipeId;
  }
}
