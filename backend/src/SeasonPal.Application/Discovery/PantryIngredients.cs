using SeasonPal.Domain.Common;

namespace SeasonPal.Application.Discovery;

/// <summary>
/// Normalizes free-form pantry input: each value may contain comma-separated terms, blanks are
/// dropped, case is folded, and duplicates disappear before the matcher runs.
/// </summary>
public static class PantryIngredients
{
    public const int MaxTerms = 30;

    public const int MaxTermLength = 100;

    public static Result<IReadOnlyList<string>> Normalize(IEnumerable<string?>? values)
    {
        var terms = new List<string>();

        foreach (var raw in values ?? [])
        {
            var parts = (raw ?? string.Empty).Split(
                ',',
                StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

            foreach (var part in parts)
            {
                if (part.Length > MaxTermLength)
                {
                    return Result<IReadOnlyList<string>>.Fail(
                        ApplicationError.Of(
                            "discovery.pantry-term-invalid",
                            "Each pantry ingredient must be 100 characters or fewer.",
                            ("max", MaxTermLength.ToString())));
                }

                var normalized = part.ToLowerInvariant();
                if (!terms.Contains(normalized, StringComparer.Ordinal))
                {
                    terms.Add(normalized);
                }
            }
        }

        if (terms.Count == 0)
        {
            return Result<IReadOnlyList<string>>.Fail(
                ApplicationError.Of(
                    "discovery.pantry-empty",
                    "Add at least one ingredient you have."));
        }

        if (terms.Count > MaxTerms)
        {
            return Result<IReadOnlyList<string>>.Fail(
                ApplicationError.Of(
                    "discovery.pantry-too-many",
                    "Match at most 30 pantry ingredients at once.",
                    ("max", MaxTerms.ToString())));
        }

        return Result<IReadOnlyList<string>>.Ok(terms);
    }
}
