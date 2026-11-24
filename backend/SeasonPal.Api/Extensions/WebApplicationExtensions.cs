using Scalar.AspNetCore;

namespace SeasonPal.Api.Extensions;

/// <summary>
/// Pipeline helpers that keep <c>Program.cs</c> readable as the sequence of stages the
/// request passes through.
/// </summary>
public static class WebApplicationExtensions
{
    extension(WebApplication app)
    {
        /// <summary>
        /// Maps the OpenAPI document and the Scalar UI, in development only so the API
        /// surface is never exposed by an accidental production deployment.
        /// </summary>
        public void MapSeasonPalDocumentation()
        {
            if (!app.Environment.IsDevelopment())
            {
                return;
            }

            app.MapOpenApi();
            app.MapScalarApiReference();
        }
    }
}
