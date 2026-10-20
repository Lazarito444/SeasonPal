namespace SeasonPal.Domain.Entities;

/// <summary>Ordered non-cover media attached to a recipe (photos and videos — spec §3A).</summary>
public class RecipeMedia
{
    public Guid Id { get; set; }

    public Guid RecipeId { get; set; }

    public Recipe Recipe { get; set; } = null!;

    public int Order { get; set; }

    public string Url { get; set; } = string.Empty;

    public MediaKind Kind { get; set; } = MediaKind.Image;

    /// <summary>Alt text for accessibility; required with real upload flow (Stage 4).</summary>
    public string? AltText { get; set; }

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
}
