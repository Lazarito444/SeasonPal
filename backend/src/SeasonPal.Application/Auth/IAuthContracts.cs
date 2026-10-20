using SeasonPal.Application.Common;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Auth;

/// <summary>Access-token creation lives in Infrastructure; Application only speaks this shape.</summary>
public sealed record AccessToken(string Value, DateTimeOffset ExpiresAt);

/// <summary>Issues short-lived signed access tokens for an authenticated user.</summary>
public interface IAccessTokenIssuer
{
    AccessToken Issue(ApplicationUser user, DateTimeOffset issuedAt);
}

/// <summary>Persistence for rotating refresh tokens.</summary>
public interface IRefreshTokenRepository
{
    void Add(RefreshToken token);

    Task<RefreshToken?> FindByHashAsync(string tokenHash, CancellationToken cancellationToken = default);

    /// <summary>Drops every active session for the user; used when token reuse is detected.</summary>
    Task RevokeAllActiveAsync(Guid userId, DateTimeOffset now, CancellationToken cancellationToken = default);
}

/// <summary>Refresh-token lifetime, bound from configuration at composition time.</summary>
public sealed class AuthOptions
{
    public TimeSpan RefreshTokenLifetime { get; init; } = TimeSpan.FromDays(30);
}
