using System.Linq.Expressions;

namespace SeasonPal.Application.Common;

/// <summary>
/// Provider-agnostic description of a paged list query: filter criteria, projection, ordering
/// and paging. Application composes specifications; Infrastructure translates them against
/// EF Core, so no <c>IQueryable</c> escapes the persistence layer.
/// </summary>
public abstract class Specification<TEntity, TResult>
    where TEntity : class
{
    protected Specification(int page, int pageSize)
    {
        Page = page;
        PageSize = pageSize;
    }

    public int Page { get; }

    public int PageSize { get; }

    public int Skip => (Page - 1) * PageSize;

    public int Take => PageSize;

    /// <summary>Optional filter; a null criterion means "all rows".</summary>
    public virtual Expression<Func<TEntity, bool>>? Criteria { get; protected set; }

    /// <summary>Projection applied before materialization.</summary>
    public abstract Expression<Func<TEntity, TResult>> Select { get; }

    /// <summary>Primary ordering expression.</summary>
    public abstract Expression<Func<TEntity, object?>> OrderBy { get; }

    public virtual bool OrderDescending => false;

    /// <summary>Optional tie-breaker, e.g. added-at when orders are equal.</summary>
    public virtual Expression<Func<TEntity, object?>>? ThenBy => null;

    public virtual bool ThenByDescending => false;
}
