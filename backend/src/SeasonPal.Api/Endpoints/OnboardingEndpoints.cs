using Microsoft.AspNetCore.Http;
using SeasonPal.Api.Common;
using SeasonPal.Application.Common;
using SeasonPal.Application.Preferences;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Api.Endpoints;

/// <summary>Authenticated profile endpoints; onboarding answers drive recommendations later.</summary>
public static class OnboardingEndpoints
{
    extension(IEndpointRouteBuilder app)
    {
        public void MapOnboardingEndpoints()
        {
            var group = app
                .MapGroup("/me")
                .WithTags("Preferences")
                .RequireAuthorization();

            group.MapGet("/preferences", GetPreferencesAsync)
                .WithSummary("Return the signed-in user's preferences, creating an empty profile if needed.")
                .Produces<UserPreferenceDto>()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapPut("/preferences", UpdatePreferencesAsync)
                .AddEndpointFilter<ValidationFilter<UpdatePreferencesRequest>>()
                .WithSummary("Replace preferences; set onboardingCompleted once the wizard finishes.")
                .Produces<UserPreferenceDto>()
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized);
        }
    }

    private static async Task<IResult> GetPreferencesAsync(
        HttpContext httpContext,
        IUserPreferenceRepository preferences,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var preference = await preferences.FindAsync(userId.Value, cancellationToken);
        if (preference is null)
        {
            preference = UserPreference.Create(userId.Value).Value;
            preferences.Add(preference);
            await unitOfWork.SaveChangesAsync(cancellationToken);
        }

        return Results.Ok(UserPreferenceDto.From(preference));
    }

    private static async Task<IResult> UpdatePreferencesAsync(
        UpdatePreferencesRequest request,
        HttpContext httpContext,
        IUserPreferenceRepository preferences,
        IUnitOfWork unitOfWork,
        TimeProvider clock,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var preference = await preferences.FindAsync(userId.Value, cancellationToken);
        if (preference is null)
        {
            preference = UserPreference.Create(userId.Value).Value;
            preferences.Add(preference);
        }

        var update = preference.Update(
            request.FavoriteCuisines,
            request.DietaryRestrictions,
            request.SkillLevel,
            request.UsualCookTimeMinutes,
            request.Interests);

        if (!update.IsSuccess)
        {
            return update.Error!.ToProblem();
        }

        if (request.OnboardingCompleted)
        {
            preference.CompleteOnboarding(clock.GetUtcNow());
        }

        await unitOfWork.SaveChangesAsync(cancellationToken);

        return Results.Ok(UserPreferenceDto.From(preference));
    }
}
