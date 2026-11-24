using System.Linq.Expressions;

namespace SeasonPal.Domain.Specifications;

/// <summary>
/// Read-only view of a specification's query constraints. Repositories consume this
/// instead of the concrete specification so they stay independent of individual queries.
/// </summary>
/// <typeparam name="T">The entity the constraints apply to.</typeparam>
public interface ISpecification<T>
{
    /// <summary>
    /// Predicates that must all hold, combined with <c>AND</c> in evaluation order.
    /// </summary>
    IReadOnlyList<Expression<Func<T, bool>>> Criteria { get; }

    /// <summary>
    /// Ordering clauses in evaluation order: the first is the primary sort and every
    /// later entry breaks ties of the ones before it.
    /// </summary>
    IReadOnlyList<OrderByExpression<T>> OrderByExpressions { get; }

    /// <summary>
    /// The projection added with <c>AddSelector</c>, or null when the query returns whole
    /// entities. Its result type is erased here; use <see cref="ISpecification{T, TResult}"/>
    /// when the projected type is known.
    /// </summary>
    LambdaExpression? Selector { get; }

    /// <summary>Whether paging was configured with <c>ApplyPaging</c>.</summary>
    bool IsPagingEnabled { get; }

    /// <summary>The requested 1-based page; <c>0</c> when paging is disabled.</summary>
    int PageNumber { get; }

    /// <summary>The requested page size; <c>0</c> when paging is disabled.</summary>
    int PageSize { get; }

    /// <summary>The number of rows to skip before the page; <c>0</c> when paging is disabled.</summary>
    int Skip { get; }

    /// <summary>The number of rows on the page; <c>0</c> when paging is disabled.</summary>
    int Take { get; }
}

/// <summary>
/// Specification that also selects the shape returned by the query, allowing callers to
/// fetch only the fields they need instead of whole entities.
/// </summary>
/// <typeparam name="T">The entity the constraints apply to.</typeparam>
/// <typeparam name="TResult">The projected result type.</typeparam>
public interface ISpecification<T, TResult> : ISpecification<T>
{
    /// <summary>Maps each matching entity to the projected result.</summary>
    new Expression<Func<T, TResult>> Selector { get; }
}
