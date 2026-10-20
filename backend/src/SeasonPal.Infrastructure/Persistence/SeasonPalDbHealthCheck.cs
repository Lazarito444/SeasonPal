using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace SeasonPal.Infrastructure.Persistence;

/// <summary>Readiness probe body: runs a trivial round-trip query so a downed Postgres fails /health/ready.</summary>
public sealed class SeasonPalDbHealthCheck(SeasonPalDbContext context) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext registrationContext,
        CancellationToken cancellationToken = default)
    {
        try
        {
            await context.Database.ExecuteSqlAsync($"SELECT 1 AS ping", cancellationToken).ConfigureAwait(false);
            return HealthCheckResult.Healthy();
        }
        catch (Exception exception)
        {
            return HealthCheckResult.Unhealthy(
                "Database unreachable: " + exception.GetType().Name + " — " + exception.Message,
                exception);
        }
    }
}
