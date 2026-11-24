namespace SeasonPal.Api.Extensions;

/// <summary>
/// Registration helpers that keep <c>Program.cs</c> focused on the order of the
/// application's stages instead of the details of each registration.
/// </summary>
public static class ServiceCollectionExtensions
{
    extension(IServiceCollection services)
    {
        /// <summary>Registers the framework services and shared clock the API depends on.</summary>
        public void AddSeasonPalServices()
        {
            services.AddOpenApi();
            services.AddSingleton(TimeProvider.System);
        }
    }
}
