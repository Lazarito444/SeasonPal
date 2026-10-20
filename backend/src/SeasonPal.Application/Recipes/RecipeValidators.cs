using FluentValidation;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Recipes;

/// <summary>
/// Boundary validation for the structured recipe editor. The aggregate repeats the same rules
/// because it is also called by AI and seed flows; this validator exists to return field-level
/// validation problems before the domain is touched.
/// </summary>
public sealed class RecipeWriteRequestValidator : AbstractValidator<RecipeWriteRequest>
{
    public RecipeWriteRequestValidator()
    {
        RuleFor(x => x.Title)
            .NotEmpty()
            .MaximumLength(Recipe.MaxTitleLength);

        RuleFor(x => x.Description)
            .MaximumLength(Recipe.MaxDescriptionLength);

        RuleFor(x => x.Cuisine)
            .MaximumLength(Recipe.MaxCuisineLength);

        RuleFor(x => x.CoverImageUrl)
            .MaximumLength(Recipe.MaxUrlLength)
            .Must(BeAUsableLocation)
            .WithMessage("Cover image must be an http(s) URL or a root-relative path.");

        RuleFor(x => x.MealType).IsInEnum();
        RuleFor(x => x.Difficulty).IsInEnum();

        RuleFor(x => x.Servings)
            .InclusiveBetween(1, Recipe.MaxServings);

        RuleFor(x => x.PrepTimeMinutes)
            .Must(minutes => minutes is null || (minutes >= 0 && minutes <= Recipe.MaxMinutes))
            .WithMessage($"Prep time must be between 0 and {Recipe.MaxMinutes} minutes.");

        RuleFor(x => x.CookTimeMinutes)
            .Must(minutes => minutes is null || (minutes >= 0 && minutes <= Recipe.MaxMinutes))
            .WithMessage($"Cook time must be between 0 and {Recipe.MaxMinutes} minutes.");

        RuleFor(x => x.Tags)
            .Must(tags => tags is null || tags.Count <= Recipe.MaxTags)
            .WithMessage($"Use at most {Recipe.MaxTags} tags.");

        RuleForEach(x => x.Tags)
            .NotEmpty()
            .MaximumLength(Recipe.MaxTagLength);

        RuleFor(x => x.DietaryTags)
            .Must(tags => tags is null || tags.Count <= Recipe.MaxDietaryTags)
            .WithMessage($"Use at most {Recipe.MaxDietaryTags} dietary tags.");

        RuleForEach(x => x.DietaryTags)
            .NotEmpty()
            .MaximumLength(Recipe.MaxTagLength);

        RuleFor(x => x.Ingredients)
            .Must(items => items is null || items.Count <= Recipe.MaxIngredients)
            .WithMessage($"Use at most {Recipe.MaxIngredients} ingredients.");

        RuleForEach(x => x.Ingredients).ChildRules(ingredient =>
        {
            ingredient.RuleFor(x => x.Name)
                .NotEmpty()
                .MaximumLength(Recipe.MaxIngredientNameLength);

            ingredient.RuleFor(x => x.Unit)
                .MaximumLength(Recipe.MaxIngredientUnitLength);

            ingredient.RuleFor(x => x.Note)
                .MaximumLength(Recipe.MaxIngredientNoteLength);

            ingredient.RuleFor(x => x.Quantity)
                .Must(quantity => quantity is null || quantity >= 0)
                .WithMessage("Quantity cannot be negative.");
        });

        RuleFor(x => x.Steps)
            .Must(items => items is null || items.Count <= Recipe.MaxSteps)
            .WithMessage($"Use at most {Recipe.MaxSteps} steps.");

        RuleForEach(x => x.Steps).ChildRules(step =>
        {
            step.RuleFor(x => x.Instruction)
                .NotEmpty()
                .MaximumLength(Recipe.MaxStepInstructionLength);

            step.RuleFor(x => x.Tip)
                .MaximumLength(Recipe.MaxStepTipLength);

            step.RuleFor(x => x.TimerSeconds)
                .Must(seconds => seconds is null
                    || (seconds >= 1 && seconds <= Recipe.MaxStepTimerSeconds))
                .WithMessage($"Timers must be between 1 and {Recipe.MaxStepTimerSeconds} seconds.");
        });

        RuleFor(x => x.Media)
            .Must(items => items is null || items.Count <= Recipe.MaxMedia)
            .WithMessage($"Use at most {Recipe.MaxMedia} media items.");

        RuleForEach(x => x.Media).ChildRules(media =>
        {
            media.RuleFor(x => x.Url)
                .NotEmpty()
                .MaximumLength(Recipe.MaxUrlLength)
                .Must(BeAUsableLocation)
                .WithMessage("Media must be an http(s) URL or a root-relative path.");

            media.RuleFor(x => x.Kind).IsInEnum();

            media.RuleFor(x => x.AltText)
                .MaximumLength(Recipe.MaxMediaAltTextLength);
        });
    }

    /// <summary>
    /// Media URLs may point at an external host or at the API's own storage (root-relative).
    /// Protocol-relative and scheme-less values are rejected so clients never render javascript:.
    /// </summary>
    private static bool BeAUsableLocation(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return true;
        }

        var trimmed = value.Trim();
        if (trimmed.StartsWith('/'))
        {
            return !trimmed.StartsWith("//", StringComparison.Ordinal);
        }

        return Uri.TryCreate(trimmed, UriKind.Absolute, out var uri)
            && (uri.Scheme == Uri.UriSchemeHttp || uri.Scheme == Uri.UriSchemeHttps);
    }
}
