using SeasonPal.Domain.Common;

namespace SeasonPal.Domain.Entities;

/// <summary>
/// Aggregate root: user-defined grouping of recipes. The favorites collection is created by the
/// API at registration time, never hand-made twice.
/// </summary>
public class Collection
{
    public const int MaxNameLength = 100;

    public const int MaxDescriptionLength = 500;

    public const int MaxItems = 500;

    /// <summary>Name of the implicit favorites collection created at registration.</summary>
    public const string DefaultFavoritesName = "Favorites";

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

        var trimmedDescription = description?.Trim();
        return new Collection
        {
            UserId = userId,
            Name = normalized,
            Description = string.IsNullOrEmpty(trimmedDescription) ? null : trimmedDescription,
            IsDefaultFavorites = isDefaultFavorites,
            CreatedAt = DateTimeOffset.UtcNow,
        };
    }

    /// <summary>Renames the collection and replaces its description; favorites stay read-only.</summary>
    public Result UpdateDetails(string name, string? description)
    {
        if (IsDefaultFavorites)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "collection.favorites-protected",
                    "The favorites collection cannot be renamed or edited."));
        }

        var normalized = name?.Trim() ?? string.Empty;
        if (normalized.Length is < 1 or > MaxNameLength)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "collection.name-invalid", "Collection name must be 1–100 characters.", ("max", "100")));
        }

        var trimmedDescription = description?.Trim();
        if (trimmedDescription is { Length: > MaxDescriptionLength })
        {
            return Result.Fail(
                ApplicationError.Of(
                    "collection.description-invalid", "Description exceeds 500 characters.", ("max", "500")));
        }

        Name = normalized;
        Description = string.IsNullOrEmpty(trimmedDescription) ? null : trimmedDescription;
        return Result.Ok();
    }

    /// <summary>
    /// Adds a recipe at the end of the collection. Re-adding an existing recipe is a no-op so the
    /// save endpoint can be called repeatedly without creating duplicate memberships.
    /// </summary>
    public Result AddRecipe(Guid recipeId, DateTimeOffset? addedAt = null)
    {
        if (recipeId == Guid.Empty)
        {
            return Result.Fail(
                ApplicationError.Of("collection.recipe-required", "A recipe is required."));
        }

        if (_items.Any(item => item.RecipeId == recipeId))
        {
            return Result.Ok();
        }

        if (_items.Count >= MaxItems)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "collection.items-limit",
                    "A collection can hold at most 500 recipes.",
                    ("max", MaxItems.ToString())));
        }

        var nextOrder = _items.Count == 0 ? 1 : _items.Max(item => item.Order) + 1;
        _items.Add(
            CollectionRecipe.Assemble(
                Id,
                recipeId,
                nextOrder,
                addedAt ?? DateTimeOffset.UtcNow));
        return Result.Ok();
    }

    /// <summary>Removes a membership and closes the order gap; a missing recipe is a no-op.</summary>
    public Result RemoveRecipe(Guid recipeId)
    {
        var item = _items.FirstOrDefault(entry => entry.RecipeId == recipeId);
        if (item is null)
        {
            return Result.Ok();
        }

        _items.Remove(item);
        Renumber();
        return Result.Ok();
    }

    /// <summary>
    /// Applies a complete ordered list of recipe ids. Requiring the full set (not a move
    /// operation) keeps the client and server from disagreeing about the collection content.
    /// </summary>
    public Result Reorder(IReadOnlyList<Guid> recipeIds)
    {
        if (recipeIds is null || recipeIds.Count != _items.Count)
        {
            return Mismatch();
        }

        if (recipeIds.Distinct().Count() != recipeIds.Count)
        {
            return Mismatch();
        }

        var byRecipe = _items.ToDictionary(item => item.RecipeId);
        if (recipeIds.Any(id => !byRecipe.ContainsKey(id)))
        {
            return Mismatch();
        }

        for (var index = 0; index < recipeIds.Count; index++)
        {
            byRecipe[recipeIds[index]].SetOrder(index + 1);
        }

        return Result.Ok();
    }

    private void Renumber()
    {
        var ordered = _items.OrderBy(item => item.Order).ToList();
        for (var index = 0; index < ordered.Count; index++)
        {
            ordered[index].SetOrder(index + 1);
        }
    }

    private static Result Mismatch() =>
        Result.Fail(
            ApplicationError.Of(
                "collection.reorder-mismatch",
                "The reorder request must list every recipe in the collection exactly once."));
}
