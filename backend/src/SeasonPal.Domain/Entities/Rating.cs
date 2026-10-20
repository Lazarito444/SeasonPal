namespace SeasonPal.Domain.Entities;

/// <summary>1–5 star rating by one user for one recipe.</summary>
public class Rating
{
    public Guid UserId { get; set; }

    public ApplicationUser User { get; set; } = null!;

    public Guid RecipeId { get; set; }

    public Recipe Recipe { get; set; } = null!;

    public int Stars { get; set; }

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;
}
