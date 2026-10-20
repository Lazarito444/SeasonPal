using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Recipes;

/// <summary>
/// The lightweight saved-library record behind favorites and recommendations. Collection
/// membership is organized by the Collection aggregate; this record answers "is it saved".
/// </summary>
public interface ISavedRecipeRepository
{
    Task<SavedRecipe?> FindAsync(
        Guid userId,
        Guid recipeId,
        CancellationToken cancellationToken = default);

    Task<bool> ExistsAsync(
        Guid userId,
        Guid recipeId,
        CancellationToken cancellationToken = default);

    void Add(SavedRecipe savedRecipe);

    void Remove(SavedRecipe savedRecipe);
}
