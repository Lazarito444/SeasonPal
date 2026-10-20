using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.Routing;

namespace SeasonPal.Api.Endpoints;

/// <summary>
/// Liveness/readiness probes. No auth, no business logic; /health/ready fails
/// fast when Postgres is unreachable (AGENTS.md contract).
/// </summary>
public static class HealthEndpoints
{
    public static void MapHealthEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapHealthChecks("/health/live", new HealthCheckOptions { Predicate = _ => false })
            .WithTags("Health");

        app.MapHealthChecks("/health/ready", new HealthCheckOptions { Predicate = _ => true })
            .WithTags("Health");
    }
}
