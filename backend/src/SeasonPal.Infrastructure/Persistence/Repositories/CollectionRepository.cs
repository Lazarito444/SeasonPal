using Microsoft.EntityFrameworkCore;
using SeasonPal.Application.Collections;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence.Repositories;

public sealed class CollectionRepository(SeasonPalDbContext context) : ICollectionRepository
{
    public void Add(Collection collection) => context.Collections.Add(collection);

    public void Remove(Collection collection) => context.Collections.Remove(collection);

    public Task<Collection?> FindOwnedAsync(
        Guid collectionId,
        Guid userId,
        CancellationToken cancellationToken = default) =>
        context.Collections.SingleOrDefaultAsync(
            collection => collection.Id == collectionId && collection.UserId == userId,
            cancellationToken);

    public Task<Collection?> FindOwnedWithItemsAsync(
        Guid collectionId,
        Guid userId,
        CancellationToken cancellationToken = default) =>
        context.Collections
            .Include(collection => collection.Items)
            .SingleOrDefaultAsync(
                collection => collection.Id == collectionId && collection.UserId == userId,
                cancellationToken);

    public Task<Collection?> FindDefaultFavoritesWithItemsAsync(
        Guid userId,
        CancellationToken cancellationToken = default) =>
        context.Collections
            .Include(collection => collection.Items)
            .SingleOrDefaultAsync(
                collection => collection.UserId == userId && collection.IsDefaultFavorites,
                cancellationToken);

    public async Task<IReadOnlyList<Collection>> FindAllOwnedWithItemsAsync(
        Guid userId,
        CancellationToken cancellationToken = default) =>
        await context.Collections
            .Include(collection => collection.Items)
            .Where(collection => collection.UserId == userId)
            .ToListAsync(cancellationToken);

    public Task<int> CountItemsAsync(
        Guid collectionId,
        CancellationToken cancellationToken = default) =>
        context.CollectionRecipes.CountAsync(
            item => item.CollectionId == collectionId,
            cancellationToken);

    public Task<bool> NameExistsAsync(
        Guid userId,
        string normalizedName,
        Guid? excludingCollectionId = null,
        CancellationToken cancellationToken = default)
    {
        var excluded = excludingCollectionId ?? Guid.Empty;
        return context.Collections.AnyAsync(
            collection => collection.UserId == userId
                && collection.Id != excluded
                && collection.Name.ToLower() == normalizedName,
            cancellationToken);
    }
}
