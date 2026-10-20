namespace SeasonPal.Domain.Entities;

/// <summary>
/// Canonical spelling for the small set of units a recipe can use. Users type "Tablespoons",
/// "tbsp." or "Tbs"; storing one spelling keeps filters and future scaling predictable without
/// doing any unit math here (that arrives with serving adjustment in Stage 8).
/// </summary>
public static class MeasurementUnits
{
    private static readonly IReadOnlyDictionary<string, string> Aliases =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["tbsp"] = "tbsp",
            ["tbs"] = "tbsp",
            ["tablespoon"] = "tbsp",
            ["tablespoons"] = "tbsp",
            ["tsp"] = "tsp",
            ["teaspoon"] = "tsp",
            ["teaspoons"] = "tsp",
            ["g"] = "g",
            ["gram"] = "g",
            ["grams"] = "g",
            ["kg"] = "kg",
            ["kilogram"] = "kg",
            ["kilograms"] = "kg",
            ["ml"] = "ml",
            ["milliliter"] = "ml",
            ["milliliters"] = "ml",
            ["millilitre"] = "ml",
            ["millilitres"] = "ml",
            ["l"] = "l",
            ["liter"] = "l",
            ["liters"] = "l",
            ["litre"] = "l",
            ["litres"] = "l",
            ["cup"] = "cup",
            ["cups"] = "cup",
            ["oz"] = "oz",
            ["ounce"] = "oz",
            ["ounces"] = "oz",
            ["lb"] = "lb",
            ["lbs"] = "lb",
            ["pound"] = "lb",
            ["pounds"] = "lb",
            ["pinch"] = "pinch",
            ["pinches"] = "pinch",
            ["clove"] = "clove",
            ["cloves"] = "clove",
            ["can"] = "can",
            ["cans"] = "can",
            ["slice"] = "slice",
            ["slices"] = "slice",
            ["piece"] = "piece",
            ["pieces"] = "piece",
            ["bunch"] = "bunch",
            ["bunches"] = "bunch",
            ["sprig"] = "sprig",
            ["sprigs"] = "sprig",
        };

    /// <summary>
    /// Trims the unit and returns its canonical spelling when it is a known alias. Unknown units
    /// keep the user's trimmed spelling so niche measures ("handful", "packet") are not lost.
    /// </summary>
    public static string? Normalize(string? unit)
    {
        var trimmed = unit?.Trim();
        if (string.IsNullOrEmpty(trimmed))
        {
            return null;
        }

        var key = trimmed.TrimEnd('.');
        return Aliases.TryGetValue(key, out var canonical) ? canonical : trimmed;
    }
}
