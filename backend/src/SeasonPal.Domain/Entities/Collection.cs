using SeasonPal.Domain.Common;

namespace SeasonPal.Domain.Entities;

/// <summary>
/// Aggregate root: user-defined grouping of recipes. The favorites collection is created by the
/// API at registration time, never hand-made twice.
/// </summary>
public class Collection
{
    private const int MaxNameLength = 100;
    private const int MaxDescriptionLength = 500;

    private readonly List<CollectionRecipe> _items = [];

    /// <summary>EF materializer.</summary>
    private Collection() { }

    public Guid Id { get; private set; }

    public Guid UserId { get; private set; }

    public ApplicationUser User { get; private set; } = null!;

    public string Name { get; private set; } = null!;

    public string? Description { get; private set; }

    /// <summary>True for the implicit favorites collection; one per user.</summary>
    public bool IsDefaultFavorites { get; private set; }

    public IReadOnlyList<CollectionRecipe> Items => _items;

    public DateTimeOffset CreatedAt { get; private set; }

    public static Result<Collection> Create(
        Guid userId,
        string name,
        string? description = null,
        bool isDefaultFavorites = false)
    {
        if (userId == Guid.Empty)
        {
            return Result<Collection>.Fail(
                ApplicationError.Of("collection.owner-required", "A collection must belong to a user."));
        }

        var normalized = name?.Trim() ?? string.Empty;
        if (normalized.Length is < 1 or > MaxNameLength)
        {
            return Result<Collection>.Fail(
                ApplicationError.Of(
                    "collection.name-invalid", "Collection name must be 1–100 characters.", ("max", "100")));
        }

        if (!string.IsNullOrEmpty(description) && description.Length > MaxDescriptionLength)
        {
            return Result<Collection>.Fail(
                ApplicationError.Of(
                    "collection.description-invalid", "Description exceeds 500 characters.", ("max", "500")));
        }

        return new Collection
        {
            UserId = userId,
            Name = normalized,
            Description = description,
            IsDefaultFavorites = isDefaultFavorites,
            CreatedAt = DateTimeOffset.UtcNow,
        };
    }
}
