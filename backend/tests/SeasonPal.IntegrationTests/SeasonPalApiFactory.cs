using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using SeasonPal.Infrastructure.Persistence;
using Testcontainers.PostgreSql;

namespace SeasonPal.IntegrationTests;

/// <summary>
/// Host under test backed by a throwaway Postgres container with migrations applied.
/// One container per test collection (see <see cref="SeasonPalApiCollection"/>).
/// </summary>
public class SeasonPalApiFactory : WebApplicationFactory<Program>, IAsyncLifetime
{
    private readonly IReadOnlyDictionary<string, string?> _settings;
    private readonly PostgreSqlContainer _dbContainer = new PostgreSqlBuilder("postgres:16-alpine")
        .WithDatabase("seasonpal_test")
        .WithUsername("seasonpal")
        .WithPassword("seasonpal_test")
        .Build();

    public SeasonPalApiFactory() : this(null)
    {
    }

    protected SeasonPalApiFactory(IReadOnlyDictionary<string, string?>? settings) =>
        _settings = settings ?? new Dictionary<string, string?>();

    /// <summary>Connection string for tests that touch the database outside the HTTP host.</summary>
    public string DbConnectionString => _dbContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _dbContainer.StartAsync();

        var options = new DbContextOptionsBuilder<SeasonPalDbContext>()
            .UseNpgsql(DbConnectionString)
            .Options;

        await using var context = new SeasonPalDbContext(options);
        await context.Database.MigrateAsync();
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureAppConfiguration((_, configuration) =>
        {
            // Shared suite: tests should not trip the auth limiter except where they target it.
            var settings = new Dictionary<string, string?>(StringComparer.OrdinalIgnoreCase)
            {
                ["RateLimiting:AuthPermitLimit"] = "1000",
            };

            foreach (var (key, value) in _settings)
            {
                settings[key] = value;
            }

            configuration.AddInMemoryCollection(settings);
        });

        builder.ConfigureTestServices(services =>
        {
            services.RemoveAll<DbContextOptions<SeasonPalDbContext>>();
            services.RemoveAll<SeasonPalDbContext>();
            services.AddDbContext<SeasonPalDbContext>(options => options.UseNpgsql(DbConnectionString));
        });
    }

    public new async Task DisposeAsync()
    {
        await base.DisposeAsync();
        await _dbContainer.DisposeAsync();
    }
}
