namespace SeasonPal.Core.Results;

/// <summary>
/// Outcome of an operation producing <typeparamref name="T"/>. Expected business failures
/// travel as <see cref="Results.Error"/>; throwing is reserved for the truly exceptional.
/// </summary>
/// <typeparam name="T">The payload type produced on success.</typeparam>
public sealed class Result<T>
{
    private readonly T? _value;
    private readonly Error? _error;

    private Result(T value)
    {
        IsSuccess = true;
        _value = value;
    }

    private Result(Error error)
    {
        IsSuccess = false;
        _error = error;
    }

    /// <summary>Whether the operation succeeded.</summary>
    public bool IsSuccess { get; }

    /// <summary>Whether the operation failed.</summary>
    public bool IsError => !IsSuccess;

    /// <summary>
    /// The payload; throws when read on a failed result because that is a caller bug,
    /// not a business case — branch on <see cref="IsSuccess"/> first.
    /// </summary>
    /// <exception cref="InvalidOperationException">The result is a failure.</exception>
    public T Value => IsSuccess
        ? _value!
        : throw new InvalidOperationException("Value is not available on a failed result.");

    /// <summary>The failure when the operation failed; null on success.</summary>
    public Error? Error => IsSuccess ? null : _error;

    /// <summary>Creates a successful result carrying <paramref name="value"/>.</summary>
    /// <param name="value">The produced payload.</param>
    public static Result<T> Ok(T value) => new(value);

    /// <summary>Creates a failed result carrying <paramref name="error"/>.</summary>
    /// <param name="error">The business failure to report.</param>
    public static Result<T> Fail(Error error)
    {
        ArgumentNullException.ThrowIfNull(error);
        return new Result<T>(error);
    }

    /// <summary>Wraps a payload in a successful result.</summary>
    /// <param name="value">The produced payload.</param>
    public static implicit operator Result<T>(T value) => Ok(value);

    /// <summary>Transforms the payload on success; failures pass through unchanged.</summary>
    /// <typeparam name="TOut">The mapped payload type.</typeparam>
    /// <param name="mapper">The payload transformation.</param>
    public Result<TOut> Map<TOut>(Func<T, TOut> mapper)
    {
        ArgumentNullException.ThrowIfNull(mapper);

        return IsSuccess
            ? Result<TOut>.Ok(mapper(_value!))
            : Result<TOut>.Fail(_error!);
    }

    /// <summary>Chains another operation on success; failures pass through unchanged.</summary>
    /// <typeparam name="TOut">The next result's payload type.</typeparam>
    /// <param name="binder">The operation to run with the payload.</param>
    public Result<TOut> Bind<TOut>(Func<T, Result<TOut>> binder)
    {
        ArgumentNullException.ThrowIfNull(binder);

        return IsSuccess ? binder(_value!) : Result<TOut>.Fail(_error!);
    }

    /// <summary>Projects this result into a single value, on either branch.</summary>
    /// <typeparam name="TOut">The projected type.</typeparam>
    /// <param name="onSuccess">Runs with the payload when the operation succeeded.</param>
    /// <param name="onFailure">Runs when the operation failed.</param>
    public TOut Match<TOut>(Func<T, TOut> onSuccess, Func<Error, TOut> onFailure)
    {
        ArgumentNullException.ThrowIfNull(onSuccess);
        ArgumentNullException.ThrowIfNull(onFailure);

        return IsSuccess ? onSuccess(_value!) : onFailure(_error!);
    }
}
