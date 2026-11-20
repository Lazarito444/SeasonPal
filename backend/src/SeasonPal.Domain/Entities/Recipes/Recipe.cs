namespace SeasonPal.Domain.Entities.Recipes;

/// <summary>
/// A cooking recipe authored by a user, including its lifecycle state and audience.
/// </summary>
public class Recipe
{
    /// <summary>The recipe's unique identifier, generated as a sortable UUID v7.</summary>
    public Guid Id { get; } = Guid.CreateVersion7();

    /// <summary>The identifier of the user who created the recipe.</summary>
    public Guid CreatorUserId { get; private set; }

    /// <summary>The recipe's display title.</summary>
    public string Title { get; private set; } = string.Empty;

    /// <summary>A free-form description of the recipe.</summary>
    public string Description { get; private set; } = string.Empty;

    /// <summary>Time needed to prepare the ingredients, in minutes.</summary>
    public int PreparationTimeInMinutes { get; private set; }

    /// <summary>Time needed to cook the recipe, in minutes.</summary>
    public int CookingTimeInMinutes { get; private set; }

    /// <summary>The number of servings the recipe yields.</summary>
    public int Servings { get; private set; }

    /// <summary>How demanding the recipe is to prepare.</summary>
    public RecipeDifficulty Difficulty { get; private set; }

    /// <summary>The recipe's current position in its lifecycle.</summary>
    public RecipeStatus Status { get; private set; }

    /// <summary>Which users are allowed to view the recipe.</summary>
    public RecipeVisibility Visibility { get; private set; }
}
