using SeasonPal.Application.Collections;
using SeasonPal.Application.Common;
using SeasonPal.Domain.Common;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Recipes;

/// <summary>
/// Saving crosses two aggregate boundaries (the lightweight saved record and the favorites /
/// custom collections), so it lives in a dedicated flow instead of an endpoint or either
/// repository. Every method is idempotent: repeating a save or unsave is safe.
/// </summary>
public sealed class RecipeLibraryService(
    IRecipeRepository recipes,
    ICollectionRepository collections,
    ISavedRecipeRepository savedRecipes,
    IUnitOfWork unitOfWork)
{
    /// <summary>
    /// Saves a recipe to the library, always adding it to favorites and optionally to one custom
    /// collection in the same unit of work.
    /// </summary>
    public async Task<Result> SaveAsync(
        Guid userId,
        Guid recipeId,
        Guid? collectionId = null,
        CancellationToken cancellationToken = default)
    {
        if (!await recipes.IsAccessibleAsync(recipeId, userId, cancellationToken))
        {
            return Result.Fail(ApplicationError.Of("recipe.not-found", "Recipe not found."));
        }

        Collection? target = null;
        if (collectionId.HasValue)
        {
            target = collectionId.Value == Guid.Empty
                ? null
                : await collections.FindOwnedWithItemsAsync(collectionId.Value, userId, cancellationToken);

            if (target is null)
            {
                return Result.Fail(ApplicationError.Of("collection.not-found", "Collection not found."));
            }
        }

        var favorites = await collections.FindDefaultFavoritesWithItemsAsync(userId, cancellationToken);
        if (favorites is null)
        {
            var created = Collection.Create(
                userId,
                Collection.DefaultFavoritesName,
                isDefaultFavorites: true);

            if (!created.IsSuccess)
            {
                return Result.Fail(created.Error!);
            }

            favorites = created.Value;
            collections.Add(favorites);
        }

        if (!await savedRecipes.ExistsAsync(userId, recipeId, cancellationToken))
        {
            savedRecipes.Add(
                new SavedRecipe
                {
                    UserId = userId,
                    RecipeId = recipeId,
                    SavedAt = DateTimeOffset.UtcNow,
                });
        }

        var favoriteAdd = favorites.AddRecipe(recipeId);
        if (!favoriteAdd.IsSuccess)
        {
            return favoriteAdd;
        }

        if (target is not null && target.Id != favorites.Id)
        {
            var targetAdd = target.AddRecipe(recipeId);
            if (!targetAdd.IsSuccess)
            {
                return targetAdd;
            }
        }

        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Result.Ok();
    }

    /// <summary>
    /// Removes the recipe from the saved library everywhere: the saved record, favorites and
    /// every custom collection. Removing it from one custom collection uses the collection
    /// endpoint instead and keeps favorites intact.
    /// </summary>
    public async Task<Result> UnsaveAsync(
        Guid userId,
        Guid recipeId,
        CancellationToken cancellationToken = default)
    {
        var ownedCollections = await collections.FindAllOwnedWithItemsAsync(userId, cancellationToken);
        foreach (var collection in ownedCollections)
        {
            var removal = collection.RemoveRecipe(recipeId);
            if (!removal.IsSuccess)
            {
                return removal;
            }
        }

        var saved = await savedRecipes.FindAsync(userId, recipeId, cancellationToken);
        if (saved is not null)
        {
            savedRecipes.Remove(saved);
        }

        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Result.Ok();
    }

    /// <summary>
    /// Removes a recipe from one collection. Removing it from favorites is a full unsave so the
    /// saved flag and the favorites list can never disagree.
    /// </summary>
    public async Task<Result> RemoveFromCollectionAsync(
        Guid userId,
        Guid collectionId,
        Guid recipeId,
        CancellationToken cancellationToken = default)
    {
        var collection = await collections.FindOwnedWithItemsAsync(collectionId, userId, cancellationToken);
        if (collection is null)
        {
            return Result.Fail(ApplicationError.Of("collection.not-found", "Collection not found."));
        }

        if (collection.IsDefaultFavorites)
        {
            return await UnsaveAsync(userId, recipeId, cancellationToken);
        }

        var removal = collection.RemoveRecipe(recipeId);
        if (!removal.IsSuccess)
        {
            return removal;
        }

        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Result.Ok();
    }
}
