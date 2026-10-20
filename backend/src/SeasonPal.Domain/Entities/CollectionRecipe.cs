namespace SeasonPal.Domain.Entities;

/// <summary>
/// Membership of a recipe inside a collection. The root controls insertion, removal and ordering,
/// so the stored order always matches what the owner sees.
/// </summary>
public class CollectionRecipe
{
    /// <summary>EF materializer.</summary>
    private CollectionRecipe() { }

    public Guid CollectionId { get; private set; }

    public Collection Collection { get; private set; } = null!;

    public Guid RecipeId { get; private set; }

    public Recipe Recipe { get; private set; } = null!;

    /// <summary>Contiguous position within the collection, starting at 1.</summary>
    public int Order { get; private set; }

    public DateTimeOffset AddedAt { get; private set; }

    internal static CollectionRecipe Assemble(
        Guid collectionId,
        Guid recipeId,
        int order,
        DateTimeOffset addedAt) => new()
    {
        CollectionId = collectionId,
        RecipeId = recipeId,
        Order = order,
        AddedAt = addedAt,
    };

    internal void SetOrder(int order) => Order = order;
}
