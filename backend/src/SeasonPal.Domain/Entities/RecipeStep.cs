namespace SeasonPal.Domain.Entities;

/// <summary>Ordered preparation step. <see cref="TimerSeconds"/> drives cooking-mode timers when present.</summary>
public class RecipeStep
{
    public Guid Id { get; set; }

    public Guid RecipeId { get; set; }

    public Recipe Recipe { get; set; } = null!;

    public int Order { get; set; }

    public string Instruction { get; set; } = string.Empty;

    public string? Tip { get; set; }

    public int? TimerSeconds { get; set; }
}
