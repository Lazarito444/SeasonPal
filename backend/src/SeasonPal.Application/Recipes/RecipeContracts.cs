using System.Linq.Expressions;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Application.Recipes;

/// <summary>Fields an author can write; publication and AI provenance are separate transitions.</summary>
public sealed record RecipeWriteRequest(
    string? Title,
    string? Description,
    string? Cuisine,
    string? CoverImageUrl,
    IReadOnlyList<string>? Tags,
    IReadOnlyList<string>? DietaryTags,
    MealType MealType,
    int Servings,
    int? PrepTimeMinutes,
    int? CookTimeMinutes,
    RecipeDifficulty Difficulty,
    IReadOnlyList<RecipeIngredientInput>? Ingredients,
    IReadOnlyList<RecipeStepInput>? Steps,
    IReadOnlyList<RecipeMediaInput>? Media);

public sealed record RecipeIngredientInput(
    double? Quantity,
    string? Unit,
    string? Name,
    string? Note);

public sealed record RecipeStepInput(
    string? Instruction,
    string? Tip,
    int? TimerSeconds);

public sealed record RecipeMediaInput(
    string? Url,
    MediaKind Kind,
    string? AltText);

/// <summary>Owner-facing row shape for the personal library and saved list.</summary>
public sealed record RecipeSummaryDto(
    Guid Id,
    string Title,
    string? Description,
    string? Cuisine,
    string? CoverImageUrl,
    MealType MealType,
    int Servings,
    int? PrepTimeMinutes,
    int? CookTimeMinutes,
    int? TotalTimeMinutes,
    RecipeDifficulty Difficulty,
    RecipeVisibility Visibility,
    RecipeStatus Status,
    bool IsAiGenerated,
    IReadOnlyList<string> Tags,
    IReadOnlyList<string> DietaryTags,
    Guid AuthorId,
    string AuthorDisplayName,
    DateTimeOffset? SavedAt,
    DateTimeOffset UpdatedAt)
{
    /// <summary>In-memory mapping for rows that were materialized with their ingredients.</summary>
    public static RecipeSummaryDto From(Recipe recipe, DateTimeOffset? savedAt = null) => new(
        recipe.Id,
        recipe.Title,
        recipe.Description,
        recipe.Cuisine,
        recipe.CoverImageUrl,
        recipe.MealType,
        recipe.Servings,
        recipe.PrepTimeMinutes,
        recipe.CookTimeMinutes,
        recipe.TotalTimeMinutes,
        recipe.Difficulty,
        recipe.Visibility,
        recipe.Status,
        recipe.IsAiGenerated,
        recipe.Tags,
        recipe.DietaryTags,
        recipe.AuthorId,
        recipe.Author?.DisplayName ?? string.Empty,
        savedAt,
        recipe.UpdatedAt);
}

/// <summary>
/// The SQL-translatable summary projection shared by every recipe list, so discovery and the
/// library cannot drift in field order or shape.
/// </summary>
public static class RecipeSummaryProjection
{
    public static readonly Expression<Func<Recipe, RecipeSummaryDto>> Expression = recipe =>
        new RecipeSummaryDto(
            recipe.Id,
            recipe.Title,
            recipe.Description,
            recipe.Cuisine,
            recipe.CoverImageUrl,
            recipe.MealType,
            recipe.Servings,
            recipe.PrepTimeMinutes,
            recipe.CookTimeMinutes,
            recipe.PrepTimeMinutes == null && recipe.CookTimeMinutes == null
                ? null
                : (recipe.PrepTimeMinutes ?? 0) + (recipe.CookTimeMinutes ?? 0),
            recipe.Difficulty,
            recipe.Visibility,
            recipe.Status,
            recipe.IsAiGenerated,
            recipe.Tags,
            recipe.DietaryTags,
            recipe.AuthorId,
            recipe.Author.DisplayName,
            null,
            recipe.UpdatedAt);
}

public sealed record RecipeAuthorDto(Guid Id, string DisplayName);

public sealed record RecipeIngredientDto(
    Guid Id,
    int Order,
    double? Quantity,
    string? Unit,
    string Name,
    string? Note);

public sealed record RecipeStepDto(
    Guid Id,
    int Order,
    string Instruction,
    string? Tip,
    int? TimerSeconds);

public sealed record RecipeMediaDto(
    Guid Id,
    int Order,
    string Url,
    MediaKind Kind,
    string? AltText);

/// <summary>Complete editable recipe shape, including the current viewer's saved state.</summary>
public sealed record RecipeDetailDto(
    Guid Id,
    RecipeAuthorDto Author,
    string Title,
    string? Description,
    string? Cuisine,
    string? CoverImageUrl,
    MealType MealType,
    int Servings,
    int? PrepTimeMinutes,
    int? CookTimeMinutes,
    int? TotalTimeMinutes,
    RecipeDifficulty Difficulty,
    RecipeVisibility Visibility,
    RecipeStatus Status,
    bool IsAiGenerated,
    Guid? SourceRecipeId,
    IReadOnlyList<string> Tags,
    IReadOnlyList<string> DietaryTags,
    IReadOnlyList<RecipeIngredientDto> Ingredients,
    IReadOnlyList<RecipeStepDto> Steps,
    IReadOnlyList<RecipeMediaDto> Media,
    bool IsSaved,
    DateTimeOffset CreatedAt,
    DateTimeOffset UpdatedAt)
{
    public static RecipeDetailDto From(Recipe recipe, bool isSaved) => new(
        recipe.Id,
        new RecipeAuthorDto(recipe.AuthorId, recipe.Author?.DisplayName ?? string.Empty),
        recipe.Title,
        recipe.Description,
        recipe.Cuisine,
        recipe.CoverImageUrl,
        recipe.MealType,
        recipe.Servings,
        recipe.PrepTimeMinutes,
        recipe.CookTimeMinutes,
        recipe.TotalTimeMinutes,
        recipe.Difficulty,
        recipe.Visibility,
        recipe.Status,
        recipe.IsAiGenerated,
        recipe.SourceRecipeId,
        recipe.Tags,
        recipe.DietaryTags,
        recipe.Ingredients
            .OrderBy(ingredient => ingredient.Order)
            .Select(ingredient => new RecipeIngredientDto(
                ingredient.Id,
                ingredient.Order,
                ingredient.Quantity,
                ingredient.Unit,
                ingredient.Name,
                ingredient.Note))
            .ToList(),
        recipe.Steps
            .OrderBy(step => step.Order)
            .Select(step => new RecipeStepDto(
                step.Id,
                step.Order,
                step.Instruction,
                step.Tip,
                step.TimerSeconds))
            .ToList(),
        recipe.Media
            .OrderBy(media => media.Order)
            .Select(media => new RecipeMediaDto(
                media.Id,
                media.Order,
                media.Url,
                media.Kind,
                media.AltText))
            .ToList(),
        isSaved,
        recipe.CreatedAt,
        recipe.UpdatedAt);
}

/// <summary>Filters accepted by the personal recipe list; every field is optional.</summary>
public sealed record RecipeListFilter(
    string? Cuisine,
    int? MaxTotalTimeMinutes,
    RecipeDifficulty? Difficulty,
    string? Diet,
    string? Tag);
