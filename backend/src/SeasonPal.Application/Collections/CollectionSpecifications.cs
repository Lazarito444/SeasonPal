using System.Linq.Expressions;
using SeasonPal.Application.Common;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Application.Collections;

/// <summary>The user's collections with their membership counts, newest first.</summary>
public sealed class CollectionListSpecification : Specification<Collection, CollectionSummaryDto>
{
    public CollectionListSpecification(Guid userId, int page, int pageSize)
        : base(page, pageSize)
    {
        Criteria = collection => collection.UserId == userId;
    }

    public override Expression<Func<Collection, CollectionSummaryDto>> Select => collection =>
        new CollectionSummaryDto(
            collection.Id,
            collection.Name,
            collection.Description,
            collection.IsDefaultFavorites,
            collection.Items.Count,
            collection.CreatedAt);

    public override Expression<Func<Collection, object?>> OrderBy => collection => collection.CreatedAt;

    public override bool OrderDescending => true;
}

/// <summary>
/// One page of a collection's recipes in the owner's chosen order. Recipes the viewer can no
/// longer read (someone else's unpublished recipe) drop out without breaking the ordering.
/// </summary>
public sealed class CollectionRecipeListSpecification : Specification<CollectionRecipe, RecipeSummaryDto>
{
    public CollectionRecipeListSpecification(
        Guid collectionId,
        Guid viewerId,
        int page,
        int pageSize)
        : base(page, pageSize)
    {
        Criteria = item =>
            item.CollectionId == collectionId
            && (item.Recipe.AuthorId == viewerId
                || (item.Recipe.Visibility == RecipeVisibility.Public
                    && item.Recipe.Status == RecipeStatus.Published));
    }

    public override Expression<Func<CollectionRecipe, RecipeSummaryDto>> Select => item => new RecipeSummaryDto(
        item.Recipe.Id,
        item.Recipe.Title,
        item.Recipe.Description,
        item.Recipe.Cuisine,
        item.Recipe.CoverImageUrl,
        item.Recipe.MealType,
        item.Recipe.Servings,
        item.Recipe.PrepTimeMinutes,
        item.Recipe.CookTimeMinutes,
        item.Recipe.PrepTimeMinutes == null && item.Recipe.CookTimeMinutes == null
            ? null
            : (item.Recipe.PrepTimeMinutes ?? 0) + (item.Recipe.CookTimeMinutes ?? 0),
        item.Recipe.Difficulty,
        item.Recipe.Visibility,
        item.Recipe.Status,
        item.Recipe.IsAiGenerated,
        item.Recipe.Tags,
        item.Recipe.DietaryTags,
        item.Recipe.AuthorId,
        item.Recipe.Author.DisplayName,
        item.AddedAt,
        item.Recipe.UpdatedAt);

    public override Expression<Func<CollectionRecipe, object?>> OrderBy => item => item.Order;

    public override Expression<Func<CollectionRecipe, object?>>? ThenBy => item => item.AddedAt;
}
