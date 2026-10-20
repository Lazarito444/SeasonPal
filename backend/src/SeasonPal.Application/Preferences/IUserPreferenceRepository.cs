using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Preferences;

public interface IUserPreferenceRepository
{
    Task<UserPreference?> FindAsync(Guid userId, CancellationToken cancellationToken = default);

    void Add(UserPreference preference);
}
