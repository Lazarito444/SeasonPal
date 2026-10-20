using System.Net;
using System.Net.Http.Json;
using SeasonPal.Application.Collections;
using SeasonPal.Application.Common;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Enums;

namespace SeasonPal.IntegrationTests;

[Collection("SeasonPalApi")]
public class RecipeEndpointsTests(SeasonPalApiFactory factory)
{
    [Fact]
    public async Task Recipe_crud_publish_and_visibility_round_trip()
    {
        var ownerClient = factory.CreateClient();
        var owner = await AuthTestData.RegisterAsync(
            ownerClient,
            AuthTestData.UniqueEmail(),
            "Ava Cook");
        var ownerApi = RecipeTestData.AuthorizedClient(factory, owner.AccessToken);

        var created = await RecipeTestData.CreateAsync(
            ownerApi,
            RecipeTestData.Write("One-pan lemon orzo"));

        Assert.Equal(owner.User.Id, created.Author.Id);
        Assert.Equal("Ava Cook", created.Author.DisplayName);
        Assert.Equal("One-pan lemon orzo", created.Title);
        Assert.Equal("Italian", created.Cuisine);
        Assert.Equal(RecipeVisibility.Private, created.Visibility);
        Assert.Equal(RecipeStatus.Draft, created.Status);
        Assert.Equal(10, created.PrepTimeMinutes);
        Assert.Equal(20, created.CookTimeMinutes);
        Assert.Equal(30, created.TotalTimeMinutes);
        Assert.Equal(["Weeknight"], created.Tags);
        Assert.Equal(["Vegetarian"], created.DietaryTags);
        Assert.Equal(2, created.Ingredients.Count);
        Assert.Equal([1, 2], created.Ingredients.Select(ingredient => ingredient.Order));
        Assert.Equal("tbsp", created.Ingredients[0].Unit);
        Assert.Equal("g", created.Ingredients[1].Unit);
        Assert.Equal(2, created.Steps.Count);
        Assert.False(created.IsSaved);

        var ownerDetail = await ownerApi.GetFromJsonAsync<RecipeDetailDto>($"/recipes/{created.Id}");
        Assert.NotNull(ownerDetail);
        Assert.Equal(created.Id, ownerDetail.Id);

        var otherClient = factory.CreateClient();
        var other = await AuthTestData.RegisterAsync(
            otherClient,
            AuthTestData.UniqueEmail(),
            "Other Cook");
        var otherApi = RecipeTestData.AuthorizedClient(factory, other.AccessToken);

        var hidden = await otherApi.GetAsync($"/recipes/{created.Id}");
        Assert.Equal(HttpStatusCode.NotFound, hidden.StatusCode);
        Assert.Equal("recipe.not-found", await RecipeTestData.ProblemCodeAsync(hidden));

        await RecipeTestData.PublishAsync(ownerApi, created.Id);

        var visible = await otherApi.GetFromJsonAsync<RecipeDetailDto>($"/recipes/{created.Id}");
        Assert.NotNull(visible);
        Assert.Equal(RecipeVisibility.Public, visible.Visibility);
        Assert.Equal(RecipeStatus.Published, visible.Status);
        Assert.False(visible.IsSaved);

        var otherUpdate = await otherApi.PutAsJsonAsync(
            $"/recipes/{created.Id}",
            RecipeTestData.Write("Hijacked"));
        Assert.Equal(HttpStatusCode.NotFound, otherUpdate.StatusCode);

        var otherDelete = await otherApi.DeleteAsync($"/recipes/{created.Id}");
        Assert.Equal(HttpStatusCode.NotFound, otherDelete.StatusCode);

        var otherPublish = await otherApi.PostAsync($"/recipes/{created.Id}/publish", content: null);
        Assert.Equal(HttpStatusCode.NotFound, otherPublish.StatusCode);

        var unpublish = await ownerApi.PostAsync($"/recipes/{created.Id}/unpublish", content: null);
        Assert.Equal(HttpStatusCode.NoContent, unpublish.StatusCode);

        var hiddenAgain = await otherApi.GetAsync($"/recipes/{created.Id}");
        Assert.Equal(HttpStatusCode.NotFound, hiddenAgain.StatusCode);

        var updateRequest = RecipeTestData.Write("Updated lemon orzo", servings: 4) with
        {
            Ingredients = [new RecipeIngredientInput(250, "grams", "orzo", "toasted")],
        };

        var updatedResponse = await ownerApi.PutAsJsonAsync(
            $"/recipes/{created.Id}",
            updateRequest);
        updatedResponse.EnsureSuccessStatusCode();
        var updated = (await updatedResponse.Content.ReadFromJsonAsync<RecipeDetailDto>())!;

        Assert.Equal("Updated lemon orzo", updated.Title);
        Assert.Equal(4, updated.Servings);
        Assert.Single(updated.Ingredients);
        Assert.Equal("toasted", updated.Ingredients[0].Note);
        Assert.Equal(RecipeVisibility.Private, updated.Visibility);

        var deleted = await ownerApi.DeleteAsync($"/recipes/{created.Id}");
        Assert.Equal(HttpStatusCode.NoContent, deleted.StatusCode);

        var gone = await ownerApi.GetAsync($"/recipes/{created.Id}");
        Assert.Equal(HttpStatusCode.NotFound, gone.StatusCode);
    }

