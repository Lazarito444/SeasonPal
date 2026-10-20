using System.Security.Cryptography;
using System.Text;
using System.Threading.RateLimiting;
using FluentValidation;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using Scalar.AspNetCore;
using SeasonPal.Api.Common;
using SeasonPal.Api.Endpoints;
using SeasonPal.Application.Auth;
using SeasonPal.Application.Collections;
using SeasonPal.Application.Common;
using SeasonPal.Application.Preferences;
using SeasonPal.Domain.Entities;
using SeasonPal.Infrastructure.Auth;
using SeasonPal.Infrastructure.Persistence;
using SeasonPal.Infrastructure.Persistence.Repositories;
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

// JWT configuration: a secret signing key is required outside Development. Dev falls back to
// an ephemeral key so a fresh clone boots without user-secrets; tokens then die on restart.
var jwtOptions = builder.Configuration.GetSection(JwtOptions.SectionName).Get<JwtOptions>()
    ?? new JwtOptions();

if (string.IsNullOrWhiteSpace(jwtOptions.SigningKey))
{
    if (!builder.Environment.IsDevelopment())
    {
        throw new InvalidOperationException(
            "Jwt:SigningKey is required outside Development. Set it with user-secrets or an environment variable.");
    }

    jwtOptions.SigningKey = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
    Log.Warning(
        "Jwt:SigningKey is not configured; using an ephemeral development key. Tokens will not survive an API restart.");
}
else if (Encoding.UTF8.GetByteCount(jwtOptions.SigningKey) < 32)
{
    throw new InvalidOperationException("Jwt:SigningKey must contain at least 32 bytes.");
}

builder.Services.AddSingleton(jwtOptions);
builder.Services.AddSingleton(new AuthOptions
{
    RefreshTokenLifetime = TimeSpan.FromDays(Math.Clamp(jwtOptions.RefreshTokenDays, 1, 90)),
});
builder.Services.AddSingleton(TimeProvider.System);
builder.Services.AddScoped<IAccessTokenIssuer, JwtTokenIssuer>();
builder.Services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
builder.Services.AddScoped<IUserPreferenceRepository, UserPreferenceRepository>();
builder.Services.AddScoped<ICollectionRepository, CollectionRepository>();
builder.Services.AddScoped<IUnitOfWork>(services => services.GetRequiredService<SeasonPalDbContext>());
builder.Services.AddScoped<AuthenticationService>();

builder.Services.AddValidatorsFromAssemblyContaining<RegisterRequestValidator>();
builder.Services.AddScoped(typeof(ValidationFilter<>));

builder.Services
    .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.MapInboundClaims = false;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = jwtOptions.Issuer,
            ValidateAudience = true,
            ValidAudience = jwtOptions.Audience,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtOptions.SigningKey)),
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromSeconds(30),
            NameClaimType = JwtRegisteredClaimNames.Name,
        };
        options.Events = new JwtBearerEvents
        {
            // Consistent ProblemDetails for missing/expired tokens instead of an empty 401.
            OnChallenge = async context =>
            {
                context.HandleResponse();
                await Results.Problem(
                    statusCode: StatusCodes.Status401Unauthorized,
                    title: "Authentication required.",
                    extensions: new Dictionary<string, object?>(StringComparer.Ordinal)
                    {
                        ["code"] = "auth.required",
                    }).ExecuteAsync(context.HttpContext);
            },
            OnAuthenticationFailed = context =>
            {
                // Security event: the reason, never the token itself.
                Log.Warning(context.Exception, "JWT validation failed");
                return Task.CompletedTask;
            },
        };
    });
builder.Services.AddAuthorization();
builder.Services.Configure<AuthRateLimitingOptions>(
    builder.Configuration.GetSection("RateLimiting"));

builder.Services.AddRateLimiter(options =>
{
    options.AddPolicy(AuthRateLimitPolicy, httpContext =>
    {
        var limitSettings = httpContext.RequestServices
            .GetRequiredService<Microsoft.Extensions.Options.IOptions<AuthRateLimitingOptions>>()
            .Value;
        var permitLimit = Math.Clamp(limitSettings.AuthPermitLimit, 1, 10_000);
        var clientAddress = httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";
        return RateLimitPartition.GetFixedWindowLimiter(
            clientAddress,
            _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = permitLimit,
                Window = TimeSpan.FromMinutes(1),
                QueueLimit = 0,
                AutoReplenishment = true,
            });
    });

    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;

    options.OnRejected = async (context, cancellationToken) =>
    {
        if (context.Lease.TryGetMetadata(MetadataName.RetryAfter, out var retryAfter))
        {
            context.HttpContext.Response.Headers.RetryAfter =
                ((int)retryAfter.TotalSeconds).ToString(System.Globalization.CultureInfo.InvariantCulture);
        }

        await Results.Problem(
            statusCode: StatusCodes.Status429TooManyRequests,
            title: "Too many attempts. Try again shortly.",
            extensions: new Dictionary<string, object?>(StringComparer.Ordinal)
            {
                ["code"] = "auth.rate-limited",
            }).ExecuteAsync(context.HttpContext);
    };
});

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
app.UseRateLimiter();
app.UseAuthentication();
app.UseAuthorization();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.MapHealthEndpoints();
app.MapAuthEndpoints();
app.MapOnboardingEndpoints();
app.Run();

/// <summary>Marker for MVC.Testing + EF tooling; keep public partial.</summary>
public partial class Program;
