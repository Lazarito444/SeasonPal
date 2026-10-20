using SeasonPal.Domain.Common;

namespace SeasonPal.Domain.Entities;

/// <summary>
/// Center of the domain and the first aggregate root: ingredients, steps and media are children,
/// all state changes run through <see cref="Create"/> or behavior methods that return <see cref="Result{T}"/>.
/// </summary>
public class Recipe
{
    public const int MaxTitleLength = 200;

    public const int MaxDescriptionLength = 2000;

    public const int MaxCuisineLength = 100;

    public const int MaxServings = 50;

    public const int MaxMinutes = 1440;

    public const int MaxIngredients = 100;

    public const int MaxSteps = 100;

    public const int MaxMedia = 20;

    public const int MaxTags = 20;

    public const int MaxTagLength = 50;

    public const int MaxDietaryTags = 10;

    public const int MaxUrlLength = 2048;

    public const int MaxIngredientNameLength = 200;

    public const int MaxIngredientUnitLength = 50;

    public const int MaxIngredientNoteLength = 500;

    public const int MaxStepInstructionLength = 2000;

    public const int MaxStepTipLength = 500;

    public const int MaxStepTimerSeconds = 86_400;

    public const int MaxMediaAltTextLength = 200;

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

    /// <summary>Free-form labels used for discovery and personal organization.</summary>
    public List<string> Tags { get; private set; } = [];

    /// <summary>Diet compatibility labels ("Vegetarian", "Gluten-free") used by diet filters.</summary>
    public List<string> DietaryTags { get; private set; } = [];

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

    /// <summary>Prep plus cook time; null when the author supplied neither.</summary>
    public int? TotalTimeMinutes =>
        PrepTimeMinutes is null && CookTimeMinutes is null
            ? null
            : (PrepTimeMinutes ?? 0) + (CookTimeMinutes ?? 0);

    public DateTimeOffset CreatedAt { get; private set; }

    public DateTimeOffset UpdatedAt { get; private set; }

    /// <summary>
    /// Creates a private draft owned by <paramref name="authorId"/>. Publication and AI-style
    /// variants are separate transitions — nothing here marks a recipe public.
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

        var recipe = new Recipe
        {
            AuthorId = authorId,
            Visibility = RecipeVisibility.Private,
            Status = RecipeStatus.Draft,
            CreatedAt = DateTimeOffset.UtcNow,
            UpdatedAt = DateTimeOffset.UtcNow,
        };

        var details = new RecipeDetails(
            title,
            description,
            cuisine,
            CoverImageUrl: null,
            Tags: null,
            DietaryTags: null,
            mealType,
            servings,
            prepTimeMinutes,
            cookTimeMinutes,
            difficulty);

