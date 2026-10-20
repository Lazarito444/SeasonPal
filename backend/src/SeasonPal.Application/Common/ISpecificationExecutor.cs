namespace SeasonPal.Application.Common;

/// <summary>
/// Executes a <see cref="Specification{TEntity,TResult}"/> against the database. Implemented in
/// Infrastructure; Application handlers depend only on this contract.
/// </summary>
public interface ISpecificationExecutor
{
    Task<PagedResult<TResult>> ToPagedListAsync<TEntity, TResult>(
        Specification<TEntity, TResult> specification,
        CancellationToken cancellationToken = default)
        where TEntity : class;
}
