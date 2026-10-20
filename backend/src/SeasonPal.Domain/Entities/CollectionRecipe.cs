namespace SeasonPal.Domain.Entities;

/// <summary>Membership of a recipe inside a collection (many-to-many with order informative added-at).</summary>
public class CollectionRecipe
{
    public Guid CollectionId { get; set; }

    public Collection Collection { get; set; } = null!;

    public Guid RecipeId { get; set; }

    public Recipe Recipe { get; set; } = null!;

    public DateTimeOffset AddedAt { get; set; } = DateTimeOffset.UtcNow;
}
