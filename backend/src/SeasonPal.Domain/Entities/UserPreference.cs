using SeasonPal.Domain.Common;

namespace SeasonPal.Domain.Entities;

/// <summary>One-to-one onboarding profile; drives personalized recommendations.</summary>
public class UserPreference
{
    public const int MaxListItems = 20;

    public const int MaxItemLength = 60;

    public const int MaxCookTimeMinutes = 600;

    /// <summary>EF materializer.</summary>
    private UserPreference() { }

    public Guid UserId { get; private set; }

    public ApplicationUser User { get; private set; } = null!;

    public List<string> FavoriteCuisines { get; private set; } = [];

    /// <summary>Free-form dietary restrictions the user typed or picked ("vegetarian", "low-sodium", …).</summary>
    public List<string> DietaryRestrictions { get; private set; } = [];

    public CulinarySkillLevel SkillLevel { get; private set; } = CulinarySkillLevel.Beginner;

    public int? UsualCookTimeMinutes { get; private set; }

    public List<string> Interests { get; private set; } = [];

    /// <summary>Set once the onboarding wizard finishes; gates first-personalized experience.</summary>
    public bool OnboardingCompleted { get; private set; }

    public DateTimeOffset CompletedAt { get; private set; }

    /// <summary>Empty profile created at registration; onboarding fills it in later.</summary>
    public static Result<UserPreference> Create(Guid userId)
    {
        if (userId == Guid.Empty)
        {
            return Result<UserPreference>.Fail(
                ApplicationError.Of("preferences.user-required", "Preferences must belong to a user."));
        }

        return new UserPreference { UserId = userId };
    }

    /// <summary>
    /// Replaces the onboarding answers. Lists are trimmed, blank entries dropped and
    /// duplicates removed case-insensitively; onboarding completion is a separate transition.
    /// </summary>
    public Result Update(
        IReadOnlyCollection<string>? favoriteCuisines,
        IReadOnlyCollection<string>? dietaryRestrictions,
        CulinarySkillLevel skillLevel,
        int? usualCookTimeMinutes,
        IReadOnlyCollection<string>? interests)
    {
        if (!Enum.IsDefined(skillLevel))
        {
            return Result.Fail(
                ApplicationError.Of("preferences.skill-invalid", "Choose a valid cooking skill level."));
        }

        if (usualCookTimeMinutes is < 1 or > MaxCookTimeMinutes)
        {
            return Result.Fail(
                ApplicationError.Of(
                    "preferences.cook-time-invalid",
                    $"Usual cook time must be between 1 and {MaxCookTimeMinutes} minutes.",
                    ("max", MaxCookTimeMinutes.ToString())));
        }

        var cuisines = Normalize(favoriteCuisines, "preferences.cuisines-invalid", "cuisines");
        if (!cuisines.IsSuccess)
        {
            return Result.Fail(cuisines.Error!);
        }

        var restrictions = Normalize(dietaryRestrictions, "preferences.diet-invalid", "dietary restrictions");
        if (!restrictions.IsSuccess)
        {
            return Result.Fail(restrictions.Error!);
        }

        var normalizedInterests = Normalize(interests, "preferences.interests-invalid", "interests");
        if (!normalizedInterests.IsSuccess)
        {
            return Result.Fail(normalizedInterests.Error!);
        }

        FavoriteCuisines = cuisines.Value;
        DietaryRestrictions = restrictions.Value;
        SkillLevel = skillLevel;
        UsualCookTimeMinutes = usualCookTimeMinutes;
        Interests = normalizedInterests.Value;

        return Result.Ok();
    }

    /// <summary>Idempotent: the first call stamps the completion time, later calls leave it untouched.</summary>
    public void CompleteOnboarding(DateTimeOffset now)
    {
        if (OnboardingCompleted)
        {
            return;
        }

        OnboardingCompleted = true;
        CompletedAt = now;
    }

    private static Result<List<string>> Normalize(
        IReadOnlyCollection<string>? values,
        string errorCode,
        string label)
    {
        var normalized = new List<string>();

        foreach (var raw in values ?? [])
        {
            var value = raw?.Trim() ?? string.Empty;
            if (value.Length == 0)
            {
                continue;
            }

            if (value.Length > MaxItemLength)
            {
                return Result<List<string>>.Fail(
                    ApplicationError.Of(
                        errorCode,
                        $"Each of the {label} must be {MaxItemLength} characters or fewer.",
                        ("max", MaxItemLength.ToString())));
            }

            if (!normalized.Contains(value, StringComparer.OrdinalIgnoreCase))
            {
                normalized.Add(value);
            }
        }

        if (normalized.Count > MaxListItems)
        {
            return Result<List<string>>.Fail(
                ApplicationError.Of(
                    errorCode,
                    $"Choose at most {MaxListItems} {label}.",
                    ("max", MaxListItems.ToString())));
        }

        return normalized;
    }
}
