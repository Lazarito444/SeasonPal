using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using SeasonPal.Application.Auth;

namespace SeasonPal.IntegrationTests;

/// <summary>
/// Uses a dedicated host with a low auth limit so the limiter can be exhausted without
/// interfering with the rest of the suite. Own Postgres container, own limiter partition.
/// </summary>
public sealed class AuthRateLimitTests : IAsyncLifetime
{
    private readonly RateLimitedApiFactory _factory = new();

    public Task InitializeAsync() => _factory.InitializeAsync();

    public async Task DisposeAsync() => await _factory.DisposeAsync();

    [Fact]
    public async Task Repeated_invalid_logins_return_a_rate_limit_problem()
    {
        var client = _factory.CreateClient();
        HttpResponseMessage? response = null;

        for (var attempt = 0; attempt < 4; attempt++)
        {
            response = await client.PostAsJsonAsync(
                "/auth/login",
                new LoginRequest($"nobody-{attempt}@seasonpal.test", "WrongPassword123!"));
        }

        Assert.NotNull(response);
        Assert.Equal(HttpStatusCode.TooManyRequests, response.StatusCode);
        Assert.Equal("application/problem+json", response.Content.Headers.ContentType?.MediaType);

        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        Assert.Equal("auth.rate-limited", document.RootElement.GetProperty("code").GetString());
    }
}

internal sealed class RateLimitedApiFactory() : SeasonPalApiFactory(
    new Dictionary<string, string?>
    {
        ["RateLimiting:AuthPermitLimit"] = "3",
    });
