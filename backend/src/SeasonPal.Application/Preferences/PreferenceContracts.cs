namespace SeasonPal.Application.Preferences;

using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

public sealed record UpdatePreferencesRequest(
    IReadOnlyList<string>? FavoriteCuisines,
    IReadOnlyList<string>? DietaryRestrictions,
    CulinarySkillLevel SkillLevel,
    int? UsualCookTimeMinutes,
    IReadOnlyList<string>? Interests,
    bool OnboardingCompleted);

public sealed record UserPreferenceDto(
    IReadOnlyList<string> FavoriteCuisines,
    IReadOnlyList<string> DietaryRestrictions,
    CulinarySkillLevel SkillLevel,
    int? UsualCookTimeMinutes,
    IReadOnlyList<string> Interests,
    bool OnboardingCompleted,
    DateTimeOffset? CompletedAt)
{
    public static UserPreferenceDto From(UserPreference preference) => new(
        preference.FavoriteCuisines,
        preference.DietaryRestrictions,
        preference.SkillLevel,
        preference.UsualCookTimeMinutes,
        preference.Interests,
        preference.OnboardingCompleted,
        preference.OnboardingCompleted ? preference.CompletedAt : null);
}
