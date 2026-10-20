using SeasonPal.Domain.Entities;

namespace SeasonPal.UnitTests;

public class CollectionTests
{
    [Fact]
    public void Create_returns_the_named_collection_for_the_owner()
    {
        var userId = Guid.NewGuid();

        var result = Collection.Create(userId, "  Weeknights  ", description: "30-minute dinners", isDefaultFavorites: true);

        Assert.True(result.IsSuccess);
        Assert.Equal(userId, result.Value.UserId);
        Assert.Equal("Weeknights", result.Value.Name);
        Assert.Equal("30-minute dinners", result.Value.Description);
        Assert.True(result.Value.IsDefaultFavorites);
        Assert.Empty(result.Value.Items);
    }

    [Fact]
    public void Create_rejects_a_missing_owner()
    {
        var result = Collection.Create(Guid.Empty, "Weeknights");

        Assert.False(result.IsSuccess);
        Assert.Equal("collection.owner-required", result.Error!.Code);
    }

    [Fact]
    public void Create_rejects_blank_names()
    {
        var result = Collection.Create(Guid.NewGuid(), "   ");

        Assert.False(result.IsSuccess);
        Assert.Equal("collection.name-invalid", result.Error!.Code);
    }

    [Fact]
    public void Create_rejects_names_over_100_characters()
    {
        var result = Collection.Create(Guid.NewGuid(), new string('n', 101));

        Assert.False(result.IsSuccess);
        Assert.Equal("collection.name-invalid", result.Error!.Code);
        Assert.Equal("100", result.Error.Args["max"]);
    }
}
