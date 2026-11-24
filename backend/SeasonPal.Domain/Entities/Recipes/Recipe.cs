using SeasonPal.Domain.Results;

namespace SeasonPal.Domain.Entities.Recipes;

/// <summary>
/// A recipe authored by a user and the root of the recipe library. Instances are created
/// through <see cref="Create"/> and changed through the behavior methods that follow, so the
/// entity never holds invalid state; expected validation failures travel as a failed result
/// instead of an exception.
/// </summary>
public sealed class Recipe
{
    /// <summary>Maximum length of <see cref="Title"/>, in characters.</summary>
    public const int MaxTitleLength = 200;

    /// <summary>Maximum length of <see cref="Description"/>, in characters.</summary>
    public const int MaxDescriptionLength = 2000;

    /// <summary>Maximum number of servings a recipe can yield.</summary>
    public const int MaxServings = 50;

    /// <summary>Maximum preparation or cooking time, in minutes, equivalent to one day.</summary>
    public const int MaxMinutes = 1440;

    private Recipe()
    {
        // EF Core materializes entities through this constructor.
    }

    /// <summary>The recipe's unique identifier, generated as a sortable UUID v7.</summary>
    public Guid Id { get; private set; }

    /// <summary>The identifier of the user who created the recipe.</summary>
    public Guid CreatorUserId { get; private set; }

    /// <summary>The recipe's display title.</summary>
    public string Title { get; private set; } = string.Empty;

    /// <summary>A free-form description; null when the author supplied none.</summary>
    public string? Description { get; private set; }

    /// <summary>Time needed to prepare the ingredients, in minutes; null when unknown.</summary>
    public int? PreparationTimeInMinutes { get; private set; }

    /// <summary>Time needed to cook the recipe, in minutes; null when unknown.</summary>
    public int? CookingTimeInMinutes { get; private set; }

    /// <summary>The number of servings the recipe yields.</summary>
    public int Servings { get; private set; }

    /// <summary>How demanding the recipe is to prepare.</summary>
    public RecipeDifficulty Difficulty { get; private set; }

    /// <summary>The recipe's current position in its lifecycle.</summary>
    public RecipeStatus Status { get; private set; }

    /// <summary>Which users are allowed to view the recipe.</summary>
    public RecipeVisibility Visibility { get; private set; }

    /// <summary>When the recipe was created, in UTC.</summary>
    public DateTimeOffset CreatedAt { get; private set; }

    /// <summary>When the recipe was last changed, in UTC.</summary>
    public DateTimeOffset UpdatedAt { get; private set; }

    /// <summary>
    /// Preparation plus cooking time; null when the author supplied neither.
    /// </summary>
    public int? TotalTimeInMinutes =>
        PreparationTimeInMinutes is null && CookingTimeInMinutes is null
            ? null
            : (PreparationTimeInMinutes ?? 0) + (CookingTimeInMinutes ?? 0);

    /// <summary>
    /// Creates a private draft owned by <paramref name="creatorUserId"/>. Creating a recipe
    /// never publishes it, so nothing becomes visible to other users by accident.
    /// </summary>
    /// <param name="creatorUserId">The user who owns the recipe.</param>
    /// <param name="title">The display title.</param>
    /// <param name="timeProvider">The clock used to stamp the creation and update times.</param>
    /// <param name="description">A free-form description; null when none.</param>
    /// <param name="preparationTimeInMinutes">Preparation time in minutes; null when unknown.</param>
    /// <param name="cookingTimeInMinutes">Cooking time in minutes; null when unknown.</param>
    /// <param name="servings">The number of servings the recipe yields.</param>
    /// <param name="difficulty">How demanding the recipe is to prepare.</param>
    /// <returns>
    /// The created recipe, or a failure when the creator is missing or any field is invalid.
    /// </returns>
    public static Result<Recipe> Create(
        Guid creatorUserId,
        string title,
        TimeProvider timeProvider,
        string? description = null,
        int? preparationTimeInMinutes = null,
        int? cookingTimeInMinutes = null,
        int servings = 2,
        RecipeDifficulty difficulty = RecipeDifficulty.Easy)
    {
        ArgumentNullException.ThrowIfNull(timeProvider);

        if (creatorUserId == Guid.Empty)
        {
            return Result<Recipe>.Fail(
                new Error("recipe.owner_required", "A recipe must have a creator."));
        }

        DateTimeOffset now = timeProvider.GetUtcNow();
        Recipe recipe = new Recipe
        {
            Id = Guid.CreateVersion7(),
            CreatorUserId = creatorUserId,
            Status = RecipeStatus.Draft,
            Visibility = RecipeVisibility.Private,
            CreatedAt = now,
            UpdatedAt = now,
        };

        Result update = recipe.ApplyDetails(
            new RecipeDetails(
                title,
                description,
                preparationTimeInMinutes,
                cookingTimeInMinutes,
                servings,
                difficulty),
            now);

        return update.IsSuccess
            ? Result<Recipe>.Ok(recipe)
            : Result<Recipe>.Fail(update.Error!);
    }

