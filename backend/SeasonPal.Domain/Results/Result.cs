namespace SeasonPal.Domain.Results;

/// <summary>
/// Outcome of an operation that produces no payload. Expected business failures travel as
/// <see cref="Results.Error"/>; throwing is reserved for the truly exceptional.
/// </summary>
public sealed class Result
{
    private readonly Error? _error;

    private Result(bool isSuccess, Error? error)
    {
        IsSuccess = isSuccess;
        _error = error;
    }

    /// <summary>Whether the operation succeeded.</summary>
    public bool IsSuccess { get; }

    /// <summary>Whether the operation failed.</summary>
    public bool IsError => !IsSuccess;

    /// <summary>The failure when the operation failed; null on success.</summary>
    public Error? Error => IsSuccess ? null : _error;

    /// <summary>Creates a successful result.</summary>
    public static Result Ok() => new(true, null);

    /// <summary>Creates a failed result carrying <paramref name="error"/>.</summary>
    /// <param name="error">The business failure to report.</param>
    public static Result Fail(Error error)
    {
        ArgumentNullException.ThrowIfNull(error);
        return new Result(false, error);
    }

    /// <summary>Projects this result into a single value, on either branch.</summary>
    /// <typeparam name="TOut">The projected type.</typeparam>
    /// <param name="onSuccess">Runs when the operation succeeded.</param>
    /// <param name="onFailure">Runs when the operation failed.</param>
    public TOut Match<TOut>(Func<TOut> onSuccess, Func<Error, TOut> onFailure)
    {
        ArgumentNullException.ThrowIfNull(onSuccess);
        ArgumentNullException.ThrowIfNull(onFailure);

        return IsSuccess ? onSuccess() : onFailure(_error!);
    }

    /// <summary>Runs the continuation only when this result succeeded; failures pass through.</summary>
    /// <param name="next">The continuation to run on success.</param>
    public Result Bind(Func<Result> next)
    {
        ArgumentNullException.ThrowIfNull(next);
        return IsSuccess ? next() : this;
    }
}
