namespace SeasonPal.Domain.Entities;

/// <summary>Ordered preparation step within the Recipe aggregate; constructed only through the root.</summary>
public class RecipeStep
{
    /// <summary>EF materializer.</summary>
    private RecipeStep() { }

    public Guid Id { get; private set; }

    public Guid RecipeId { get; private set; }

    public Recipe Recipe { get; private set; } = null!;

    public int Order { get; private set; }

    public string Instruction { get; private set; } = null!;

    public string? Tip { get; private set; }

    /// <summary>Drives cooking-mode timers when present.</summary>
    public int? TimerSeconds { get; private set; }

    internal static RecipeStep Assemble(
        Guid recipeId,
        int order,
        string instruction,
        string? tip,
        int? timerSeconds) => new()
    {
        RecipeId = recipeId,
        Order = order,
        Instruction = instruction,
        Tip = tip,
        TimerSeconds = timerSeconds,
    };
}
