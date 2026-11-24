using System.Linq.Expressions;

namespace SeasonPal.Domain.Specifications;

/// <summary>
/// Base for query specifications that bundle criteria, ordering and paging for one entity
/// type. A specification is plain data: repositories read its members and translate them
/// to the persistence provider's query language, so nothing here references EF Core.
/// </summary>
/// <typeparam name="T">The entity the specification targets.</typeparam>
public abstract class BaseSpecification<T> : ISpecification<T>
{
    /// <summary>
    /// Upper bound for a page size, so a caller cannot request an unbounded page.
    /// </summary>
    public const int MaxPageSize = 100;

    private readonly List<Expression<Func<T, bool>>> _criteria = [];
    private readonly List<OrderByExpression<T>> _orderByExpressions = [];
    private LambdaExpression? _selector;

    /// <inheritdoc />
    public IReadOnlyList<Expression<Func<T, bool>>> Criteria => _criteria;

    /// <inheritdoc />
    public IReadOnlyList<OrderByExpression<T>> OrderByExpressions => _orderByExpressions;

    /// <inheritdoc />
    public LambdaExpression? Selector => _selector;

    /// <summary>Whether <c>AddSelector</c> configured a projection.</summary>
    public bool HasSelector => _selector is not null;

    /// <inheritdoc />
    public bool IsPagingEnabled { get; private set; }

    /// <inheritdoc />
    public int PageNumber { get; private set; }

    /// <inheritdoc />
    public int PageSize { get; private set; }

    /// <inheritdoc />
    public int Skip => IsPagingEnabled ? checked((PageNumber - 1) * PageSize) : 0;

    /// <inheritdoc />
    public int Take => PageSize;

    /// <summary>Adds a predicate; several calls combine with <c>AND</c>.</summary>
    /// <param name="criteria">The predicate a row must satisfy.</param>
    /// <exception cref="ArgumentNullException"><paramref name="criteria"/> is null.</exception>
    protected void AddCriteria(Expression<Func<T, bool>> criteria)
    {
        ArgumentNullException.ThrowIfNull(criteria);

        _criteria.Add(criteria);
    }

    /// <summary>
    /// Adds an ascending ordering clause. The first call is the primary sort; later calls
    /// break ties in the order they were added.
    /// </summary>
    /// <param name="keySelector">Selects the sort key.</param>
    /// <exception cref="ArgumentNullException"><paramref name="keySelector"/> is null.</exception>
    protected void AddOrderBy(Expression<Func<T, object?>> keySelector)
    {
        _orderByExpressions.Add(new OrderByExpression<T>(keySelector));
    }

    /// <summary>
    /// Adds a descending ordering clause. The first call is the primary sort; later calls
    /// break ties in the order they were added.
    /// </summary>
    /// <param name="keySelector">Selects the sort key.</param>
    /// <exception cref="ArgumentNullException"><paramref name="keySelector"/> is null.</exception>
    protected void AddOrderByDescending(Expression<Func<T, object?>> keySelector)
    {
        _orderByExpressions.Add(new OrderByExpression<T>(keySelector, OrderByDirection.Descending));
    }

    /// <summary>
    /// Sets the projection the query returns, usually a DTO built from the entity.
    /// A specification projects at most once.
    /// </summary>
    /// <typeparam name="TResult">The projected result type.</typeparam>
    /// <param name="selector">Maps a matching entity to the projected result.</param>
    /// <exception cref="ArgumentNullException"><paramref name="selector"/> is null.</exception>
    /// <exception cref="InvalidOperationException">A selector was already added.</exception>
    protected void AddSelector<TResult>(Expression<Func<T, TResult>> selector)
    {
        ArgumentNullException.ThrowIfNull(selector);

        if (_selector is not null)
        {
            throw new InvalidOperationException("A selector has already been added to this specification.");
        }

        _selector = selector;
    }

    /// <summary>
    /// Restricts the query to one page, replacing any earlier paging configuration.
    /// </summary>
    /// <param name="pageNumber">The 1-based page to return.</param>
    /// <param name="pageSize">The maximum number of rows on the page, from 1 to <see cref="MaxPageSize"/>.</param>
    /// <exception cref="ArgumentOutOfRangeException">
    /// <paramref name="pageNumber"/> is less than 1 or so large that the offset overflows
    /// <see cref="int"/>, or <paramref name="pageSize"/> is outside 1 to <see cref="MaxPageSize"/>.
    /// </exception>
    protected void ApplyPaging(int pageNumber, int pageSize)
    {
        ArgumentOutOfRangeException.ThrowIfLessThan(pageNumber, 1);
        ArgumentOutOfRangeException.ThrowIfLessThan(pageSize, 1);
        ArgumentOutOfRangeException.ThrowIfGreaterThan(pageSize, MaxPageSize);

        PageNumber = pageNumber;
        PageSize = pageSize;
        IsPagingEnabled = true;
    }
}
