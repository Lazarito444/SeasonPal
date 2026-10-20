namespace SeasonPal.Domain.Entities;

/// <summary>Record of an actual cooking session, feeding personalization (Stage 9).</summary>
public class CookingHistoryEntry
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public ApplicationUser User { get; set; } = null!;

    public Guid RecipeId { get; set; }

    public Recipe Recipe { get; set; } = null!;

    public DateTimeOffset CookedAt { get; set; } = DateTimeOffset.UtcNow;

    public int ServingsMade { get; set; }

    public string? Notes { get; set; }
}
