using Microsoft.AspNetCore.Http;
using SeasonPal.Api.Common;
using SeasonPal.Application.Auth;
using static SeasonPal.Api.SeasonPalApiConstants;

namespace SeasonPal.Api.Endpoints;

/// <summary>
/// Account entry points. Tokens travel in the response body (mobile client flow); refresh
/// tokens rotate on every use and are rate limited per client address.
/// </summary>
public static class AuthEndpoints
{
    extension(IEndpointRouteBuilder app)
    {
        public void MapAuthEndpoints()
        {
            var group = app
                .MapGroup("/auth")
                .WithTags("Auth")
                .RequireRateLimiting(AuthRateLimitPolicy);

            group.MapPost("/register", RegisterAsync)
                .AddEndpointFilter<ValidationFilter<RegisterRequest>>()
                .WithSummary("Create an account and return a token pair.")
                .Produces<AuthSessionDto>(StatusCodes.Status201Created)
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status409Conflict);

            group.MapPost("/login", LoginAsync)
                .AddEndpointFilter<ValidationFilter<LoginRequest>>()
                .WithSummary("Exchange email and password for a token pair.")
                .Produces<AuthSessionDto>()
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapPost("/refresh", RefreshAsync)
                .AddEndpointFilter<ValidationFilter<RefreshTokenRequest>>()
                .WithSummary("Rotate a refresh token and return a fresh token pair.")
                .Produces<AuthSessionDto>()
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapPost("/logout", LogoutAsync)
                .AddEndpointFilter<ValidationFilter<LogoutRequest>>()
                .WithSummary("Revoke the supplied refresh token. Idempotent.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesValidationProblem();

            group.MapPost("/password/forgot", ForgotPassword)
                .AddEndpointFilter<ValidationFilter<ForgotPasswordRequest>>()
                .WithSummary("Request a password reset. Always answers 202 once email delivery exists.")
                .Produces(StatusCodes.Status202Accepted)
                .ProducesValidationProblem();
        }
    }

    private static async Task<IResult> RegisterAsync(
        RegisterRequest request,
        AuthenticationService auth,
        CancellationToken cancellationToken)
    {
        var result = await auth.RegisterAsync(request, cancellationToken);
        return result.ToHttpResult(session =>
            Results.Created("/me/preferences", session));
    }

    private static async Task<IResult> LoginAsync(
        LoginRequest request,
        AuthenticationService auth,
        CancellationToken cancellationToken)
    {
        var result = await auth.LoginAsync(request, cancellationToken);
        return result.ToHttpResult();
    }

    private static async Task<IResult> RefreshAsync(
        RefreshTokenRequest request,
        AuthenticationService auth,
        CancellationToken cancellationToken)
    {
        var result = await auth.RefreshAsync(request, cancellationToken);
        return result.ToHttpResult();
    }

    private static async Task<IResult> LogoutAsync(
        LogoutRequest request,
        AuthenticationService auth,
        CancellationToken cancellationToken)
    {
        var result = await auth.LogoutAsync(request, cancellationToken);
        return result.IsSuccess
            ? Results.NoContent()
            : result.Error!.ToProblem();
    }

    /// <summary>
    /// Stub until SMTP exists (see docs/ROADMAP.md, Assumption 5). The answer is deliberately
    /// identical for known and unknown addresses so the endpoint cannot be used to enumerate accounts.
    /// </summary>
    private static IResult ForgotPassword(ForgotPasswordRequest request) =>
        Results.Accepted(value: new { message = "If an account uses that email, a reset link will be sent." });
}
