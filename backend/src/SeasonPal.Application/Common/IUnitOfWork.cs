namespace SeasonPal.Application.Common;

/// <summary>
/// Unit-of-work boundary exposed to handlers and flows. Infrastructure binds it to the
/// EF Core context so Application code never references EF.
/// </summary>
public interface IUnitOfWork
{
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
