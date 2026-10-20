namespace SeasonPal.Infrastructure.Auth;

/// <summary>
/// JWT settings from the <c>Jwt</c> configuration section. <see cref="SigningKey"/> is a secret:
/// development uses an ephemeral key when it is absent; every other environment must supply one.
/// </summary>
public sealed class JwtOptions
{
    public const string SectionName = "Jwt";

    public string Issuer { get; set; } = "SeasonPal.Api";

    public string Audience { get; set; } = "SeasonPal.Clients";

    public string SigningKey { get; set; } = string.Empty;

    public int AccessTokenMinutes { get; set; } = 15;

    public int RefreshTokenDays { get; set; } = 30;
}
