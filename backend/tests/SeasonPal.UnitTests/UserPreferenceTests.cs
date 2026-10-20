using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.UnitTests;

public class UserPreferenceTests
{
    [Fact]
    public void Create_returns_an_empty_profile_for_the_user()
    {
        var userId = Guid.NewGuid();

        var result = UserPreference.Create(userId);

        Assert.True(result.IsSuccess);
        Assert.Equal(userId, result.Value.UserId);
        Assert.Empty(result.Value.FavoriteCuisines);
        Assert.Empty(result.Value.DietaryRestrictions);
        Assert.Empty(result.Value.Interests);
        Assert.Equal(CulinarySkillLevel.Beginner, result.Value.SkillLevel);
        Assert.False(result.Value.OnboardingCompleted);
    }

    [Fact]
    public void Create_rejects_a_missing_user()
    {
        var result = UserPreference.Create(Guid.Empty);

        Assert.False(result.IsSuccess);
        Assert.Equal("preferences.user-required", result.Error!.Code);
    }

    [Fact]
    public void Update_normalizes_trims_and_deduplicates_answers()
    {
        var preference = UserPreference.Create(Guid.NewGuid()).Value;

        var result = preference.Update(
            [" Italian ", "italian", "", "Levantine"],
            [" Vegetarian "],
            CulinarySkillLevel.Intermediate,
            30,
            [" Weeknight dinners ", "weeknight dinners"]);

        Assert.True(result.IsSuccess);
        Assert.Equal(["Italian", "Levantine"], preference.FavoriteCuisines);
        Assert.Equal(["Vegetarian"], preference.DietaryRestrictions);
        Assert.Equal(CulinarySkillLevel.Intermediate, preference.SkillLevel);
        Assert.Equal(30, preference.UsualCookTimeMinutes);
        Assert.Equal(["Weeknight dinners"], preference.Interests);
    }

    [Fact]
    public void Update_rejects_more_than_twenty_items()
    {
        var preference = UserPreference.Create(Guid.NewGuid()).Value;
        var cuisines = Enumerable.Range(1, 21).Select(i => $"Cuisine {i}").ToArray();

        var result = preference.Update(cuisines, [], CulinarySkillLevel.Beginner, null, []);

        Assert.False(result.IsSuccess);
        Assert.Equal("preferences.cuisines-invalid", result.Error!.Code);
        Assert.Equal("20", result.Error.Args["max"]);
        Assert.Empty(preference.FavoriteCuisines);
    }

    [Fact]
    public void Update_rejects_overlong_entries()
    {
        var preference = UserPreference.Create(Guid.NewGuid()).Value;

        var result = preference.Update(
            [new string('x', UserPreference.MaxItemLength + 1)],
            [],
            CulinarySkillLevel.Beginner,
            null,
            []);

        Assert.False(result.IsSuccess);
        Assert.Equal("preferences.cuisines-invalid", result.Error!.Code);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(601)]
    public void Update_rejects_cook_times_outside_the_supported_range(int minutes)
    {
        var preference = UserPreference.Create(Guid.NewGuid()).Value;

        var result = preference.Update([], [], CulinarySkillLevel.Beginner, minutes, []);

        Assert.False(result.IsSuccess);
        Assert.Equal("preferences.cook-time-invalid", result.Error!.Code);
    }

    [Fact]
    public void Update_rejects_an_undefined_skill_level()
    {
        var preference = UserPreference.Create(Guid.NewGuid()).Value;

        var result = preference.Update([], [], (CulinarySkillLevel)99, null, []);

        Assert.False(result.IsSuccess);
        Assert.Equal("preferences.skill-invalid", result.Error!.Code);
    }

    [Fact]
    public void CompleteOnboarding_stamps_the_time_once()
    {
        var preference = UserPreference.Create(Guid.NewGuid()).Value;
        var first = DateTimeOffset.UtcNow.AddMinutes(-5);

        preference.CompleteOnboarding(first);
        preference.CompleteOnboarding(DateTimeOffset.UtcNow);

        Assert.True(preference.OnboardingCompleted);
        Assert.Equal(first, preference.CompletedAt);
    }
}
