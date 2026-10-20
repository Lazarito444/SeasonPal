namespace SeasonPal.Application.Common;

/// <summary>
/// One page of a list query. Every list endpoint returns this shape so clients can render
/// pagination consistently without knowing which repository produced the rows.
/// </summary>
public sealed record PagedResult<T>(
    IReadOnlyList<T> Items,
    int Page,
    int PageSize,
    int TotalCount)
{
    public int TotalPages => PageSize == 0 ? 0 : (int)Math.Ceiling(TotalCount / (double)PageSize);

    public bool HasNextPage => Page * PageSize < TotalCount;

    public bool HasPreviousPage => Page > 1;
}
