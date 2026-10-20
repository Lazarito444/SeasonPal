using Microsoft.EntityFrameworkCore;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Infrastructure.Persistence.Repositories;

public sealed class RecipeRepository(SeasonPalDbContext context) : IRecipeRepository
{
    public void Add(Recipe recipe) => context.Recipes.Add(recipe);

    public void Remove(Recipe recipe) => context.Recipes.Remove(recipe);

    public Task<Recipe?> FindWithDetailsAsync(
        Guid recipeId,
        CancellationToken cancellationToken = default) =>
        context.Recipes
            .Include(recipe => recipe.Author)
            .Include(recipe => recipe.Ingredients)
            .Include(recipe => recipe.Steps)
            .Include(recipe => recipe.Media)
            .AsSplitQuery()
            .SingleOrDefaultAsync(recipe => recipe.Id == recipeId, cancellationToken);

    public Task<bool> IsAccessibleAsync(
        Guid recipeId,
        Guid userId,
        CancellationToken cancellationToken = default) =>
        context.Recipes.AnyAsync(
            recipe => recipe.Id == recipeId
                && (recipe.AuthorId == userId
                    || (recipe.Visibility == RecipeVisibility.Public
                        && recipe.Status == RecipeStatus.Published)),
            cancellationToken);
}
