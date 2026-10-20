using Microsoft.EntityFrameworkCore;
using SeasonPal.Application.Auth;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence.Repositories;

public sealed class RefreshTokenRepository(SeasonPalDbContext context) : IRefreshTokenRepository
{
    public void Add(RefreshToken token) => context.RefreshTokens.Add(token);

    public Task<RefreshToken?> FindByHashAsync(
        string tokenHash,
        CancellationToken cancellationToken = default) =>
        context.RefreshTokens.SingleOrDefaultAsync(t => t.TokenHash == tokenHash, cancellationToken);

    public Task RevokeAllActiveAsync(
        Guid userId,
        DateTimeOffset now,
        CancellationToken cancellationToken = default) =>
        context.RefreshTokens
            .Where(t => t.UserId == userId && t.RevokedAt == null && t.ExpiresAt > now)
            .ExecuteUpdateAsync(setter => setter.SetProperty(t => t.RevokedAt, now), cancellationToken);
}
