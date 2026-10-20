/// Mirrors the backend `MealType` enum. Wire values stay explicit so enum order
/// never becomes part of the API contract.
enum MealType {
  unspecified(0),
  breakfast(1),
  lunch(2),
  dinner(3),
  snack(4),
  dessert(5),
  drink(6);

  const MealType(this.wireValue);

  final int wireValue;

  static MealType fromWire(int? value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => MealType.unspecified,
  );
}

enum RecipeDifficulty {
  easy(0),
  medium(1),
  hard(2);

  const RecipeDifficulty(this.wireValue);

  final int wireValue;

  static RecipeDifficulty fromWire(int? value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => RecipeDifficulty.easy,
  );
}

enum RecipeVisibility {
  private(0),
  public(1);

  const RecipeVisibility(this.wireValue);

  final int wireValue;

  static RecipeVisibility fromWire(int? value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => RecipeVisibility.private,
  );
}

enum RecipeStatus {
  draft(0),
  published(1),
  archived(2);

  const RecipeStatus(this.wireValue);

  final int wireValue;

  static RecipeStatus fromWire(int? value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => RecipeStatus.draft,
  );
}

enum MediaKind {
  image(0),
  video(1);

  const MediaKind(this.wireValue);

  final int wireValue;

  static MediaKind fromWire(int? value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => MediaKind.image,
  );
}

/// One page of a list endpoint.
final class Paged<T> {
  const Paged({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory Paged.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return Paged<T>(
      items: (json['items'] as List<dynamic>).map(fromJsonT).toList(growable: false),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
    );
  }

  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;

  bool get hasNextPage => page * pageSize < totalCount;
}

/// The public profile of the user who owns a recipe.
final class RecipeAuthor {
  const RecipeAuthor({required this.id, required this.displayName});

  factory RecipeAuthor.fromJson(Map<String, dynamic> json) {
    return RecipeAuthor(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
    );
  }

  final String id;
  final String displayName;
}

/// A recipe as it appears in a library or collection list.
final class RecipeSummary {
  const RecipeSummary({
    required this.id,
    required this.title,
    required this.mealType,
    required this.servings,
    required this.difficulty,
    required this.visibility,
    required this.status,
    required this.isAiGenerated,
    required this.authorId,
    required this.authorDisplayName,
    required this.updatedAt,
    this.description,
    this.cuisine,
    this.coverImageUrl,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.totalTimeMinutes,
    this.tags = const [],
    this.dietaryTags = const [],
    this.savedAt,
  });

