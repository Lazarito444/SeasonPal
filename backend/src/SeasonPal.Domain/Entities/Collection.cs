namespace SeasonPal.Domain.Entities;

/// <summary>User-defined grouping of recipes. Every user gets a default favorites collection.</summary>
public class Collection
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public ApplicationUser User { get; set; } = null!;

    public string Name { get; set; } = string.Empty;

    public string? Description { get; set; }

    /// <summary>True for the implicit favorites collection; one per user.</summary>
    public bool IsDefaultFavorites { get; set; }

    public List<CollectionRecipe> Items { get; set; } = [];

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
}
