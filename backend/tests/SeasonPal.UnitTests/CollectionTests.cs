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

    [Fact]
    public void AddRecipe_assigns_contiguous_orders_and_is_idempotent()
    {
        var collection = Collection.Create(Guid.NewGuid(), "Weeknights").Value;
        var first = Guid.NewGuid();
        var second = Guid.NewGuid();

        Assert.True(collection.AddRecipe(first).IsSuccess);
        Assert.True(collection.AddRecipe(second).IsSuccess);
        Assert.True(collection.AddRecipe(first).IsSuccess);

        Assert.Equal(2, collection.Items.Count);
        Assert.Equal([1, 2], collection.Items.Select(item => item.Order));
        Assert.Equal([first, second], collection.Items.Select(item => item.RecipeId));
    }

    [Fact]
    public void RemoveRecipe_renumbers_the_remaining_items()
    {
        var collection = Collection.Create(Guid.NewGuid(), "Weeknights").Value;
        var first = Guid.NewGuid();
        var second = Guid.NewGuid();
        var third = Guid.NewGuid();
        collection.AddRecipe(first);
        collection.AddRecipe(second);
        collection.AddRecipe(third);

        var removed = collection.RemoveRecipe(second);

        Assert.True(removed.IsSuccess);
        Assert.Equal([first, third], collection.Items.Select(item => item.RecipeId));
        Assert.Equal([1, 2], collection.Items.Select(item => item.Order));
        Assert.True(collection.RemoveRecipe(Guid.NewGuid()).IsSuccess);
    }

    [Fact]
    public void Reorder_requires_the_full_set_and_applies_the_new_order()
    {
        var collection = Collection.Create(Guid.NewGuid(), "Weeknights").Value;
        var first = Guid.NewGuid();
        var second = Guid.NewGuid();
        var third = Guid.NewGuid();
        collection.AddRecipe(first);
        collection.AddRecipe(second);
        collection.AddRecipe(third);

        var reordered = collection.Reorder([third, first, second]);

        Assert.True(reordered.IsSuccess);
        Assert.Equal([third, first, second], collection.Items.OrderBy(item => item.Order).Select(item => item.RecipeId));
        Assert.Equal([1, 2, 3], collection.Items.OrderBy(item => item.Order).Select(item => item.Order));

        Assert.Equal("collection.reorder-mismatch", collection.Reorder([third, first]).Error!.Code);
        Assert.Equal("collection.reorder-mismatch", collection.Reorder([third, third, first]).Error!.Code);
        Assert.Equal(
            "collection.reorder-mismatch",
            collection.Reorder([third, first, Guid.NewGuid()]).Error!.Code);
    }

    [Fact]
    public void UpdateDetails_protects_favorites_but_updates_custom_collections()
    {
        var favorites = Collection.Create(Guid.NewGuid(), "Favorites", isDefaultFavorites: true).Value;
        var custom = Collection.Create(Guid.NewGuid(), "Weeknights").Value;

        var blocked = favorites.UpdateDetails("Renamed", "Nope");
        var updated = custom.UpdateDetails("  Fast dinners  ", "  30 minutes or less  ");

        Assert.False(blocked.IsSuccess);
        Assert.Equal("collection.favorites-protected", blocked.Error!.Code);
        Assert.Equal("Favorites", favorites.Name);

        Assert.True(updated.IsSuccess);
        Assert.Equal("Fast dinners", custom.Name);
        Assert.Equal("30 minutes or less", custom.Description);
    }

    [Fact]
    public void AddRecipe_rejects_an_empty_recipe_id()
    {
        var collection = Collection.Create(Guid.NewGuid(), "Weeknights").Value;

        var result = collection.AddRecipe(Guid.Empty);

        Assert.False(result.IsSuccess);
        Assert.Equal("collection.recipe-required", result.Error!.Code);
    }
}
