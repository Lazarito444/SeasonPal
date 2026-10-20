using Microsoft.EntityFrameworkCore;
using SeasonPal.Application.Common;

namespace SeasonPal.Infrastructure.Persistence;

/// <summary>
/// Translates Application specifications into one EF Core query: count, order, page and project.
/// Keeping this in Infrastructure is what stops <c>IQueryable</c> from leaking upward.
/// </summary>
public sealed class SpecificationExecutor(SeasonPalDbContext context) : ISpecificationExecutor
{
    public async Task<PagedResult<TResult>> ToPagedListAsync<TEntity, TResult>(
        Specification<TEntity, TResult> specification,
        CancellationToken cancellationToken = default)
        where TEntity : class
    {
        IQueryable<TEntity> query = context.Set<TEntity>().AsNoTracking();

        if (specification.Criteria is not null)
        {
            query = query.Where(specification.Criteria);
        }

        var totalCount = await query.CountAsync(cancellationToken);

        var ordered = specification.OrderDescending
            ? query.OrderByDescending(specification.OrderBy)
            : query.OrderBy(specification.OrderBy);

        if (specification.ThenBy is not null)
        {
            ordered = specification.ThenByDescending
                ? ordered.ThenByDescending(specification.ThenBy)
                : ordered.ThenBy(specification.ThenBy);
        }

        var items = await ordered
            .Skip(specification.Skip)
            .Take(specification.Take)
            .Select(specification.Select)
            .ToListAsync(cancellationToken);

        return new PagedResult<TResult>(
            items,
            specification.Page,
            specification.PageSize,
            totalCount);
    }
}
