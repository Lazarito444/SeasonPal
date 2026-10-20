using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Collections;

/// <summary>Persistence boundary for the Collection aggregate.</summary>
public interface ICollectionRepository
{
    void Add(Collection collection);

    void Remove(Collection collection);

    /// <summary>Loads collection metadata owned by the user; null means missing or not theirs.</summary>
    Task<Collection?> FindOwnedAsync(
        Guid collectionId,
        Guid userId,
        CancellationToken cancellationToken = default);

    /// <summary>Loads the aggregate with its memberships for add/remove/reorder flows.</summary>
    Task<Collection?> FindOwnedWithItemsAsync(
        Guid collectionId,
        Guid userId,
        CancellationToken cancellationToken = default);

    Task<Collection?> FindDefaultFavoritesWithItemsAsync(
        Guid userId,
        CancellationToken cancellationToken = default);

    Task<IReadOnlyList<Collection>> FindAllOwnedWithItemsAsync(
        Guid userId,
        CancellationToken cancellationToken = default);

    Task<int> CountItemsAsync(
        Guid collectionId,
        CancellationToken cancellationToken = default);

    Task<bool> NameExistsAsync(
        Guid userId,
        string normalizedName,
        Guid? excludingCollectionId = null,
        CancellationToken cancellationToken = default);
}
