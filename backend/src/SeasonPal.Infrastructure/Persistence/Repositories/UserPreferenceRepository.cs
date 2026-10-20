using Microsoft.EntityFrameworkCore;
using SeasonPal.Application.Collections;
using SeasonPal.Application.Preferences;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence.Repositories;

public sealed class UserPreferenceRepository(SeasonPalDbContext context) : IUserPreferenceRepository
{
    public Task<UserPreference?> FindAsync(
        Guid userId,
        CancellationToken cancellationToken = default) =>
        context.UserPreferences.SingleOrDefaultAsync(p => p.UserId == userId, cancellationToken);

    public void Add(UserPreference preference) => context.UserPreferences.Add(preference);
}

public sealed class CollectionRepository(SeasonPalDbContext context) : ICollectionRepository
{
    public void Add(Collection collection) => context.Collections.Add(collection);
}
