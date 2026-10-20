using Microsoft.AspNetCore.Http;
using SeasonPal.Domain.Common;

namespace SeasonPal.Api.Common;

internal static class ResultHttpExtensions
{
    extension(ApplicationError error)
    {
        /// <summary>
        /// Maps a typed business error to ProblemDetails. The HTTP status is decided by the error
        /// code family; <c>code</c> and <c>args</c> travel in extensions so clients localize without
        /// parsing English text.
        /// </summary>
        public IResult ToProblem()
        {
            var statusCode = error.Code switch
            {
                "auth.invalid-credentials" or "auth.refresh-token-invalid" =>
                    StatusCodes.Status401Unauthorized,
                "auth.email-taken" or "collection.name-taken" or "collection.favorites-protected" =>
                    StatusCodes.Status409Conflict,
                _ when error.Code.EndsWith(".not-found", StringComparison.Ordinal) =>
                    StatusCodes.Status404NotFound,
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
    }

    extension<T>(Result<T> result)
    {
        public IResult ToHttpResult(Func<T, IResult>? onSuccess = null) =>
            result.Match(onSuccess ?? (value => Results.Ok(value)), error => error.ToProblem());
    }

    extension(Result result)
    {
        /// <summary>Maps a payload-less result to 204 by default, or to a ProblemDetails on failure.</summary>
        public IResult ToHttpResult(Func<IResult>? onSuccess = null) =>
            result.Match(onSuccess ?? Results.NoContent, error => error.ToProblem());
    }
}
