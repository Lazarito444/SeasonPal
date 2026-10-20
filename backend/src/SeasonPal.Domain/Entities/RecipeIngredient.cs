namespace SeasonPal.Domain.Entities;

/// <summary>Ordered ingredient line. <see cref="Quantity"/> is null for "to taste"-style entries.</summary>
public class RecipeIngredient
{
    public Guid Id { get; set; }

    public Guid RecipeId { get; set; }

    public Recipe Recipe { get; set; } = null!;

    public int Order { get; set; }

    public double? Quantity { get; set; }

    public string? Unit { get; set; }

    public string Name { get; set; } = string.Empty;

    public string? Note { get; set; }
}
