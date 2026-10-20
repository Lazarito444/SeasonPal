using Microsoft.EntityFrameworkCore;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence.Repositories;

public sealed class SavedRecipeRepository(SeasonPalDbContext context) : ISavedRecipeRepository
{
    public Task<SavedRecipe?> FindAsync(
        Guid userId,
        Guid recipeId,
        CancellationToken cancellationToken = default) =>
        context.SavedRecipes.SingleOrDefaultAsync(
            saved => saved.UserId == userId && saved.RecipeId == recipeId,
            cancellationToken);

    public Task<bool> ExistsAsync(
        Guid userId,
        Guid recipeId,
        CancellationToken cancellationToken = default) =>
        context.SavedRecipes.AnyAsync(
            saved => saved.UserId == userId && saved.RecipeId == recipeId,
            cancellationToken);

    public void Add(SavedRecipe savedRecipe) => context.SavedRecipes.Add(savedRecipe);

    public void Remove(SavedRecipe savedRecipe) => context.SavedRecipes.Remove(savedRecipe);
}