    [Fact]
    public async Task Publishing_requires_at_least_one_ingredient_and_step()
    {
        var session = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail());
        var api = RecipeTestData.AuthorizedClient(factory, session.AccessToken);

        var draft = await RecipeTestData.CreateAsync(
            api,
            RecipeTestData.Write("Empty draft", includeContent: false));

        var incomplete = await api.PostAsync($"/recipes/{draft.Id}/publish", content: null);
        Assert.Equal(HttpStatusCode.BadRequest, incomplete.StatusCode);
        Assert.Equal("recipe.publish-incomplete", await RecipeTestData.ProblemCodeAsync(incomplete));

        var fill = await api.PutAsJsonAsync(
            $"/recipes/{draft.Id}",
            RecipeTestData.Write("Filled draft"));
        fill.EnsureSuccessStatusCode();

        var published = await api.PostAsync($"/recipes/{draft.Id}/publish", content: null);
        Assert.Equal(HttpStatusCode.NoContent, published.StatusCode);
    }

    [Fact]
    public async Task Own_recipe_list_paginates_and_composes_filters()
    {
        var owner = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail());
        var api = RecipeTestData.AuthorizedClient(factory, owner.AccessToken);

        var quick = await RecipeTestData.CreateAsync(
            api,
            RecipeTestData.Write(
                "Quick Italian",
                cuisine: "Italian",
                prepTimeMinutes: 5,
                cookTimeMinutes: 10,
                difficulty: RecipeDifficulty.Easy,
                tags: ["Weeknight"],
                dietaryTags: ["Vegetarian"]));

        var slow = await RecipeTestData.CreateAsync(
            api,
            RecipeTestData.Write(
                "Slow Levantine",
                cuisine: "Levantine",
                prepTimeMinutes: 20,
                cookTimeMinutes: 60,
                difficulty: RecipeDifficulty.Medium,
                tags: ["Weekend"],
                dietaryTags: ["Vegan"]));

        var feast = await RecipeTestData.CreateAsync(
            api,
            RecipeTestData.Write(
                "Italian Feast",
                cuisine: "Italian",
                prepTimeMinutes: 30,
                cookTimeMinutes: 60,
                difficulty: RecipeDifficulty.Hard,
                tags: ["Weekend"],
                dietaryTags: ["Vegetarian"]));

        var other = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail());
        var otherApi = RecipeTestData.AuthorizedClient(factory, other.AccessToken);
        var otherRecipe = await RecipeTestData.CreateAsync(
            otherApi,
            RecipeTestData.Write("Someone else's Italian", cuisine: "Italian"));

        var firstPage = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            "/recipes?page=1&pageSize=2");
        Assert.NotNull(firstPage);
        Assert.Equal(3, firstPage.TotalCount);
        Assert.Equal(2, firstPage.Items.Count);
        Assert.True(firstPage.HasNextPage);
        Assert.DoesNotContain(firstPage.Items, item => item.Id == otherRecipe.Id);

        var secondPage = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            "/recipes?page=2&pageSize=2");
        Assert.NotNull(secondPage);
        Assert.Single(secondPage.Items);
        Assert.False(secondPage.HasNextPage);

        var allIds = firstPage.Items.Select(item => item.Id)
            .Concat(secondPage.Items.Select(item => item.Id))
            .ToHashSet();
        Assert.Equal(new HashSet<Guid> { quick.Id, slow.Id, feast.Id }, allIds);

        var italian = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            $"/recipes?cuisine={Uri.EscapeDataString("Italian")}");
        Assert.NotNull(italian);
        Assert.Equal(2, italian.TotalCount);
        Assert.All(italian.Items, item => Assert.Equal("Italian", item.Cuisine));

        var quickOnly = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            "/recipes?maxTotalTimeMinutes=30");
        Assert.NotNull(quickOnly);
        Assert.Single(quickOnly.Items);
        Assert.Equal(quick.Id, quickOnly.Items[0].Id);

        var medium = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            $"/recipes?difficulty={(int)RecipeDifficulty.Medium}");
        Assert.NotNull(medium);
        Assert.Single(medium.Items);
        Assert.Equal(slow.Id, medium.Items[0].Id);

        var vegetarian = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            "/recipes?diet=Vegetarian");
        Assert.NotNull(vegetarian);
        Assert.Equal(2, vegetarian.TotalCount);

        var weekend = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            "/recipes?tag=Weekend");
        Assert.NotNull(weekend);
        Assert.Equal(2, weekend.TotalCount);

        var combined = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            "/recipes?cuisine=Italian&diet=Vegetarian&tag=Weekend");
        Assert.NotNull(combined);
        Assert.Single(combined.Items);
        Assert.Equal(feast.Id, combined.Items[0].Id);

        var capped = await api.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            "/recipes?pageSize=500");
        Assert.NotNull(capped);
        Assert.Equal(50, capped.PageSize);
    }

    [Fact]
    public async Task Saving_puts_a_recipe_in_favorites_and_an_optional_collection()
    {
        var owner = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail(),
            "Recipe Author");
        var ownerApi = RecipeTestData.AuthorizedClient(factory, owner.AccessToken);

        var first = await RecipeTestData.CreateAsync(ownerApi, RecipeTestData.Write("First public"));
        var second = await RecipeTestData.CreateAsync(ownerApi, RecipeTestData.Write("Second public"));
        await RecipeTestData.PublishAsync(ownerApi, first.Id);
        await RecipeTestData.PublishAsync(ownerApi, second.Id);

        var saver = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail(),
            "Saved Cook");
        var saverApi = RecipeTestData.AuthorizedClient(factory, saver.AccessToken);

        var saveFirst = await saverApi.PostAsync($"/recipes/{first.Id}/save", content: null);
        Assert.Equal(HttpStatusCode.NoContent, saveFirst.StatusCode);

        var saved = await saverApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>("/recipes/saved");
        Assert.NotNull(saved);
        Assert.Equal(1, saved.TotalCount);
        Assert.Equal(first.Id, saved.Items[0].Id);
        Assert.NotNull(saved.Items[0].SavedAt);

        var detail = await saverApi.GetFromJsonAsync<RecipeDetailDto>($"/recipes/{first.Id}");
        Assert.NotNull(detail);
        Assert.True(detail.IsSaved);

        var collections = await saverApi.GetFromJsonAsync<PagedResult<CollectionSummaryDto>>(
            "/collections");
        Assert.NotNull(collections);
        var favorites = Assert.Single(collections.Items, item => item.IsDefaultFavorites);
        Assert.Equal(1, favorites.RecipeCount);

        var favoritesDetail = await saverApi.GetFromJsonAsync<CollectionDetailDto>(
            $"/collections/{favorites.Id}");
        Assert.NotNull(favoritesDetail);
        Assert.Single(favoritesDetail.Recipes.Items);
        Assert.Equal(first.Id, favoritesDetail.Recipes.Items[0].Id);

        var createdCollectionResponse = await saverApi.PostAsJsonAsync(
            "/collections",
            new CreateCollectionRequest("Weeknights", "Dinner ideas"));
        Assert.Equal(HttpStatusCode.Created, createdCollectionResponse.StatusCode);
        var collection = (await createdCollectionResponse.Content
            .ReadFromJsonAsync<CollectionSummaryDto>())!;

        var saveSecond = await saverApi.PostAsync(
            $"/recipes/{second.Id}/save?collectionId={collection.Id}",
            content: null);
        Assert.Equal(HttpStatusCode.NoContent, saveSecond.StatusCode);

        saved = await saverApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>("/recipes/saved");
        Assert.NotNull(saved);
        Assert.Equal(2, saved.TotalCount);

        var collectionDetail = await saverApi.GetFromJsonAsync<CollectionDetailDto>(
            $"/collections/{collection.Id}");
        Assert.NotNull(collectionDetail);
        Assert.Single(collectionDetail.Recipes.Items);
        Assert.Equal(second.Id, collectionDetail.Recipes.Items[0].Id);

        var unsaveFirst = await saverApi.DeleteAsync($"/recipes/{first.Id}/save");
        Assert.Equal(HttpStatusCode.NoContent, unsaveFirst.StatusCode);

        saved = await saverApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>("/recipes/saved");
        Assert.NotNull(saved);
        Assert.Equal(1, saved.TotalCount);
        Assert.Equal(second.Id, saved.Items[0].Id);

        favoritesDetail = await saverApi.GetFromJsonAsync<CollectionDetailDto>(
            $"/collections/{favorites.Id}");
        Assert.NotNull(favoritesDetail);
        Assert.Single(favoritesDetail.Recipes.Items);

        var unsaveSecond = await saverApi.DeleteAsync($"/recipes/{second.Id}/save");
        Assert.Equal(HttpStatusCode.NoContent, unsaveSecond.StatusCode);

        saved = await saverApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>("/recipes/saved");
        Assert.NotNull(saved);
        Assert.Empty(saved.Items);

        collectionDetail = await saverApi.GetFromJsonAsync<CollectionDetailDto>(
            $"/collections/{collection.Id}");
        Assert.NotNull(collectionDetail);
        Assert.Empty(collectionDetail.Recipes.Items);

        var privateRecipe = await RecipeTestData.CreateAsync(
            ownerApi,
            RecipeTestData.Write("Private draft"));
        var denied = await saverApi.PostAsync($"/recipes/{privateRecipe.Id}/save", content: null);
        Assert.Equal(HttpStatusCode.NotFound, denied.StatusCode);

        var ownDraft = await RecipeTestData.CreateAsync(
            saverApi,
            RecipeTestData.Write("Saver's own draft"));
        var saveOwn = await saverApi.PostAsync($"/recipes/{ownDraft.Id}/save", content: null);
        Assert.Equal(HttpStatusCode.NoContent, saveOwn.StatusCode);

        var repeated = await saverApi.DeleteAsync($"/recipes/{ownDraft.Id}/save");
        var repeatedAgain = await saverApi.DeleteAsync($"/recipes/{ownDraft.Id}/save");
        Assert.Equal(HttpStatusCode.NoContent, repeated.StatusCode);
        Assert.Equal(HttpStatusCode.NoContent, repeatedAgain.StatusCode);
    }

    [Fact]
    public async Task Collection_crud_order_and_authorization_are_enforced()
    {
        var owner = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail(),
            "Collection Owner");
        var api = RecipeTestData.AuthorizedClient(factory, owner.AccessToken);

        var createResponse = await api.PostAsJsonAsync(
            "/collections",
            new CreateCollectionRequest("  Weeknights  ", "  Fast dinners  "));
        Assert.Equal(HttpStatusCode.Created, createResponse.StatusCode);
        var weeknights = (await createResponse.Content
            .ReadFromJsonAsync<CollectionSummaryDto>())!;
        Assert.Equal("Weeknights", weeknights.Name);
        Assert.Equal("Fast dinners", weeknights.Description);
        Assert.False(weeknights.IsDefaultFavorites);
        Assert.Equal(0, weeknights.RecipeCount);

        var duplicate = await api.PostAsJsonAsync(
            "/collections",
            new CreateCollectionRequest("weeknights", null));
        Assert.Equal(HttpStatusCode.Conflict, duplicate.StatusCode);
        Assert.Equal("collection.name-taken", await RecipeTestData.ProblemCodeAsync(duplicate));

        var guestsResponse = await api.PostAsJsonAsync(
            "/collections",
            new CreateCollectionRequest("Guests", null));
        guestsResponse.EnsureSuccessStatusCode();
        var guests = (await guestsResponse.Content.ReadFromJsonAsync<CollectionSummaryDto>())!;

        var list = await api.GetFromJsonAsync<PagedResult<CollectionSummaryDto>>(
            "/collections?page=1&pageSize=2");
        Assert.NotNull(list);
        Assert.Equal(3, list.TotalCount);
        Assert.Equal(2, list.Items.Count);
        Assert.True(list.HasNextPage);

        var renameResponse = await api.PutAsJsonAsync(
            $"/collections/{weeknights.Id}",
            new UpdateCollectionRequest("Fast dinners", "30 minutes or less"));
        renameResponse.EnsureSuccessStatusCode();
        var renamed = (await renameResponse.Content.ReadFromJsonAsync<CollectionSummaryDto>())!;
        Assert.Equal("Fast dinners", renamed.Name);
        Assert.Equal("30 minutes or less", renamed.Description);

        var other = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail());
        var otherApi = RecipeTestData.AuthorizedClient(factory, other.AccessToken);

        Assert.Equal(
            HttpStatusCode.NotFound,
            (await otherApi.GetAsync($"/collections/{weeknights.Id}")).StatusCode);
        Assert.Equal(
            HttpStatusCode.NotFound,
            (await otherApi.PutAsJsonAsync(
                $"/collections/{weeknights.Id}",
                new UpdateCollectionRequest("Hijacked", null))).StatusCode);
        Assert.Equal(
            HttpStatusCode.NotFound,
            (await otherApi.DeleteAsync($"/collections/{weeknights.Id}")).StatusCode);

        var first = await RecipeTestData.CreateAsync(api, RecipeTestData.Write("First recipe"));
        var second = await RecipeTestData.CreateAsync(api, RecipeTestData.Write("Second recipe"));

        var addFirst = await api.PutAsync(
            $"/collections/{weeknights.Id}/recipes/{first.Id}",
            content: null);
        Assert.Equal(HttpStatusCode.NoContent, addFirst.StatusCode);

        var addSecond = await api.PutAsync(
            $"/collections/{weeknights.Id}/recipes/{second.Id}",
            content: null);
        Assert.Equal(HttpStatusCode.NoContent, addSecond.StatusCode);

        var addFirstAgain = await api.PutAsync(
            $"/collections/{weeknights.Id}/recipes/{first.Id}",
            content: null);
        Assert.Equal(HttpStatusCode.NoContent, addFirstAgain.StatusCode);

        var detail = await api.GetFromJsonAsync<CollectionDetailDto>(
            $"/collections/{weeknights.Id}");
        Assert.NotNull(detail);
        Assert.Equal([first.Id, second.Id], detail.Recipes.Items.Select(item => item.Id));

        var reorderResponse = await api.PutAsJsonAsync(
            $"/collections/{weeknights.Id}/order",
            new ReorderCollectionRequest([second.Id, first.Id]));
        Assert.Equal(HttpStatusCode.NoContent, reorderResponse.StatusCode);

        detail = await api.GetFromJsonAsync<CollectionDetailDto>($"/collections/{weeknights.Id}");
        Assert.NotNull(detail);
        Assert.Equal([second.Id, first.Id], detail.Recipes.Items.Select(item => item.Id));

        var invalidOrder = await api.PutAsJsonAsync(
            $"/collections/{weeknights.Id}/order",
            new ReorderCollectionRequest([second.Id]));
        Assert.Equal(HttpStatusCode.BadRequest, invalidOrder.StatusCode);
        Assert.Equal(
            "collection.reorder-mismatch",
            await RecipeTestData.ProblemCodeAsync(invalidOrder));

        var removeSecond = await api.DeleteAsync(
            $"/collections/{weeknights.Id}/recipes/{second.Id}");
        Assert.Equal(HttpStatusCode.NoContent, removeSecond.StatusCode);

        detail = await api.GetFromJsonAsync<CollectionDetailDto>($"/collections/{weeknights.Id}");
        Assert.NotNull(detail);
        Assert.Single(detail.Recipes.Items);
        Assert.Equal(first.Id, detail.Recipes.Items[0].Id);

        var deleteCollection = await api.DeleteAsync($"/collections/{guests.Id}");
        Assert.Equal(HttpStatusCode.NoContent, deleteCollection.StatusCode);
        Assert.Equal(
            HttpStatusCode.NotFound,
            (await api.GetAsync($"/collections/{guests.Id}")).StatusCode);

        var favorites = Assert.Single(
            (await api.GetFromJsonAsync<PagedResult<CollectionSummaryDto>>("/collections"))!
            .Items,
            item => item.IsDefaultFavorites);

        var renameFavorites = await api.PutAsJsonAsync(
            $"/collections/{favorites.Id}",
            new UpdateCollectionRequest("Nope", null));
        Assert.Equal(HttpStatusCode.Conflict, renameFavorites.StatusCode);
        Assert.Equal(
            "collection.favorites-protected",
            await RecipeTestData.ProblemCodeAsync(renameFavorites));

        var deleteFavorites = await api.DeleteAsync($"/collections/{favorites.Id}");
        Assert.Equal(HttpStatusCode.Conflict, deleteFavorites.StatusCode);
    }

    [Fact]
    public async Task Recipe_and_collection_routes_require_a_bearer_token()
    {
        var client = factory.CreateClient();

        var recipes = await client.GetAsync("/recipes");
        Assert.Equal(HttpStatusCode.Unauthorized, recipes.StatusCode);
        Assert.Equal("auth.required", await RecipeTestData.ProblemCodeAsync(recipes));

        var collections = await client.GetAsync("/collections");
        Assert.Equal(HttpStatusCode.Unauthorized, collections.StatusCode);
        Assert.Equal("auth.required", await RecipeTestData.ProblemCodeAsync(collections));
    }
}
