using System.Linq.Expressions;

namespace SeasonPal.Domain.Specifications;

/// <summary>
/// Base for specifications whose result type is known at compile time. The projection is
/// added with <c>AddSelector</c> in the constructor, like criteria and ordering.
/// </summary>
/// <typeparam name="T">The entity the constraints apply to.</typeparam>
/// <typeparam name="TResult">The projected result type.</typeparam>
public abstract class BaseSpecification<T, TResult> : BaseSpecification<T>, ISpecification<T, TResult>
{
    /// <inheritdoc />
    /// <exception cref="InvalidOperationException">No selector was added in the constructor.</exception>
    public new Expression<Func<T, TResult>> Selector =>
        base.Selector as Expression<Func<T, TResult>>
        ?? throw new InvalidOperationException(
            $"This specification has no selector projecting to {typeof(TResult).Name}; call AddSelector in the constructor.");
}
