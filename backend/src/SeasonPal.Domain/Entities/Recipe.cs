using SeasonPal.Domain.Common;

namespace SeasonPal.Domain.Entities;

/// <summary>
/// Center of the domain and the first aggregate root: ingredients, steps and media are children,
/// all state changes run through <see cref="Create"/> or behavior methods that return <see cref="Result{T}"/>.
/// </summary>
public class Recipe
{
    private const int MaxTitleLength = 200;
    private const int MaxDescriptionLength = 2000;
    private const int MaxCuisineLength = 100;
    private const int MaxServings = 50;
    private const int MaxMinutes = 1440;

    private readonly List<RecipeIngredient> _ingredients = [];
    private readonly List<RecipeStep> _steps = [];
    private readonly List<RecipeMedia> _media = [];

    /// <summary>EF materializer.</summary>
    private Recipe() { }

    public Guid Id { get; private set; }

    /// <summary>Owner of the recipe; the author on published (community) recipes.</summary>
    public Guid AuthorId { get; private set; }

    public ApplicationUser Author { get; private set; } = null!;

    public string Title { get; private set; } = null!;

    public string? Description { get; private set; }

    /// <summary>Primary cuisine label, free-form ("Italian", "Levantine").</summary>
    public string? Cuisine { get; private set; }

    public string? CoverImageUrl { get; private set; }

    public List<string> Tags { get; private set; } = [];

    public MealType MealType { get; private set; }

    public int Servings { get; private set; }

    public int? PrepTimeMinutes { get; private set; }

    public int? CookTimeMinutes { get; private set; }

    public RecipeDifficulty Difficulty { get; private set; }

    /// <summary>Private by default; publication is an explicit transition, not a property write.</summary>
    public RecipeVisibility Visibility { get; private set; }

    public RecipeStatus Status { get; private set; }

    /// <summary>True when the recipe prose was produced by the AI companion.</summary>
    public bool IsAiGenerated { get; private set; }

    /// <summary>Original recipe this was adapted from; null for originals.</summary>
    public Guid? SourceRecipeId { get; private set; }

    public Recipe? SourceRecipe { get; private set; }

    public IReadOnlyList<RecipeIngredient> Ingredients => _ingredients;

    public IReadOnlyList<RecipeStep> Steps => _steps;

    public IReadOnlyList<RecipeMedia> Media => _media;

    public DateTimeOffset CreatedAt { get; private set; }

    public DateTimeOffset UpdatedAt { get; private set; }

    /// <summary>
    /// Creates a private draft owned by <paramref name="authorId"/>. Publication and AI-style
    /// variants are separate transitions (Stage 3+) — nothing here marks a recipe public.
    /// </summary>
    public static Result<Recipe> Create(
        Guid authorId,
        string title,
        string? description = null,
        string? cuisine = null,
        MealType mealType = MealType.Unspecified,
        int servings = 2,
        int? prepTimeMinutes = null,
        int? cookTimeMinutes = null,
        RecipeDifficulty difficulty = RecipeDifficulty.Easy)
    {
        if (authorId == Guid.Empty)
        {
            return Result<Recipe>.Fail(
                ApplicationError.Of("recipe.owner-required", "A recipe must have an owner."));
        }

        var normalizedTitle = title?.Trim() ?? string.Empty;
        if (normalizedTitle.Length is < 1 or > MaxTitleLength)
        {
            return Result<Recipe>.Fail(
                ApplicationError.Of(
                    "recipe.title-size-invalid",
                    "Title must be 1–200 characters.",
                    ("max", "200")));
        }

        if (!string.IsNullOrEmpty(description) && description.Length > MaxDescriptionLength)
        {
            return Result<Recipe>.Fail(
                ApplicationError.Of(
                    "recipe.description-size-invalid", "Description exceeds 2000 characters.", ("max", "2000")));
        }

        if (!string.IsNullOrEmpty(cuisine) && cuisine != null && cuisine.Length > MaxCuisineLength)
        {
            return Result<Recipe>.Fail(
                ApplicationError.Of(
                    "recipe.cuisine-size-invalid", "Cuisine exceeds 100 characters.", ("max", "100")));
        }

        if (servings is < 1 or > MaxServings)
        {
            return Result<Recipe>.Fail(
                ApplicationError.Of(
                    "recipe.serves-out-of-range", "Servings must be between 1 and 50.", ("max", "50")));
        }

        if (prepTimeMinutes is < 0 or > MaxMinutes || cookTimeMinutes is < 0 or > MaxMinutes)
        {
            return Result<Recipe>.Fail(
                ApplicationError.Of(
                    "recipe.time-out-of-range", "Minutes must be between 0 and 1440.", ("max", "1440")));
        }

        return new Recipe
        {
            AuthorId = authorId,
            Title = normalizedTitle,
            Description = description,
            Cuisine = cuisine,
            MealType = mealType,
            Servings = servings,
            PrepTimeMinutes = prepTimeMinutes,
            CookTimeMinutes = cookTimeMinutes,
            Difficulty = difficulty,
            Visibility = RecipeVisibility.Private,
            Status = RecipeStatus.Draft,
            CreatedAt = DateTimeOffset.UtcNow,
            UpdatedAt = DateTimeOffset.UtcNow,
        };
    }

