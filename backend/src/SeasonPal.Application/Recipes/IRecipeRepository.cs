using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Recipes;

/// <summary>Persistence boundary for the Recipe aggregate.</summary>
public interface IRecipeRepository
{
    void Add(Recipe recipe);

    void Remove(Recipe recipe);

    /// <summary>Loads the aggregate with author, ingredients, steps and media for editing or detail.</summary>
    Task<Recipe?> FindWithDetailsAsync(Guid recipeId, CancellationToken cancellationToken = default);

    /// <summary>Owner or reader of a published public recipe; private drafts stay invisible to others.</summary>
    Task<bool> IsAccessibleAsync(
        Guid recipeId,
        Guid userId,
        CancellationToken cancellationToken = default);
}
