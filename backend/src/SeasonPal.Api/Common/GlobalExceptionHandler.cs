using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace SeasonPal.Api.Common;

/// <summary>
/// Last-resort handler: uncaught exceptions become a terse ProblemDetails (never stack traces),
/// while the full error goes to structured logs. Business failures never reach here —
/// they travel through Result<T> per AGENTS.md.
/// </summary>
internal sealed class GlobalExceptionHandler(ILogger<GlobalExceptionHandler> logger) : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext,
        Exception exception,
        CancellationToken cancellationToken)
    {
        logger.LogError(exception, "Unhandled exception on {Method} {Path}", httpContext.Request.Method, httpContext.Request.Path);

        await Results.Problem(
            statusCode: StatusCodes.Status500InternalServerError,
            title: "An unexpected error occurred.")
            .ExecuteAsync(httpContext)
            .ConfigureAwait(false);

        return true;
    }
}
