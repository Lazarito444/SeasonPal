using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SeasonPal.Infrastructure.Persistence;

/// <summary>
/// Lets `dotnet ef` build the context without booting the Api host. Production never
/// instantiates this; the runtime connection string comes from configuration.
/// </summary>
public sealed class SeasonPalDbContextFactory : IDesignTimeDbContextFactory<SeasonPalDbContext>
{
    public SeasonPalDbContext CreateDbContext(string[] args)
    {
        var connectionString =
            Environment.GetEnvironmentVariable("SEASONPAL_CONNECTION_STRING")
            ?? "Host=localhost;Port=5433;Database=seasonpal;Username=seasonpal;Password=seasonpal_dev";

        var optionsBuilder = new DbContextOptionsBuilder<SeasonPalDbContext>()
            .UseNpgsql(connectionString);

        return new SeasonPalDbContext(optionsBuilder.Options);
    }
}
