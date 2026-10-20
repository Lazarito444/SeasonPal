using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using SeasonPal.Application.Auth;
using SeasonPal.Application.Preferences;
using SeasonPal.Domain.Enums;

namespace SeasonPal.IntegrationTests;

[Collection("SeasonPalApi")]
public class AuthEndpointsTests(SeasonPalApiFactory factory)
{
    [Fact]
    public async Task Register_login_refresh_and_preferences_round_trip()
    {
        var client = factory.CreateClient();
        var email = AuthTestData.UniqueEmail();

        var registered = await AuthTestData.RegisterAsync(client, email, "Ava Cook");

        Assert.Equal(email, registered.User.Email);
        Assert.Equal("Ava Cook", registered.User.DisplayName);
        Assert.False(registered.User.OnboardingCompleted);
        Assert.True(registered.AccessToken.Length > 40);
        Assert.True(registered.AccessTokenExpiresAt > DateTimeOffset.UtcNow);
        Assert.True(registered.RefreshTokenExpiresAt > DateTimeOffset.UtcNow);

        var loggedIn = await AuthTestData.LoginAsync(client, email);
        Assert.NotEqual(registered.RefreshToken, loggedIn.RefreshToken);

        client.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", loggedIn.AccessToken);

        var beforeResponse = await client.GetAsync("/me/preferences");
        beforeResponse.EnsureSuccessStatusCode();
        var before = await beforeResponse.Content.ReadFromJsonAsync<UserPreferenceDto>();
        Assert.NotNull(before);
        Assert.Empty(before.FavoriteCuisines);
        Assert.False(before.OnboardingCompleted);

        var updateResponse = await client.PutAsJsonAsync(
            "/me/preferences",
            new UpdatePreferencesRequest(
                ["Italian", "Levantine"],
                ["Vegetarian"],
                CulinarySkillLevel.Intermediate,
                30,
                ["Weeknight cooking"],
                OnboardingCompleted: true));

        updateResponse.EnsureSuccessStatusCode();
        var updated = await updateResponse.Content.ReadFromJsonAsync<UserPreferenceDto>();
        Assert.NotNull(updated);
        Assert.True(updated.OnboardingCompleted);
        Assert.NotNull(updated.CompletedAt);
        Assert.Equal(new[] { "Italian", "Levantine" }, updated.FavoriteCuisines);
        Assert.Equal(CulinarySkillLevel.Intermediate, updated.SkillLevel);

        var refreshResponse = await client.PostAsJsonAsync(
            "/auth/refresh",
            new RefreshTokenRequest(loggedIn.RefreshToken));

        refreshResponse.EnsureSuccessStatusCode();
        var refreshed = await refreshResponse.Content.ReadFromJsonAsync<AuthSessionDto>();
        Assert.NotNull(refreshed);
        Assert.NotEqual(loggedIn.RefreshToken, refreshed.RefreshToken);
        Assert.True(refreshed.User.OnboardingCompleted);

        var afterResponse = await client.SendAsync(
            AuthTestData.AuthorizedGet("/me/preferences", refreshed.AccessToken));

        afterResponse.EnsureSuccessStatusCode();
        var after = await afterResponse.Content.ReadFromJsonAsync<UserPreferenceDto>();
        Assert.NotNull(after);
        Assert.Equal(30, after.UsualCookTimeMinutes);
        Assert.Equal(new[] { "Vegetarian" }, after.DietaryRestrictions);
    }

    [Fact]
    public async Task Invalid_login_returns_problem_details_with_a_code()
    {
        var client = factory.CreateClient();
        var email = AuthTestData.UniqueEmail();
        await AuthTestData.RegisterAsync(client, email);

        var response = await client.PostAsJsonAsync(
            "/auth/login",
            new LoginRequest(email, "WrongPassword123!"));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
        Assert.Equal("application/problem+json", response.Content.Headers.ContentType?.MediaType);

        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("auth.invalid-credentials", document.RootElement.GetProperty("code").GetString());
    }

    [Fact]
    public async Task Registration_rejects_duplicate_emails()
    {
        var client = factory.CreateClient();
        var email = AuthTestData.UniqueEmail();
        await AuthTestData.RegisterAsync(client, email);

        var response = await client.PostAsJsonAsync(
            "/auth/register",
            new RegisterRequest(email, AuthTestData.ValidPassword, "Someone Else"));

        Assert.Equal(HttpStatusCode.Conflict, response.StatusCode);

        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("auth.email-taken", document.RootElement.GetProperty("code").GetString());
    }

    [Fact]
    public async Task Registration_validates_the_request_body()
    {
        var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync(
            "/auth/register",
            new RegisterRequest("not-an-email", "short", null));

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);

        var problem = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.NotNull(problem);
        Assert.Contains("Email", problem.Errors.Keys);
        Assert.Contains("Password", problem.Errors.Keys);
    }

    [Fact]
    public async Task Preferences_require_a_bearer_token()
    {
        var client = factory.CreateClient();

        var response = await client.GetAsync("/me/preferences");

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
        Assert.Equal("application/problem+json", response.Content.Headers.ContentType?.MediaType);

        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("auth.required", document.RootElement.GetProperty("code").GetString());
    }

    [Fact]
    public async Task Rotated_refresh_token_reuse_revokes_the_session_family()
    {
        var client = factory.CreateClient();
        var session = await AuthTestData.RegisterAsync(client, AuthTestData.UniqueEmail());

        var refreshResponse = await client.PostAsJsonAsync(
            "/auth/refresh",
            new RefreshTokenRequest(session.RefreshToken));
        refreshResponse.EnsureSuccessStatusCode();
        var rotated = await refreshResponse.Content.ReadFromJsonAsync<AuthSessionDto>();
        Assert.NotNull(rotated);

        var replay = await client.PostAsJsonAsync(
            "/auth/refresh",
            new RefreshTokenRequest(session.RefreshToken));
        Assert.Equal(HttpStatusCode.Unauthorized, replay.StatusCode);

        var afterReplay = await client.PostAsJsonAsync(
            "/auth/refresh",
            new RefreshTokenRequest(rotated.RefreshToken));
        Assert.Equal(HttpStatusCode.Unauthorized, afterReplay.StatusCode);
    }

    [Fact]
    public async Task Logout_revokes_the_refresh_token()
    {
        var client = factory.CreateClient();
        var session = await AuthTestData.RegisterAsync(client, AuthTestData.UniqueEmail());

        var logout = await client.PostAsJsonAsync(
            "/auth/logout",
            new LogoutRequest(session.RefreshToken));
        Assert.Equal(HttpStatusCode.NoContent, logout.StatusCode);

        var refresh = await client.PostAsJsonAsync(
            "/auth/refresh",
            new RefreshTokenRequest(session.RefreshToken));
        Assert.Equal(HttpStatusCode.Unauthorized, refresh.StatusCode);
    }

    [Fact]
    public async Task Password_reset_stub_accepts_a_valid_address()
    {
        var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync(
            "/auth/password/forgot",
            new ForgotPasswordRequest("someone@seasonpal.test"));

        Assert.Equal(HttpStatusCode.Accepted, response.StatusCode);
    }
}
