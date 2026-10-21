using System.Linq.Expressions;
using SeasonPal.Application.Common;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Application.Discovery;

/// <summary>
/// Public, published recipes with the discovery filters applied. Text search is a
/// case-insensitive substring match across title, description and ingredient names; when a
/// search term is present, title matches rank above description and ingredient matches.
/// </summary>
public sealed class DiscoveryFeedSpecification : Specification<Recipe, RecipeSummaryDto>
{
    private readonly Expression<Func<Recipe, object?>> _orderBy;

    public DiscoveryFeedSpecification(
        DiscoveryFeedFilter filter,
        int page,
        int pageSize)
        : base(page, pageSize)
    {
        var search = string.IsNullOrWhiteSpace(filter.Search)
            ? null
            : filter.Search.Trim().ToLowerInvariant();
        var cuisine = string.IsNullOrWhiteSpace(filter.Cuisine)
            ? null
            : filter.Cuisine.Trim().ToLowerInvariant();
        var diet = string.IsNullOrWhiteSpace(filter.Diet) ? null : filter.Diet.Trim();
        var mealType = filter.MealType ?? default;
        var hasMealType = filter.MealType.HasValue;
        var difficulty = filter.Difficulty ?? default;
        var hasDifficulty = filter.Difficulty.HasValue;
        var maxTime = filter.MaxTotalTimeMinutes ?? int.MaxValue;
        var hasMaxTime = filter.MaxTotalTimeMinutes.HasValue;

        Criteria = recipe =>
            recipe.Visibility == RecipeVisibility.Public
            && recipe.Status == RecipeStatus.Published
            && (cuisine == null
                || (recipe.Cuisine != null && recipe.Cuisine.ToLower() == cuisine))
            && (!hasMaxTime
                || ((recipe.PrepTimeMinutes != null || recipe.CookTimeMinutes != null)
                    && ((recipe.PrepTimeMinutes ?? 0) + (recipe.CookTimeMinutes ?? 0)) <= maxTime))
            && (!hasDifficulty || recipe.Difficulty == difficulty)
            && (!hasMealType || recipe.MealType == mealType)
            && (diet == null || recipe.DietaryTags.Contains(diet))
            && (search == null
                || recipe.Title.ToLower().Contains(search)
                || (recipe.Description != null && recipe.Description.ToLower().Contains(search))
                || recipe.Ingredients.Any(ingredient => ingredient.Name.ToLower().Contains(search)));

        // A search ranks a title hit above a description hit above an ingredient hit. Without a
        // term the feed is simply the newest public dishes.
        _orderBy = search == null
            ? recipe => recipe.CreatedAt
            : recipe =>
                (recipe.Title.ToLower().Contains(search) ? 3 : 0)
                + (recipe.Description != null && recipe.Description.ToLower().Contains(search) ? 2 : 0)
                + recipe.Ingredients.Count(ingredient => ingredient.Name.ToLower().Contains(search));
    }

    public override bool OrderDescending => true;

    public override Expression<Func<Recipe, RecipeSummaryDto>> Select =>
        RecipeSummaryProjection.Expression;

    public override Expression<Func<Recipe, object?>> OrderBy => _orderBy;

    public override Expression<Func<Recipe, object?>>? ThenBy => recipe => recipe.CreatedAt;

    public override bool ThenByDescending => true;
}