    /// <summary>
    /// Replaces every scalar field in one validated step. Validation completes before any
    /// assignment, so a rejected update leaves the recipe exactly as it was.
    /// </summary>
    /// <param name="details">The complete set of scalar fields to apply.</param>
    /// <param name="timeProvider">The clock used to stamp the update time.</param>
    /// <returns>Success, or the first validation failure found.</returns>
    public Result UpdateDetails(RecipeDetails details, TimeProvider timeProvider)
    {
        ArgumentNullException.ThrowIfNull(timeProvider);
        return ApplyDetails(details, timeProvider.GetUtcNow());
    }

    private Result ApplyDetails(RecipeDetails details, DateTimeOffset now)
    {
        ArgumentNullException.ThrowIfNull(details);

        Result<string> title = ValidateTitle(details.Title);
        if (title.IsError)
        {
            return Result.Fail(title.Error!);
        }

        Result<string?> description = ValidateDescription(details.Description);
        if (description.IsError)
        {
            return Result.Fail(description.Error!);
        }

        if (!IsValidMinutes(details.PreparationTimeInMinutes)
            || !IsValidMinutes(details.CookingTimeInMinutes))
        {
            return Result.Fail(
                new Error(
                    "recipe.time_out_of_range",
                    $"Times must be between 0 and {MaxMinutes} minutes.",
                    MaxMinutes));
        }

        if (details.Servings is < 1 or > MaxServings)
        {
            return Result.Fail(
                new Error(
                    "recipe.serves_out_of_range",
                    $"Servings must be between 1 and {MaxServings}.",
                    MaxServings));
        }

        if (!Enum.IsDefined(details.Difficulty))
        {
            return Result.Fail(
                new Error("recipe.difficulty_invalid", "Choose a valid difficulty."));
        }

        Title = title.Value;
        Description = description.Value;
        PreparationTimeInMinutes = details.PreparationTimeInMinutes;
        CookingTimeInMinutes = details.CookingTimeInMinutes;
        Servings = details.Servings;
        Difficulty = details.Difficulty;
        UpdatedAt = now;

        return Result.Ok();
    }

    private static Result<string> ValidateTitle(string? title)
    {
        string normalized = title?.Trim() ?? string.Empty;

        if (normalized.Length is < 1 or > MaxTitleLength)
        {
            return Result<string>.Fail(
                new Error(
                    "recipe.title_invalid",
                    $"Title must be between 1 and {MaxTitleLength} characters.",
                    MaxTitleLength));
        }

        return Result<string>.Ok(normalized);
    }

    private static Result<string?> ValidateDescription(string? description)
    {
        string? normalized = description?.Trim();

        if (string.IsNullOrEmpty(normalized))
        {
            return Result<string?>.Ok(null);
        }

        if (normalized.Length > MaxDescriptionLength)
        {
            return Result<string?>.Fail(
                new Error(
                    "recipe.description_invalid",
                    $"Description must be at most {MaxDescriptionLength} characters.",
                    MaxDescriptionLength));
        }

        return Result<string?>.Ok(normalized);
    }

    private static bool IsValidMinutes(int? minutes) => minutes is null or (>= 0 and <= MaxMinutes);
}
