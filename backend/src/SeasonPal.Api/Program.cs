using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Console;
using Scalar.AspNetCore;
using SeasonPal.Api.Common;
using SeasonPal.Api.Endpoints;
using SeasonPal.Domain.Entities;
using SeasonPal.Infrastructure.Persistence;
using static SeasonPal.Api.SeasonPalApiConstants;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.AddJsonConsole(o =>
{
    o.TimestampFormat = "yyyy-MM-dd'T'HH:mm:ss.fffK";
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