    /// <summary>Appends an ingredient and assigns the next contiguous order ("to taste" entries carry a null quantity).</summary>
    public Result<RecipeIngredient> AddIngredient(
        double? quantity,
        string? unit,
        string name,
        string? note = null)
    {
        var normalized = name?.Trim() ?? string.Empty;

        if (normalized.Length is < 1 or > 200)
        {
            return Result<RecipeIngredient>.Fail(
                ApplicationError.Of(
                    "recipe.ingredient-name-invalid", "Ingredient name must be 1–200 characters.", ("max", "200")));
        }

        if (!string.IsNullOrEmpty(unit) && unit.Length > 50)
        {
            return Result<RecipeIngredient>.Fail(
                ApplicationError.Of(
                    "recipe.ingredient-unit-invalid", "Unit exceeds 50 characters.", ("max", "50")));
        }

        if (quantity is < 0)
        {
            return Result<RecipeIngredient>.Fail(
                ApplicationError.Of(
                    "recipe.ingredient-quantity-invalid", "Quantity cannot be negative."));
        }

        if (!string.IsNullOrEmpty(note) && note.Length > 500)
        {
            return Result<RecipeIngredient>.Fail(
                ApplicationError.Of(
                    "recipe.ingredient-note-invalid", "Note exceeds 500 characters.", ("max", "500")));
        }

        var ingredient = RecipeIngredient.Assemble(Id, _ingredients.Count + 1, quantity, unit, normalized, note);
        _ingredients.Add(ingredient);
        Touch();
        return ingredient;
    }

    /// <summary>Appends a preparation step and assigns the next contiguous order.</summary>
    public Result<RecipeStep> AddStep(
        string instruction,
        string? tip = null,
        int? timerSeconds = null)
    {
        var normalized = instruction?.Trim() ?? string.Empty;

        if (normalized.Length is < 1 or > 2000)
        {
            return Result<RecipeStep>.Fail(
                ApplicationError.Of(
                    "recipe.step-instruction-invalid", "Step instruction must be 1–2000 characters.", ("max", "2000")));
        }

        if (!string.IsNullOrEmpty(tip) && tip.Length > 500)
        {
            return Result<RecipeStep>.Fail(
                ApplicationError.Of(
                    "recipe.step-tip-invalid", "Tip exceeds 500 characters.", ("max", "500")));
        }

        if (timerSeconds is < 1 or > 86_400)
        {
            return Result<RecipeStep>.Fail(
                ApplicationError.Of(
                    "recipe.step-timer-out-of-range", "Timers must be between 1 and 86400 seconds.", ("max", "86400")));
        }

        var step = RecipeStep.Assemble(Id, _steps.Count + 1, normalized, tip, timerSeconds);
        _steps.Add(step);
        Touch();
        return step;
    }

    private void Touch() => UpdatedAt = DateTimeOffset.UtcNow;
}
