using System.Linq.Expressions;

namespace SeasonPal.Application.Common;

/// <summary>
/// Combines filter predicates into one expression tree so optional read-model filters stay in
/// SQL. EF Core translates the combined tree; no <c>IQueryable</c> or provider type leaks upward.
/// </summary>
public static class ExpressionExtensions
{
    /// <summary>Returns a predicate that is true when either side is true.</summary>
    public static Expression<Func<T, bool>> OrElse<T>(
        this Expression<Func<T, bool>> left,
        Expression<Func<T, bool>> right)
    {
        var parameter = left.Parameters[0];
        var replaced = new ParameterReplacementVisitor(right.Parameters[0], parameter)
            .Visit(right.Body)!;

        return Expression.Lambda<Func<T, bool>>(
            Expression.OrElse(left.Body, replaced),
            parameter);
    }

    private sealed class ParameterReplacementVisitor(
        ParameterExpression from,
        ParameterExpression to) : ExpressionVisitor
    {
        protected override Expression VisitParameter(ParameterExpression node) =>
            node == from ? to : base.VisitParameter(node);
    }
}
