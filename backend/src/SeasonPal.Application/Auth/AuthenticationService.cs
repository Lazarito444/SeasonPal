using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using SeasonPal.Application.Collections;
using SeasonPal.Application.Common;
using SeasonPal.Application.Preferences;
using SeasonPal.Domain.Common;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Auth;

/// <summary>
/// Registration, login, rotation and logout in one place. This is one of the flows AGENTS.md
/// allows a dedicated service for: it provisions an Identity user plus its preference profile
/// and favorites collection, then issues a token pair.
/// </summary>
public sealed class AuthenticationService(
    UserManager<ApplicationUser> users,
    IAccessTokenIssuer accessTokens,
    IRefreshTokenRepository refreshTokens,
    IUserPreferenceRepository preferences,
    ICollectionRepository collections,
    IUnitOfWork unitOfWork,
    AuthOptions options,
    TimeProvider clock,
    ILogger<AuthenticationService> logger)
{
    private const int MaxDisplayNameLength = 80;
    private const string DefaultFavoritesCollectionName = Collection.DefaultFavoritesName;

    public async Task<Result<AuthSessionDto>> RegisterAsync(
        RegisterRequest request,
        CancellationToken cancellationToken = default)
    {
        var email = request.Email?.Trim() ?? string.Empty;
        if (email.Length == 0)
        {
            return Result<AuthSessionDto>.Fail(
                ApplicationError.Of("auth.email-required", "Enter an email address."));
        }

        var user = new ApplicationUser
        {
            UserName = email,
            Email = email,
            DisplayName = BuildDisplayName(request.DisplayName, email),
        };

        var creation = await users.CreateAsync(user, request.Password ?? string.Empty);
        if (!creation.Succeeded)
        {
            var errorCodes = creation.Errors.Select(e => e.Code).ToArray();

            if (errorCodes.Contains("DuplicateEmail") || errorCodes.Contains("DuplicateUserName"))
            {
                return Result<AuthSessionDto>.Fail(
                    ApplicationError.Of("auth.email-taken", "An account with this email already exists."));
            }

            logger.LogWarning(
                "Registration failed for {EmailDomain} with codes {ErrorCodes}",
                EmailDomain(email),
                errorCodes);

            return Result<AuthSessionDto>.Fail(
                ApplicationError.Of(
                    "auth.registration-failed",
                    "The account could not be created. Check the details and try again."));
        }

        var now = clock.GetUtcNow();
        preferences.Add(UserPreference.Create(user.Id).Value);
        collections.Add(Collection.Create(user.Id, DefaultFavoritesCollectionName, isDefaultFavorites: true).Value);

        logger.LogInformation("Registered user {UserId}", user.Id);

        return Result<AuthSessionDto>.Ok(
            await IssueSessionAsync(user, onboardingCompleted: false, now, cancellationToken));
    }

    public async Task<Result<AuthSessionDto>> LoginAsync(
        LoginRequest request,
        CancellationToken cancellationToken = default)
    {
        var email = request.Email?.Trim() ?? string.Empty;
        var user = await users.FindByEmailAsync(email);

        if (user is null)
        {
            logger.LogWarning("Login failed: unknown account");
            return Result<AuthSessionDto>.Fail(InvalidCredentials());
        }

        if (!await users.CheckPasswordAsync(user, request.Password ?? string.Empty))
        {
            logger.LogWarning("Login failed for user {UserId}", user.Id);
            return Result<AuthSessionDto>.Fail(InvalidCredentials());
        }

        var preference = await preferences.FindAsync(user.Id, cancellationToken);
        if (preference is null)
        {
            // Profiles created before onboarding existed still get one on first login.
            preference = UserPreference.Create(user.Id).Value;
            preferences.Add(preference);
        }

        return Result<AuthSessionDto>.Ok(
            await IssueSessionAsync(
                user,
                preference.OnboardingCompleted,
                clock.GetUtcNow(),
                cancellationToken));
    }

    public async Task<Result<AuthSessionDto>> RefreshAsync(
        RefreshTokenRequest request,
        CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(request.RefreshToken))
        {
            return Result<AuthSessionDto>.Fail(InvalidRefreshToken());
        }

        var tokenHash = RefreshTokenMaterial.Hash(request.RefreshToken);
        var stored = await refreshTokens.FindByHashAsync(tokenHash, cancellationToken);
        var now = clock.GetUtcNow();

        if (stored is null)
        {
            return Result<AuthSessionDto>.Fail(InvalidRefreshToken());
        }

        if (!stored.IsActive(now))
        {
            // A rotated token presented again means it leaked or the client duplicated the
            // request; drop every active session rather than hand out a new pair.
            if (stored.ReplacedByTokenHash is not null)
            {
                await refreshTokens.RevokeAllActiveAsync(stored.UserId, now, cancellationToken);
                logger.LogWarning(
                    "Refresh token reuse detected for user {UserId}; active sessions revoked",
                    stored.UserId);
            }

            return Result<AuthSessionDto>.Fail(InvalidRefreshToken());
        }

        var user = await users.FindByIdAsync(stored.UserId.ToString());
        if (user is null)
        {
            return Result<AuthSessionDto>.Fail(InvalidRefreshToken());
        }

        var rawToken = RefreshTokenMaterial.Create();
        var replacementHash = RefreshTokenMaterial.Hash(rawToken);

        stored.Revoke(now, replacementHash);
        var replacement = RefreshToken
            .Issue(user.Id, replacementHash, now, options.RefreshTokenLifetime)
            .Value;
        refreshTokens.Add(replacement);

        var preference = await preferences.FindAsync(user.Id, cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        var accessToken = accessTokens.Issue(user, now);

        return Result<AuthSessionDto>.Ok(
            new AuthSessionDto(
                accessToken.Value,
                accessToken.ExpiresAt,
                rawToken,
                replacement.ExpiresAt,
                ToUserDto(user, preference?.OnboardingCompleted ?? false)));
    }

    /// <summary>Idempotent: an unknown or already-revoked token still ends the request quietly.</summary>
    public async Task<Result> LogoutAsync(
        LogoutRequest request,
        CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(request.RefreshToken))
        {
            return Result.Ok();
        }

        var stored = await refreshTokens.FindByHashAsync(
            RefreshTokenMaterial.Hash(request.RefreshToken),
            cancellationToken);

        if (stored is not null && stored.Revoke(clock.GetUtcNow()))
        {
            await unitOfWork.SaveChangesAsync(cancellationToken);
        }

        return Result.Ok();
    }

    private async Task<AuthSessionDto> IssueSessionAsync(
        ApplicationUser user,
        bool onboardingCompleted,
        DateTimeOffset now,
        CancellationToken cancellationToken)
    {
        var accessToken = accessTokens.Issue(user, now);
        var rawToken = RefreshTokenMaterial.Create();
        var stored = RefreshToken
            .Issue(
                user.Id,
                RefreshTokenMaterial.Hash(rawToken),
                now,
                options.RefreshTokenLifetime)
            .Value;

        refreshTokens.Add(stored);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return new AuthSessionDto(
            accessToken.Value,
            accessToken.ExpiresAt,
            rawToken,
            stored.ExpiresAt,
            ToUserDto(user, onboardingCompleted));
    }

    private static AuthUserDto ToUserDto(ApplicationUser user, bool onboardingCompleted) =>
        new(
            user.Id,
            user.Email ?? string.Empty,
            user.DisplayName,
            onboardingCompleted);

    private static string BuildDisplayName(string? displayName, string email)
    {
        var normalized = displayName?.Trim();
        if (!string.IsNullOrEmpty(normalized))
        {
            return normalized.Length <= MaxDisplayNameLength
                ? normalized
                : normalized[..MaxDisplayNameLength];
        }

        var prefix = email.Split('@', 2)[0];
        return prefix.Length <= MaxDisplayNameLength
            ? prefix
            : prefix[..MaxDisplayNameLength];
    }

    /// <summary>Log-safe hint (domain only); the full address is PII and never logged.</summary>
    private static string EmailDomain(string email)
    {
        var at = email.LastIndexOf('@');
        return at >= 0 ? email[(at + 1)..] : "unknown";
    }

    private static ApplicationError InvalidCredentials() =>
        ApplicationError.Of("auth.invalid-credentials", "Email or password is incorrect.");

    private static ApplicationError InvalidRefreshToken() =>
        ApplicationError.Of("auth.refresh-token-invalid", "Your session has expired. Sign in again.");
}
