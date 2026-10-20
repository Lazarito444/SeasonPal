using FluentValidation;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Preferences;

public sealed class UpdatePreferencesRequestValidator : AbstractValidator<UpdatePreferencesRequest>
{
    public UpdatePreferencesRequestValidator()
    {
        RuleFor(x => x.SkillLevel).IsInEnum();

        RuleFor(x => x.UsualCookTimeMinutes)
            .InclusiveBetween(1, UserPreference.MaxCookTimeMinutes)
            .When(x => x.UsualCookTimeMinutes.HasValue);

        RuleFor(x => x.FavoriteCuisines)
            .Must(items => items is null || items.Count <= UserPreference.MaxListItems)
            .WithMessage($"Choose at most {UserPreference.MaxListItems} cuisines.");

        RuleFor(x => x.DietaryRestrictions)
            .Must(items => items is null || items.Count <= UserPreference.MaxListItems)
            .WithMessage($"Choose at most {UserPreference.MaxListItems} dietary restrictions.");

        RuleFor(x => x.Interests)
            .Must(items => items is null || items.Count <= UserPreference.MaxListItems)
            .WithMessage($"Choose at most {UserPreference.MaxListItems} interests.");

        RuleForEach(x => x.FavoriteCuisines).NotEmpty().MaximumLength(UserPreference.MaxItemLength);
        RuleForEach(x => x.DietaryRestrictions).NotEmpty().MaximumLength(UserPreference.MaxItemLength);
        RuleForEach(x => x.Interests).NotEmpty().MaximumLength(UserPreference.MaxItemLength);
    }
}