        var update = recipe.UpdateDetails(details);
        return update.IsSuccess
            ? Result<Recipe>.Ok(recipe)
            : Result<Recipe>.Fail(update.Error!);
    }

    /// <summary>
    /// Replaces every scalar field and the label lists in one validated step. The editor sends
    /// the whole form, so a failed update leaves the aggregate untouched rather than half-edited.
    /// </summary>
    public Result UpdateDetails(RecipeDetails details)
    {
        var title = details.Title?.Trim() ?? string.Empty;
        if (title.Length is < 1 or > MaxTitleLength)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "recipe.title-size-invalid",
                    "Title must be 1–200 characters.",
                    ("max", MaxTitleLength.ToString())));
        }

        var description = NormalizeOptionalText(
            details.Description,
            MaxDescriptionLength,
            "recipe.description-size-invalid",
            "Description",
            MaxDescriptionLength);

        if (!description.IsSuccess)
        {
            return Result.Fail(description.Error!);
        }

        var cuisine = NormalizeOptionalText(
            details.Cuisine,
            MaxCuisineLength,
            "recipe.cuisine-size-invalid",
            "Cuisine",
            MaxCuisineLength);

        if (!cuisine.IsSuccess)
        {
            return Result.Fail(cuisine.Error!);
        }

        var cover = NormalizeOptionalText(
            details.CoverImageUrl,
            MaxUrlLength,
            "recipe.cover-image-invalid",
            "Cover image URL",
            MaxUrlLength);

        if (!cover.IsSuccess)
        {
            return Result.Fail(cover.Error!);
        }

        var tags = NormalizeLabels(
            details.Tags,
            MaxTags,
            MaxTagLength,
            "recipe.tags-too-many",
            "recipe.tag-invalid",
            "Tag");

        if (!tags.IsSuccess)
        {
            return Result.Fail(tags.Error!);
        }

        var dietaryTags = NormalizeLabels(
            details.DietaryTags,
            MaxDietaryTags,
            MaxTagLength,
            "recipe.dietary-tags-too-many",
            "recipe.dietary-tag-invalid",
            "Dietary tag");

        if (!dietaryTags.IsSuccess)
        {
            return Result.Fail(dietaryTags.Error!);
        }

        if (!Enum.IsDefined(details.MealType))
        {
            return Result.Fail(
                ApplicationError.Of("recipe.meal-type-invalid", "Choose a valid meal type."));
        }

        if (details.Servings is < 1 or > MaxServings)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "recipe.serves-out-of-range",
                    "Servings must be between 1 and 50.",
                    ("max", MaxServings.ToString())));
        }

        if (details.PrepTimeMinutes is < 0 or > MaxMinutes
            || details.CookTimeMinutes is < 0 or > MaxMinutes)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "recipe.time-out-of-range",
                    "Minutes must be between 0 and 1440.",
                    ("max", MaxMinutes.ToString())));
        }

        if (!Enum.IsDefined(details.Difficulty))
        {
            return Result.Fail(
                ApplicationError.Of("recipe.difficulty-invalid", "Choose a valid difficulty."));
        }

        Title = title;
        Description = description.Value;
        Cuisine = cuisine.Value;
        CoverImageUrl = cover.Value;
        Tags = tags.Value;
        DietaryTags = dietaryTags.Value;
        MealType = details.MealType;
        Servings = details.Servings;
        PrepTimeMinutes = details.PrepTimeMinutes;
        CookTimeMinutes = details.CookTimeMinutes;
        Difficulty = details.Difficulty;
        Touch();
        return Result.Ok();
    }

    /// <summary>Appends an ingredient and assigns the next contiguous order ("to taste" entries carry a null quantity).</summary>
    public Result<RecipeIngredient> AddIngredient(
        double? quantity,
        string? unit,
        string name,
        string? note = null)
    {
        var built = BuildIngredient(
            new IngredientDraft(quantity, unit, name, note),
            _ingredients.Count + 1);

        if (!built.IsSuccess)
        {
            return built;
        }

        _ingredients.Add(built.Value);
        Touch();
        return built;
    }

    /// <summary>
    /// Replaces the whole ingredient list in one validated step; used by the recipe editor where
    /// rows are added, removed and reordered before saving.
    /// </summary>
    public Result ReplaceIngredients(IReadOnlyList<IngredientDraft>? ingredients)
    {
        var drafts = ingredients ?? [];
        if (drafts.Count > MaxIngredients)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "recipe.ingredients-too-many",
                    "A recipe can have at most 100 ingredients.",
                    ("max", MaxIngredients.ToString())));
        }

        var built = new List<RecipeIngredient>(drafts.Count);
        for (var index = 0; index < drafts.Count; index++)
        {
            var ingredient = BuildIngredient(drafts[index], index + 1);
            if (!ingredient.IsSuccess)
            {
                return Result.Fail(ingredient.Error!);
            }

            built.Add(ingredient.Value);
        }

        _ingredients.Clear();
        _ingredients.AddRange(built);
        Touch();
        return Result.Ok();
    }

    /// <summary>Appends a preparation step and assigns the next contiguous order.</summary>
    public Result<RecipeStep> AddStep(
        string instruction,
        string? tip = null,
        int? timerSeconds = null)
    {
        var built = BuildStep(
            new StepDraft(instruction, tip, timerSeconds),
            _steps.Count + 1);

        if (!built.IsSuccess)
        {
            return built;
        }

        _steps.Add(built.Value);
        Touch();
        return built;
    }

    /// <summary>Replaces the whole preparation list in one validated step.</summary>
    public Result ReplaceSteps(IReadOnlyList<StepDraft>? steps)
    {
        var drafts = steps ?? [];
        if (drafts.Count > MaxSteps)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "recipe.steps-too-many",
                    "A recipe can have at most 100 steps.",
                    ("max", MaxSteps.ToString())));
        }

        var built = new List<RecipeStep>(drafts.Count);
        for (var index = 0; index < drafts.Count; index++)
        {
            var step = BuildStep(drafts[index], index + 1);
            if (!step.IsSuccess)
            {
                return Result.Fail(step.Error!);
            }

            built.Add(step.Value);
        }

        _steps.Clear();
        _steps.AddRange(built);
        Touch();
        return Result.Ok();
    }

    /// <summary>Replaces the media gallery in one validated step; covers stay in their own field.</summary>
    public Result ReplaceMedia(IReadOnlyList<MediaDraft>? media)
    {
        var drafts = media ?? [];
        if (drafts.Count > MaxMedia)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "recipe.media-too-many",
                    "A recipe can have at most 20 media items.",
                    ("max", MaxMedia.ToString())));
        }

        var now = DateTimeOffset.UtcNow;
        var built = new List<RecipeMedia>(drafts.Count);
        for (var index = 0; index < drafts.Count; index++)
        {
            var draft = drafts[index];
            var url = draft.Url?.Trim() ?? string.Empty;
            if (url.Length is < 1 or > MaxUrlLength)
            {
                return Result.Fail(
                    ApplicationError.Of(
                        "recipe.media-url-invalid",
                        "Each media item needs a URL of at most 2048 characters.",
                        ("max", MaxUrlLength.ToString())));
            }

            if (!Enum.IsDefined(draft.Kind))
            {
                return Result.Fail(
                    ApplicationError.Of("recipe.media-kind-invalid", "Choose a valid media kind."));
            }

            var altText = NormalizeOptionalText(
                draft.AltText,
                MaxMediaAltTextLength,
                "recipe.media-alt-text-invalid",
                "Alt text",
                MaxMediaAltTextLength);

            if (!altText.IsSuccess)
            {
                return Result.Fail(altText.Error!);
            }

            built.Add(RecipeMedia.Assemble(Id, index + 1, url, draft.Kind, altText.Value, now));
        }

        _media.Clear();
        _media.AddRange(built);
        Touch();
        return Result.Ok();
    }

    /// <summary>
    /// Explicit publication transition. A recipe must have at least one ingredient and one step;
    /// the visibility/status pair is only ever changed together so clients cannot publish a draft.
    /// </summary>
    public Result Publish()
    {
        if (_ingredients.Count == 0 || _steps.Count == 0)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "recipe.publish-incomplete",
                    "Add at least one ingredient and one step before publishing."));
        }

        if (Visibility == RecipeVisibility.Public && Status == RecipeStatus.Published)
        {
            return Result.Ok();
        }

        Visibility = RecipeVisibility.Public;
        Status = RecipeStatus.Published;
        Touch();
        return Result.Ok();
    }

    /// <summary>Returns the recipe to a private draft while keeping its content.</summary>
    public void Unpublish()
    {
        if (Visibility == RecipeVisibility.Private && Status == RecipeStatus.Draft)
        {
            return;
        }

        Visibility = RecipeVisibility.Private;
        Status = RecipeStatus.Draft;
        Touch();
    }

    private Result<RecipeIngredient> BuildIngredient(IngredientDraft draft, int order)
    {
        var name = draft.Name?.Trim() ?? string.Empty;

        if (name.Length is < 1 or > MaxIngredientNameLength)
        {
            return Result<RecipeIngredient>.Fail(
                ApplicationError.Of(
                    "recipe.ingredient-name-invalid",
                    "Ingredient name must be 1–200 characters.",
                    ("max", MaxIngredientNameLength.ToString())));
        }

        var unit = MeasurementUnits.Normalize(draft.Unit);
        if (unit is { Length: > MaxIngredientUnitLength })
        {
            return Result<RecipeIngredient>.Fail(
                ApplicationError.Of(
                    "recipe.ingredient-unit-invalid",
                    "Unit exceeds 50 characters.",
                    ("max", MaxIngredientUnitLength.ToString())));
        }

        if (draft.Quantity is < 0)
        {
            return Result<RecipeIngredient>.Fail(
                ApplicationError.Of(
                    "recipe.ingredient-quantity-invalid", "Quantity cannot be negative."));
        }

        var note = NormalizeOptionalText(
            draft.Note,
            MaxIngredientNoteLength,
            "recipe.ingredient-note-invalid",
            "Note",
            MaxIngredientNoteLength);

        if (!note.IsSuccess)
        {
            return Result<RecipeIngredient>.Fail(note.Error!);
        }

        return RecipeIngredient.Assemble(Id, order, draft.Quantity, unit, name, note.Value);
    }

    private Result<RecipeStep> BuildStep(StepDraft draft, int order)
    {
        var instruction = draft.Instruction?.Trim() ?? string.Empty;

        if (instruction.Length is < 1 or > MaxStepInstructionLength)
        {
            return Result<RecipeStep>.Fail(
                ApplicationError.Of(
                    "recipe.step-instruction-invalid",
                    "Step instruction must be 1–2000 characters.",
                    ("max", MaxStepInstructionLength.ToString())));
        }

        var tip = NormalizeOptionalText(
            draft.Tip,
            MaxStepTipLength,
            "recipe.step-tip-invalid",
            "Tip",
            MaxStepTipLength);

        if (!tip.IsSuccess)
        {
            return Result<RecipeStep>.Fail(tip.Error!);
        }

        if (draft.TimerSeconds is < 1 or > MaxStepTimerSeconds)
        {
            return Result<RecipeStep>.Fail(
                ApplicationError.Of(
                    "recipe.step-timer-out-of-range",
                    "Timers must be between 1 and 86400 seconds.",
                    ("max", MaxStepTimerSeconds.ToString())));
        }

        return RecipeStep.Assemble(Id, order, instruction, tip.Value, draft.TimerSeconds);
    }

    private static Result<string?> NormalizeOptionalText(
        string? value,
        int maxLength,
        string code,
        string label,
        int reportedMax)
    {
        var trimmed = value?.Trim();
        if (string.IsNullOrEmpty(trimmed))
        {
            return Result<string?>.Ok(null);
        }

        if (trimmed.Length > maxLength)
        {
            return Result<string?>.Fail(
                ApplicationError.Of(
                    code,
                    $"{label} exceeds {reportedMax} characters.",
                    ("max", reportedMax.ToString())));
        }

        return Result<string?>.Ok(trimmed);
    }

    private static Result<List<string>> NormalizeLabels(
        IReadOnlyList<string>? values,
        int maxCount,
        int maxLength,
        string tooManyCode,
        string itemCode,
        string label)
    {
        var normalized = new List<string>();
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var raw in values ?? [])
        {
            var value = raw?.Trim() ?? string.Empty;
            if (value.Length == 0)
            {
                continue;
            }

            if (value.Length > maxLength)
            {
                return Result<List<string>>.Fail(
                    ApplicationError.Of(
                        itemCode,
                        $"{label} must be at most {maxLength} characters.",
                        ("max", maxLength.ToString())));
            }

            if (seen.Add(value))
            {
                normalized.Add(value);
            }
        }

        if (normalized.Count > maxCount)
        {
            return Result<List<string>>.Fail(
                ApplicationError.Of(
                    tooManyCode,
                    $"At most {maxCount} {label.ToLowerInvariant()} values are allowed.",
                    ("max", maxCount.ToString())));
        }

        return Result<List<string>>.Ok(normalized);
    }

    private void Touch() => UpdatedAt = DateTimeOffset.UtcNow;
}
