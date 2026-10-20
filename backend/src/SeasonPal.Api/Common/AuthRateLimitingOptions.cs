namespace SeasonPal.Api.Common;

/// <summary>
/// Auth limiter settings, bound from the <c>RateLimiting</c> section. Read per request so test
/// hosts can override the limit without rebuilding the limiter policy.
/// </summary>
public sealed class AuthRateLimitingOptions
{
    public int AuthPermitLimit { get; set; } = 10;
}