  factory RecipeSummary.fromJson(Map<String, dynamic> json) {
    return RecipeSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      cuisine: json['cuisine'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      mealType: MealType.fromWire((json['mealType'] as num?)?.toInt()),
      servings: (json['servings'] as num).toInt(),
      prepTimeMinutes: (json['prepTimeMinutes'] as num?)?.toInt(),
      cookTimeMinutes: (json['cookTimeMinutes'] as num?)?.toInt(),
      totalTimeMinutes: (json['totalTimeMinutes'] as num?)?.toInt(),
      difficulty: RecipeDifficulty.fromWire(
        (json['difficulty'] as num?)?.toInt(),
      ),
      visibility: RecipeVisibility.fromWire(
        (json['visibility'] as num?)?.toInt(),
      ),
      status: RecipeStatus.fromWire((json['status'] as num?)?.toInt()),
      isAiGenerated: json['isAiGenerated'] as bool,
      tags: _stringList(json['tags']),
      dietaryTags: _stringList(json['dietaryTags']),
      authorId: json['authorId'] as String,
      authorDisplayName: json['authorDisplayName'] as String,
      savedAt: _dateTimeOrNull(json['savedAt']),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String id;
  final String title;
  final String? description;
  final String? cuisine;
  final String? coverImageUrl;
  final MealType mealType;
  final int servings;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? totalTimeMinutes;
  final RecipeDifficulty difficulty;
  final RecipeVisibility visibility;
  final RecipeStatus status;
  final bool isAiGenerated;
  final List<String> tags;
  final List<String> dietaryTags;
  final String authorId;
  final String authorDisplayName;
  final DateTime? savedAt;
  final DateTime updatedAt;
}

/// One ingredient row inside a recipe.
final class RecipeIngredient {
  const RecipeIngredient({
    required this.id,
    required this.order,
    required this.name,
    this.quantity,
    this.unit,
    this.note,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'] as String,
      order: (json['order'] as num).toInt(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      name: json['name'] as String,
      note: json['note'] as String?,
    );
  }

  final String id;
  final int order;
  final double? quantity;
  final String? unit;
  final String name;
  final String? note;
}

/// One numbered instruction inside a recipe.
final class RecipeStep {
  const RecipeStep({
    required this.id,
    required this.order,
    required this.instruction,
    this.tip,
    this.timerSeconds,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      id: json['id'] as String,
      order: (json['order'] as num).toInt(),
      instruction: json['instruction'] as String,
      tip: json['tip'] as String?,
      timerSeconds: (json['timerSeconds'] as num?)?.toInt(),
    );
  }

  final String id;
  final int order;
  final String instruction;
  final String? tip;
  final int? timerSeconds;
}

/// A photo or video attached to a recipe.
final class RecipeMedia {
  const RecipeMedia({
    required this.id,
    required this.order,
    required this.url,
    required this.kind,
    this.altText,
  });

  factory RecipeMedia.fromJson(Map<String, dynamic> json) {
    return RecipeMedia(
      id: json['id'] as String,
      order: (json['order'] as num).toInt(),
      url: json['url'] as String,
      kind: MediaKind.fromWire((json['kind'] as num?)?.toInt()),
      altText: json['altText'] as String?,
    );
  }

  final String id;
  final int order;
  final String url;
  final MediaKind kind;
  final String? altText;
}

/// The full recipe aggregate returned by the detail endpoint.
final class RecipeDetail {
  const RecipeDetail({
    required this.id,
    required this.author,
    required this.title,
    required this.mealType,
    required this.servings,
    required this.difficulty,
    required this.visibility,
    required this.status,
    required this.isAiGenerated,
    required this.isSaved,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.cuisine,
    this.coverImageUrl,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.totalTimeMinutes,
    this.sourceRecipeId,
    this.tags = const [],
    this.dietaryTags = const [],
    this.ingredients = const [],
    this.steps = const [],
    this.media = const [],
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      id: json['id'] as String,
      author: RecipeAuthor.fromJson(json['author'] as Map<String, dynamic>),
      title: json['title'] as String,
      description: json['description'] as String?,
      cuisine: json['cuisine'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      mealType: MealType.fromWire((json['mealType'] as num?)?.toInt()),
      servings: (json['servings'] as num).toInt(),
      prepTimeMinutes: (json['prepTimeMinutes'] as num?)?.toInt(),
      cookTimeMinutes: (json['cookTimeMinutes'] as num?)?.toInt(),
      totalTimeMinutes: (json['totalTimeMinutes'] as num?)?.toInt(),
      difficulty: RecipeDifficulty.fromWire(
        (json['difficulty'] as num?)?.toInt(),
      ),
      visibility: RecipeVisibility.fromWire(
        (json['visibility'] as num?)?.toInt(),
      ),
      status: RecipeStatus.fromWire((json['status'] as num?)?.toInt()),
      isAiGenerated: json['isAiGenerated'] as bool,
      sourceRecipeId: json['sourceRecipeId'] as String?,
      tags: _stringList(json['tags']),
      dietaryTags: _stringList(json['dietaryTags']),
      ingredients: _objectList(json['ingredients'], RecipeIngredient.fromJson),
      steps: _objectList(json['steps'], RecipeStep.fromJson),
      media: _objectList(json['media'], RecipeMedia.fromJson),
      isSaved: json['isSaved'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String id;
  final RecipeAuthor author;
  final String title;
  final String? description;
  final String? cuisine;
  final String? coverImageUrl;
  final MealType mealType;
  final int servings;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? totalTimeMinutes;
  final RecipeDifficulty difficulty;
  final RecipeVisibility visibility;
  final RecipeStatus status;
  final bool isAiGenerated;
  final String? sourceRecipeId;
  final List<String> tags;
  final List<String> dietaryTags;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final List<RecipeMedia> media;
  final bool isSaved;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// A collection as it appears in the collection picker.
final class CollectionSummary {
  const CollectionSummary({
    required this.id,
    required this.name,
    required this.isDefaultFavorites,
    required this.recipeCount,
    required this.createdAt,
    this.description,
  });

  factory CollectionSummary.fromJson(Map<String, dynamic> json) {
    return CollectionSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isDefaultFavorites: json['isDefaultFavorites'] as bool,
      recipeCount: (json['recipeCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String name;
  final String? description;
  final bool isDefaultFavorites;
  final int recipeCount;
  final DateTime createdAt;
}

/// A collection plus its first page of recipes. Parsed by the repository because
/// the nested page is generic and not worth a dedicated DTO layer.
final class CollectionDetail {
  const CollectionDetail({
    required this.id,
    required this.name,
    required this.isDefaultFavorites,
    required this.recipeCount,
    required this.createdAt,
    required this.recipes,
    this.description,
  });

  final String id;
  final String name;
  final String? description;
  final bool isDefaultFavorites;
  final int recipeCount;
  final DateTime createdAt;
  final Paged<RecipeSummary> recipes;
}

/// The storage receipt returned after a media file is uploaded.
final class MediaUpload {
  const MediaUpload({
    required this.url,
    required this.kind,
    required this.contentType,
    required this.sizeBytes,
  });

  factory MediaUpload.fromJson(Map<String, dynamic> json) {
    return MediaUpload(
      url: json['url'] as String,
      kind: MediaKind.fromWire((json['kind'] as num?)?.toInt()),
      contentType: json['contentType'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
    );
  }

  final String url;
  final MediaKind kind;
  final String contentType;
  final int sizeBytes;
}

/// The complete editable form sent to `POST /recipes` and `PUT /recipes/{id}`.
final class RecipeWriteInput {
  const RecipeWriteInput({
    required this.title,
    required this.mealType,
    required this.servings,
    required this.difficulty,
    this.description,
    this.cuisine,
    this.coverImageUrl,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.tags = const [],
    this.dietaryTags = const [],
    this.ingredients = const [],
    this.steps = const [],
    this.media = const [],
  });

  final String title;
  final String? description;
  final String? cuisine;
  final String? coverImageUrl;
  final List<String> tags;
  final List<String> dietaryTags;
  final MealType mealType;
  final int servings;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final RecipeDifficulty difficulty;
  final List<RecipeIngredientInput> ingredients;
  final List<RecipeStepInput> steps;
  final List<RecipeMediaInput> media;

  Map<String, Object?> toJson() => {
    'title': title,
    'description': description,
    'cuisine': cuisine,
    'coverImageUrl': coverImageUrl,
    'tags': tags,
    'dietaryTags': dietaryTags,
    'mealType': mealType.wireValue,
    'servings': servings,
    'prepTimeMinutes': prepTimeMinutes,
    'cookTimeMinutes': cookTimeMinutes,
    'difficulty': difficulty.wireValue,
    'ingredients': ingredients.map((item) => item.toJson()).toList(),
    'steps': steps.map((item) => item.toJson()).toList(),
    'media': media.map((item) => item.toJson()).toList(),
  };
}

final class RecipeIngredientInput {
  const RecipeIngredientInput({
    required this.name,
    this.quantity,
    this.unit,
    this.note,
  });

  final double? quantity;
  final String? unit;
  final String name;
  final String? note;

  Map<String, Object?> toJson() => {
    'quantity': quantity,
    'unit': unit,
    'name': name,
    'note': note,
  };
}

final class RecipeStepInput {
  const RecipeStepInput({
    required this.instruction,
    this.tip,
    this.timerSeconds,
  });

  final String instruction;
  final String? tip;
  final int? timerSeconds;

  Map<String, Object?> toJson() => {
    'instruction': instruction,
    'tip': tip,
    'timerSeconds': timerSeconds,
  };
}

final class RecipeMediaInput {
  const RecipeMediaInput({required this.url, required this.kind, this.altText});

  final String url;
  final MediaKind kind;
  final String? altText;

  Map<String, Object?> toJson() => {
    'url': url,
    'kind': kind.wireValue,
    'altText': altText,
  };
}

List<String> _stringList(Object? value) {
  if (value == null) {
    return const [];
  }

  return (value as List<dynamic>).map((item) => item as String).toList(growable: false);
}

List<T> _objectList<T>(
  Object? value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (value == null) {
    return const [];
  }

  return (value as List<dynamic>).map((item) => fromJson(item as Map<String, dynamic>)).toList(growable: false);
}

DateTime? _dateTimeOrNull(Object? value) {
  return value == null ? null : DateTime.parse(value as String);
}
