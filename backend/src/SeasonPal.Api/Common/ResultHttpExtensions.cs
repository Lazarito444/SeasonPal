using Microsoft.AspNetCore.Http;
using SeasonPal.Domain.Common;

namespace SeasonPal.Api.Common;

internal static class ResultHttpExtensions
{
    /// <summary>
    /// Maps a typed business error to ProblemDetails. The HTTP status is decided by the error
    /// code family; <c>code</c> and <c>args</c> travel in extensions so clients localize without
    /// parsing English text.
    /// </summary>
    public static IResult ToProblem(this ApplicationError error)
    {
        var statusCode = error.Code switch
        {
            "auth.invalid-credentials" or "auth.refresh-token-invalid" =>
                StatusCodes.Status401Unauthorized,
            "auth.email-taken" => StatusCodes.Status409Conflict,
            _ => StatusCodes.Status400BadRequest,
        };

        return Results.Problem(
            statusCode: statusCode,
            title: error.FallbackMessage,
            extensions: new Dictionary<string, object?>(StringComparer.Ordinal)
            {
                ["code"] = error.Code,
                ["args"] = error.Args,
            });
    }

    public static IResult ToHttpResult<T>(this Result<T> result, Func<T, IResult>? onSuccess = null) =>
        result.Match(onSuccess ?? (value => Results.Ok(value)), error => error.ToProblem());
}
