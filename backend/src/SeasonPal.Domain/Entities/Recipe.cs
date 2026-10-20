namespace SeasonPal.Domain.Entities;

/// <summary>
/// Center of the domain. Carries provenance fields that must never be dropped:
/// <see cref="Visibility"/> separates private library from community content,
/// <see cref="IsAiGenerated"/> marks AI output, <see cref="SourceRecipeId"/> credits adaptations.
/// </summary>
public class Recipe
{
    public Guid Id { get; set; }

    /// <summary>Owner of the recipe; the author on published (public) recipes.</summary>
    public Guid AuthorId { get; set; }

    public ApplicationUser Author { get; set; } = null!;

    public string Title { get; set; } = string.Empty;

    public string? Description { get; set; }

    /// <summary>Primary cuisine label, free-form ("Italian", "Levantine").</summary>
    public string? Cuisine { get; set; }

    public string? CoverImageUrl { get; set; }

    public List<string> Tags { get; set; } = [];

    public MealType MealType { get; set; } = MealType.Unspecified;

    public int Servings { get; set; } = 2;

    public int? PrepTimeMinutes { get; set; }

    public int? CookTimeMinutes { get; set; }

    public RecipeDifficulty Difficulty { get; set; } = RecipeDifficulty.Easy;

    /// <summary>Private by default; publication is an explicit act.</summary>
    public RecipeVisibility Visibility { get; set; } = RecipeVisibility.Private;

    public RecipeStatus Status { get; set; } = RecipeStatus.Draft;

    /// <summary>True when the recipe prose was produced by the AI companion.</summary>
    public bool IsAiGenerated { get; set; }

    /// <summary>Original recipe this was adapted from; null for originals.</summary>
    public Guid? SourceRecipeId { get; set; }

    public Recipe? SourceRecipe { get; set; }

    public List<RecipeIngredient> Ingredients { get; set; } = [];

    public List<RecipeStep> Steps { get; set; } = [];

    /// <summary>Additional photos/videos beyond the cover image, ordered.</summary>
    public List<RecipeMedia> Media { get; set; } = [];

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;
}
