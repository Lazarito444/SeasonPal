namespace SeasonPal.Api.Common;

/// <summary>Query-string page parameters for endpoints whose only list option is paging.</summary>
public sealed class PageQuery
{
    public int? Page { get; set; }

    public int? PageSize { get; set; }
}
