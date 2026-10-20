using SeasonPal.Domain.Common;

namespace SeasonPal.Domain.Entities;

/// <summary>
/// Rotating refresh-token record. Only the SHA-256 hash of the token is stored, so a leaked
/// database row cannot be replayed; rotation marks the old token revoked and links the
/// replacement, which lets the auth flow detect reuse and drop every active session.
/// </summary>
public class RefreshToken
{
    private const int MaxHashLength = 128;

    /// <summary>EF materializer.</summary>
    private RefreshToken() { }

    public Guid Id { get; private set; }

    public Guid UserId { get; private set; }

    public ApplicationUser User { get; private set; } = null!;

    /// <summary>Hex SHA-256 of the raw token; the raw value never touches the database.</summary>
    public string TokenHash { get; private set; } = null!;

    public DateTimeOffset CreatedAt { get; private set; }

    public DateTimeOffset ExpiresAt { get; private set; }

    public DateTimeOffset? RevokedAt { get; private set; }

    /// <summary>Hash of the token issued when this one was rotated; null for logout.</summary>
    public string? ReplacedByTokenHash { get; private set; }

    public bool IsActive(DateTimeOffset now) => RevokedAt is null && now < ExpiresAt;

    public static Result<RefreshToken> Issue(
        Guid userId,
        string tokenHash,
        DateTimeOffset now,
        TimeSpan lifetime)
    {
        if (userId == Guid.Empty)
        {
            return Result<RefreshToken>.Fail(
                ApplicationError.Of("auth.token-user-required", "A refresh token must belong to a user."));
        }

        var normalizedHash = tokenHash?.Trim() ?? string.Empty;
        if (normalizedHash.Length is < 32 or > MaxHashLength)
        {
            return Result<RefreshToken>.Fail(
                ApplicationError.Of("auth.token-hash-invalid", "Refresh token hash has an invalid length."));
        }

        if (lifetime <= TimeSpan.Zero)
        {
            return Result<RefreshToken>.Fail(
                ApplicationError.Of("auth.token-lifetime-invalid", "Refresh token lifetime must be positive."));
        }

        return new RefreshToken
        {
            UserId = userId,
            TokenHash = normalizedHash,
            CreatedAt = now,
            ExpiresAt = now.Add(lifetime),
        };
    }

    /// <summary>Returns false when the token was already revoked (logout stays idempotent).</summary>
    public bool Revoke(DateTimeOffset now, string? replacedByTokenHash = null)
    {
        if (RevokedAt is not null)
        {
            return false;
        }

        RevokedAt = now;
        ReplacedByTokenHash = replacedByTokenHash;
        return true;
    }
}
