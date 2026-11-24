using System.Linq.Expressions;

namespace SeasonPal.Domain.Specifications;

/// <summary>Direction of a single ordering clause.</summary>
public enum OrderByDirection
{
    /// <summary>Smallest first.</summary>
    Ascending,

    /// <summary>Largest first.</summary>
    Descending,
}

/// <summary>
/// One ordering clause of a specification. Several clauses compose into a multi-column
/// sort, where each clause after the first breaks ties of the preceding ones.
/// </summary>
/// <typeparam name="T">The entity being ordered.</typeparam>
public sealed class OrderByExpression<T>
{
    /// <summary>Creates an ordering clause.</summary>
    /// <param name="keySelector">Selects the sort key; the boxed type keeps clauses of different key types in one list.</param>
    /// <param name="direction">Whether the key is sorted ascending or descending.</param>
    /// <exception cref="ArgumentNullException"><paramref name="keySelector"/> is null.</exception>
    /// <exception cref="ArgumentOutOfRangeException"><paramref name="direction"/> is not a defined value.</exception>
    public OrderByExpression(
        Expression<Func<T, object?>> keySelector,
        OrderByDirection direction = OrderByDirection.Ascending)
    {
        ArgumentNullException.ThrowIfNull(keySelector);

        if (!Enum.IsDefined(direction))
        {
            throw new ArgumentOutOfRangeException(nameof(direction), direction, "Unknown sort direction.");
        }

        KeySelector = keySelector;
        Direction = direction;
    }

    /// <summary>The key to sort on.</summary>
    public Expression<Func<T, object?>> KeySelector { get; }

    /// <summary>Whether the key is sorted ascending or descending.</summary>
    public OrderByDirection Direction { get; }
}
