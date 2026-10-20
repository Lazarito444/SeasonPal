using SeasonPal.Domain.Entities;

namespace SeasonPal.UnitTests;

public class MeasurementUnitsTests
{
    [Theory]
    [InlineData("Tablespoons", "tbsp")]
    [InlineData("tbsp.", "tbsp")]
    [InlineData("TBS", "tbsp")]
    [InlineData(" teaspoons ", "tsp")]
    [InlineData("Grams", "g")]
    [InlineData("kg", "kg")]
    [InlineData("millilitres", "ml")]
    [InlineData("Cups", "cup")]
    [InlineData("ounces", "oz")]
    [InlineData("pounds", "lb")]
    [InlineData("cloves", "clove")]
    public void Normalize_maps_known_aliases_to_the_canonical_spelling(string input, string expected)
    {
        Assert.Equal(expected, MeasurementUnits.Normalize(input));
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("   ")]
    public void Normalize_returns_null_for_missing_units(string? input)
    {
        Assert.Null(MeasurementUnits.Normalize(input));
    }

    [Fact]
    public void Normalize_keeps_unknown_units_trimmed()
    {
        Assert.Equal("handful", MeasurementUnits.Normalize("  handful "));
    }
}
