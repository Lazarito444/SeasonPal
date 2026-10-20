using System.Linq.Expressions;
using SeasonPal.Application.Common;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Application.Recipes;

/// <summary>Own recipes with the library's optional filters, newest edit first.</summary>
public sealed class RecipeListSpecification : Specification<Recipe, RecipeSummaryDto>
{
    public RecipeListSpecification(
        Guid authorId,
        RecipeListFilter filter,
        int page,
        int pageSize)
        : base(page, pageSize)
    {
        var cuisine = string.IsNullOrWhiteSpace(filter.Cuisine)
            ? null
            : filter.Cuisine.Trim().ToLowerInvariant();
        var diet = string.IsNullOrWhiteSpace(filter.Diet) ? null : filter.Diet.Trim();
        var tag = string.IsNullOrWhiteSpace(filter.Tag) ? null : filter.Tag.Trim();
        var difficulty = filter.Difficulty ?? default;
        var hasDifficulty = filter.Difficulty.HasValue;
        var maxTime = filter.MaxTotalTimeMinutes ?? int.MaxValue;
        var hasMaxTime = filter.MaxTotalTimeMinutes.HasValue;

        Criteria = recipe =>
            recipe.AuthorId == authorId
            && (cuisine == null || (recipe.Cuisine != null && recipe.Cuisine.ToLower() == cuisine))
            && (!hasMaxTime
                || ((recipe.PrepTimeMinutes != null || recipe.CookTimeMinutes != null)
                    && ((recipe.PrepTimeMinutes ?? 0) + (recipe.CookTimeMinutes ?? 0)) <= maxTime))
            && (!hasDifficulty || recipe.Difficulty == difficulty)
            && (diet == null || recipe.DietaryTags.Contains(diet!))
            && (tag == null || recipe.Tags.Contains(tag!));
    }

    public override Expression<Func<Recipe, RecipeSummaryDto>> Select => recipe => new RecipeSummaryDto(
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

    public override Expression<Func<Recipe, object?>> OrderBy => recipe => recipe.UpdatedAt;

    public override bool OrderDescending => true;
}

/// <summary>The viewer's saved library, newest save first; private recipes disappear when unpublished.</summary>
public sealed class SavedRecipeListSpecification : Specification<SavedRecipe, RecipeSummaryDto>
{
    public SavedRecipeListSpecification(Guid userId, int page, int pageSize)
        : base(page, pageSize)
    {
        Criteria = saved =>
            saved.UserId == userId
            && (saved.Recipe.AuthorId == userId
                || (saved.Recipe.Visibility == RecipeVisibility.Public
                    && saved.Recipe.Status == RecipeStatus.Published));
    }

    public override Expression<Func<SavedRecipe, RecipeSummaryDto>> Select => saved => new RecipeSummaryDto(
        saved.Recipe.Id,
        saved.Recipe.Title,
        saved.Recipe.Description,
        saved.Recipe.Cuisine,
        saved.Recipe.CoverImageUrl,
        saved.Recipe.MealType,
        saved.Recipe.Servings,
        saved.Recipe.PrepTimeMinutes,
        saved.Recipe.CookTimeMinutes,
        saved.Recipe.PrepTimeMinutes == null && saved.Recipe.CookTimeMinutes == null
            ? null
            : (saved.Recipe.PrepTimeMinutes ?? 0) + (saved.Recipe.CookTimeMinutes ?? 0),
        saved.Recipe.Difficulty,
        saved.Recipe.Visibility,
        saved.Recipe.Status,
        saved.Recipe.IsAiGenerated,
        saved.Recipe.Tags,
        saved.Recipe.DietaryTags,
        saved.Recipe.AuthorId,
        saved.Recipe.Author.DisplayName,
        saved.SavedAt,
        saved.Recipe.UpdatedAt);

    public override Expression<Func<SavedRecipe, object?>> OrderBy => saved => saved.SavedAt;

    public override bool OrderDescending => true;
}
