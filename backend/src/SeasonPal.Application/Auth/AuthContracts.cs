namespace SeasonPal.Application.Auth;

public sealed record RegisterRequest(string? Email, string? Password, string? DisplayName);

public sealed record LoginRequest(string? Email, string? Password);

public sealed record RefreshTokenRequest(string? RefreshToken);

public sealed record LogoutRequest(string? RefreshToken);

public sealed record ForgotPasswordRequest(string? Email);

public sealed record AuthUserDto(
    Guid Id,
    string Email,
    string DisplayName,
    bool OnboardingCompleted);

/// <summary>
/// Token pair returned in the body (mobile flow): access token for API calls, rotating
/// refresh token persisted by the client. No cookies are involved.
/// </summary>
public sealed record AuthSessionDto(
    string AccessToken,
    DateTimeOffset AccessTokenExpiresAt,
    string RefreshToken,
    DateTimeOffset RefreshTokenExpiresAt,
    AuthUserDto User);
