namespace SeasonPal.Domain.Entities;

/// <summary>Ordered non-cover media of the Recipe aggregate; constructed only through the root.</summary>
public class RecipeMedia
{
    /// <summary>EF materializer.</summary>
    private RecipeMedia() { }

    public Guid Id { get; private set; }

    public Guid RecipeId { get; private set; }

    public Recipe Recipe { get; private set; } = null!;

    public int Order { get; private set; }

    public string Url { get; private set; } = null!;

    public MediaKind Kind { get; private set; }

    /// <summary>Alt text for accessibility; required once the upload flow lands (Stage 4).</summary>
    public string? AltText { get; private set; }

    public DateTimeOffset CreatedAt { get; private set; }

    internal static RecipeMedia Assemble(
        Guid recipeId,
        int order,
        string url,
        MediaKind kind,
        DateTimeOffset createdAt) => new()
    {
        RecipeId = recipeId,
        Order = order,
        Url = url,
        Kind = kind,
        AltText = null,
        CreatedAt = createdAt,
    };
}
