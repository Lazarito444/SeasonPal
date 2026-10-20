namespace SeasonPal.Application.Common;

/// <summary>
/// Outcome of an operation without payload. Expected business failures travel as
/// <see cref="ApplicationError"/> — throwing is reserved for the truly exceptional,
/// which the Api's exception handler converts to ProblemDetails.
/// </summary>
public sealed class Result
{
    public bool IsSuccess { get; }

    public ApplicationError? Error => IsSuccess ? null : _error;

    private readonly ApplicationError? _error;

    private Result(bool isSuccess, ApplicationError? error)
    {
        IsSuccess = isSuccess;
        _error = error;
    }

    public static Result Ok() => new(true, null);

    public static Result Fail(ApplicationError error) => new(false, error);

    public TOut Match<TOut>(Func<TOut> onSuccess, Func<ApplicationError, TOut> onFailure) =>
        IsSuccess ? onSuccess() : onFailure(_error!);

    /// <summary>Runs the continuation only when this result succeeded; errors pass through.</summary>
    public Result Bind(Func<Result> next) => IsSuccess ? next() : this;
}

/// <summary>Outcome of an operation producing <typeparamref name="T"/>.</summary>
public sealed class Result<T>
{
    public bool IsSuccess { get; }

    /// <summary>Payload; throws when accessed on a failed result — that's a caller bug, not a business case.</summary>
    public T Value => IsSuccess ? _value! : throw new InvalidOperationException("Value is not available on a failed result.");

    public ApplicationError? Error => IsSuccess ? null : _error;

    private readonly T? _value;
    private readonly ApplicationError? _error;

    private Result(T value)
    {
        IsSuccess = true;
        _value = value;
    }

    private Result(ApplicationError error)
    {
        IsSuccess = false;
        _error = error;
    }

    public static Result<T> Ok(T value) => new(value);

    public static Result<T> Fail(ApplicationError error) => new(error);

    public static implicit operator Result<T>(T value) => Ok(value);

    public Result<TOut> Bind<TOut>(Func<T, Result<TOut>> binder) =>
        IsSuccess ? binder(_value!) : Result<TOut>.Fail(_error!);

    public Result<TOut> Map<TOut>(Func<T, TOut> mapper) =>
        IsSuccess ? Result<TOut>.Ok(mapper(_value!)) : Result<TOut>.Fail(_error!);

    public TOut Match<TOut>(Func<T, TOut> onSuccess, Func<ApplicationError, TOut> onFailure) =>
        IsSuccess ? onSuccess(_value!) : onFailure(_error!);
}
