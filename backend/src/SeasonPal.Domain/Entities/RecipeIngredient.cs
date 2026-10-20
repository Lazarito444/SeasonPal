namespace SeasonPal.Domain.Entities;

/// <summary>Ordered ingredient line within the Recipe aggregate; constructed only through the root.</summary>
public class RecipeIngredient
{
    /// <summary>EF materializer.</summary>
    private RecipeIngredient() { }

    public Guid Id { get; private set; }

    public Guid RecipeId { get; private set; }

    public Recipe Recipe { get; private set; } = null!;

    public int Order { get; private set; }

    /// <summary>Null for "to taste"-style entries.</summary>
    public double? Quantity { get; private set; }

    public string? Unit { get; private set; }

    public string Name { get; private set; } = null!;

    public string? Note { get; private set; }

    internal static RecipeIngredient Assemble(
        Guid recipeId,
        int order,
        double? quantity,
        string? unit,
        string name,
        string? note) => new()
    {
        RecipeId = recipeId,
        Order = order,
        Quantity = quantity,
        Unit = unit,
        Name = name,
        Note = note,
    };
}
