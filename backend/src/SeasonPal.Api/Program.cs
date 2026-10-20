using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Scalar.AspNetCore;
using SeasonPal.Api.Common;
using SeasonPal.Api.Endpoints;
using SeasonPal.Domain.Entities;
using SeasonPal.Infrastructure.Persistence;
using Serilog;
using Serilog.Events;
using static SeasonPal.Api.SeasonPalApiConstants;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((context, services, configuration) =>
{
    configuration.ReadFrom.Configuration(context.Configuration) // "Serilog" section in appsettings (levels/overrides)
        .ReadFrom.Services(services)
        .Enrich.FromLogContext()
        .WriteTo.Console();

    // Dev keeps console-only output; production additionally persists daily rolling files
    // under the app's base directory (retained for two weeks).
    if (context.HostingEnvironment.IsProduction())
    {
        configuration.WriteTo.File(
            Path.Combine(AppContext.BaseDirectory, "logs", "seasonpal-.log"),
            rollingInterval: RollingInterval.Day,
            retainedFileCountLimit: 14);
    }
});

builder.Services.AddDbContext<SeasonPalDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString(DefaultConnectionName)));

builder.Services.AddDataProtection();

builder.Services
    .AddIdentityCore<ApplicationUser>(options => options.User.RequireUniqueEmail = true)
    .AddEntityFrameworkStores<SeasonPalDbContext>()
    .AddDefaultTokenProviders();

builder.Services.AddCors(corsOptions => corsOptions.AddPolicy(CorsPolicyName, policy =>
{
    var origins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
    if (origins.Length > 0)
    {
        policy.WithOrigins(origins);
    }

    policy.AllowAnyHeader().AllowAnyMethod();
}));

builder.Services.AddHealthChecks().AddCheck<SeasonPalDbHealthCheck>("db", tags: ["db"]);
builder.Services.AddOpenApi();
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddProblemDetails();

var app = builder.Build();

app.UseExceptionHandler();
app.UseSerilogRequestLogging(options =>
{
    // One concise line per request; 5xx/traces as Error, health probes sink to Verbose
    // so they stay quiet at the configured minimum level.
    options.GetLevel = (httpContext, _, ex) => ex is not null
        ? LogEventLevel.Error
        : httpContext.Response.StatusCode >= StatusCodes.Status500InternalServerError
            ? LogEventLevel.Error
            : httpContext.Request.Path.StartsWithSegments("/health")
                ? LogEventLevel.Verbose
                : LogEventLevel.Information;
});
app.UseStatusCodePages();
app.UseCors(CorsPolicyName);

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.MapHealthEndpoints();
app.Run();

/// <summary>Marker for MVC.Testing + EF tooling; keep public partial.</summary>
public partial class Program;
