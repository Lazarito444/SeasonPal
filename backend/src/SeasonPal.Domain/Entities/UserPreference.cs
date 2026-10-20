namespace SeasonPal.Domain.Entities;

/// <summary>One-to-one onboarding profile; drives personalized recommendations.</summary>
public class UserPreference
{
    public Guid UserId { get; set; }

    public ApplicationUser User { get; set; } = null!;

    public List<string> FavoriteCuisines { get; set; } = [];

    /// <summary>Free-form dietary restrictions the user typed or picked ("vegetarian", "low-sodium", …).</summary>
    public List<string> DietaryRestrictions { get; set; } = [];

    public CulinarySkillLevel SkillLevel { get; set; } = CulinarySkillLevel.Beginner;

    public int? UsualCookTimeMinutes { get; set; }

    public List<string> Interests { get; set; } = [];

    /// <summary>Set once the onboarding wizard finishes; gates first-personalized experience.</summary>
    public bool OnboardingCompleted { get; set; }

    public DateTimeOffset CompletedAt { get; set; }
}
