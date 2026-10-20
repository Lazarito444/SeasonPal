namespace SeasonPal.Api.Common;

/// <summary>
/// Page parameters shared by list endpoints. Invalid values are clamped rather than rejected:
/// a page below 1 becomes the first page and a page size above the cap becomes the cap.
/// </summary>
internal static class Pagination
{
    public const int DefaultPageSize = 20;

    public const int MaxPageSize = 50;

    public static (int Page, int PageSize) Normalize(int? page, int? pageSize)
    {
        var normalizedPage = page is null or < 1 ? 1 : page.Value;
        var normalizedSize = pageSize is null
            ? DefaultPageSize
            : Math.Clamp(pageSize.Value, 1, MaxPageSize);

        return (normalizedPage, normalizedSize);
    }
}
