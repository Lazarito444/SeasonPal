using SeasonPal.Domain.Enums;

namespace SeasonPal.Domain.Entities;

/// <summary>Scalar fields of a recipe; used by the create/update flows to validate once.</summary>
public sealed record RecipeDetails(
    string Title,
    string? Description,
    string? Cuisine,
    string? CoverImageUrl,
    IReadOnlyList<string>? Tags,
    IReadOnlyList<string>? DietaryTags,
    MealType MealType,
    int Servings,
    int? PrepTimeMinutes,
    int? CookTimeMinutes,
    RecipeDifficulty Difficulty);

/// <summary>Ingredient line supplied by an edit form; the aggregate owns validation and ordering.</summary>
public sealed record IngredientDraft(double? Quantity, string? Unit, string Name, string? Note);

/// <summary>Preparation step supplied by an edit form; the aggregate owns validation and ordering.</summary>
public sealed record StepDraft(string Instruction, string? Tip, int? TimerSeconds);

/// <summary>Photo or video supplied by an edit form; the aggregate owns validation and ordering.</summary>
public sealed record MediaDraft(string Url, MediaKind Kind, string? AltText);
