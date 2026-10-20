using System.Net;
using System.Net.Http.Json;
using SeasonPal.Application.Auth;

namespace SeasonPal.IntegrationTests;

/// <summary>Shared data for auth flow tests: unique accounts and a known-good password.</summary>
internal static class AuthTestData
{
    public const string ValidPassword = "Saffron123!";

    public static string UniqueEmail() => $"cook-{Guid.NewGuid():N}@seasonpal.test";

    public static async Task<AuthSessionDto> RegisterAsync(
        HttpClient client,
        string email,
        string displayName = "Test Cook")
    {
        var response = await client.PostAsJsonAsync(
            "/auth/register",
            new RegisterRequest(email, ValidPassword, displayName));

        if (response.StatusCode != HttpStatusCode.Created)
        {
            var body = await response.Content.ReadAsStringAsync();
            throw new InvalidOperationException(
                $"Registration failed with {(int)response.StatusCode}: {body}");
        }

        return (await response.Content.ReadFromJsonAsync<AuthSessionDto>())!;
    }

    public static async Task<AuthSessionDto> LoginAsync(
        HttpClient client,
        string email,
        string password = ValidPassword)
    {
        var response = await client.PostAsJsonAsync("/auth/login", new LoginRequest(email, password));
        response.EnsureSuccessStatusCode();
        return (await response.Content.ReadFromJsonAsync<AuthSessionDto>())!;
    }

    public static HttpRequestMessage AuthorizedGet(string url, string accessToken) =>
        new(HttpMethod.Get, url)
        {
            Headers = { Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken) },
        };
}
