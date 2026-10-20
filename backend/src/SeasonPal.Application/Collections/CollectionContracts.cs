using SeasonPal.Application.Common;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Collections;

public sealed record CollectionSummaryDto(
    Guid Id,
    string Name,
    string? Description,
    bool IsDefaultFavorites,
    int RecipeCount,
    DateTimeOffset CreatedAt)
{
    public static CollectionSummaryDto From(Collection collection, int recipeCount) => new(
        collection.Id,
        collection.Name,
        collection.Description,
        collection.IsDefaultFavorites,
        recipeCount,
        collection.CreatedAt);
}

/// <summary>Collection metadata plus one page of its visible recipes, in display order.</summary>
public sealed record CollectionDetailDto(
    Guid Id,
    string Name,
    string? Description,
    bool IsDefaultFavorites,
    int RecipeCount,
    DateTimeOffset CreatedAt,
    PagedResult<RecipeSummaryDto> Recipes);

public sealed record CreateCollectionRequest(string? Name, string? Description);

public sealed record UpdateCollectionRequest(string? Name, string? Description);

public sealed record ReorderCollectionRequest(IReadOnlyList<Guid>? RecipeIds);
