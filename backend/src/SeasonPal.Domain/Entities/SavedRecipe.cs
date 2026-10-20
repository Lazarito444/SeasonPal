namespace SeasonPal.Domain.Entities;

/// <summary>
/// Lightweight "save" record (userId + recipeId), the warm path for recommendations;
/// collection membership is the organizing structure around it.
/// </summary>
public class SavedRecipe
{
    public Guid UserId { get; set; }

    public ApplicationUser User { get; set; } = null!;

    public Guid RecipeId { get; set; }

    public Recipe Recipe { get; set; } = null!;

    public DateTimeOffset SavedAt { get; set; } = DateTimeOffset.UtcNow;
}
