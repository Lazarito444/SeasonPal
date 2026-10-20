using FluentValidation;

namespace SeasonPal.Api.Common;

/// <summary>
/// Runs the registered FluentValidation validator for the bound request body before the
/// handler, returning a standard validation ProblemDetails on failure. Keeps endpoints thin.
/// </summary>
internal sealed class ValidationFilter<T>(IValidator<T> validator) : IEndpointFilter
    where T : class
{
    public async ValueTask<object?> InvokeAsync(
        EndpointFilterInvocationContext context,
        EndpointFilterDelegate next)
    {
        var request = context.Arguments.OfType<T>().FirstOrDefault();
        if (request is null)
        {
            return Results.ValidationProblem(
                new Dictionary<string, string[]> { ["body"] = ["A request body is required."] });
        }

        var validation = await validator.ValidateAsync(request, context.HttpContext.RequestAborted);
        if (!validation.IsValid)
        {
            return Results.ValidationProblem(validation.ToDictionary());
        }

        return await next(context);
    }
}
