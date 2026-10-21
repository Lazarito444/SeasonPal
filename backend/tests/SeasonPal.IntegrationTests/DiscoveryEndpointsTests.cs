using System.Net;
using System.Net.Http.Json;
using SeasonPal.Application.Common;
using SeasonPal.Application.Discovery;
using SeasonPal.Application.Preferences;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Enums;

namespace SeasonPal.IntegrationTests;

/// <summary>
/// Discovery reads span several tables, so these tests isolate themselves with unique cuisine,
/// diet, search and ingredient tokens instead of assuming an empty shared database.
/// </summary>
[Collection("SeasonPalApi")]
public class DiscoveryEndpointsTests(SeasonPalApiFactory factory)
{
    [Fact]
    public async Task Feed_only_shows_published_public_recipes_and_composes_filters()
    {
        var author = await RegisterAsync("Feed Author");
        var authorApi = RecipeTestData.AuthorizedClient(factory, author.AccessToken);
        var token = Guid.NewGuid().ToString("N");
        var cuisine = $"TestCuisine-{token}";
        var diet = $"TestDiet-{token}";

        var quick = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write(
                $"Quick {token}",
                cuisine: cuisine,
                prepTimeMinutes: 5,
                cookTimeMinutes: 10,
                difficulty: RecipeDifficulty.Easy,
                dietaryTags: [diet],
                mealType: MealType.Dinner));
        await RecipeTestData.PublishAsync(authorApi, quick.Id);

        var slow = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write(
                $"Slow {token}",
                cuisine: cuisine,
                prepTimeMinutes: 30,
                cookTimeMinutes: 60,
                difficulty: RecipeDifficulty.Hard,
                dietaryTags: [diet],
                mealType: MealType.Dinner));
        await RecipeTestData.PublishAsync(authorApi, slow.Id);

        var breakfast = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write(
                $"Morning {token}",
                cuisine: cuisine,
                prepTimeMinutes: 5,
                cookTimeMinutes: 5,
                difficulty: RecipeDifficulty.Easy,
                dietaryTags: [diet],
                mealType: MealType.Breakfast));
        await RecipeTestData.PublishAsync(authorApi, breakfast.Id);

        var draft = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write(
                $"Draft {token}",
                cuisine: cuisine,
                dietaryTags: [diet]));

        var viewer = await RegisterAsync("Feed Viewer");
        var viewerApi = RecipeTestData.AuthorizedClient(factory, viewer.AccessToken);

        var all = await viewerApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            $"/discovery/feed?q={token}");
        Assert.NotNull(all);
        Assert.Equal(3, all.TotalCount);
        Assert.DoesNotContain(all.Items, item => item.Id == draft.Id);

        var firstPage = await viewerApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            $"/discovery/feed?q={token}&page=1&pageSize=2");
        Assert.NotNull(firstPage);
        Assert.Equal(2, firstPage.Items.Count);
        Assert.True(firstPage.HasNextPage);

        var composed = await viewerApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            $"/discovery/feed?cuisine={Uri.EscapeDataString(cuisine)}"
            + $"&diet={Uri.EscapeDataString(diet)}"
            + "&mealType=3&difficulty=0&maxTotalTimeMinutes=20");
        Assert.NotNull(composed);
        Assert.Single(composed.Items);
        Assert.Equal(quick.Id, composed.Items[0].Id);

        var tooSlow = await viewerApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            $"/discovery/feed?cuisine={Uri.EscapeDataString(cuisine)}&maxTotalTimeMinutes=10");
        Assert.NotNull(tooSlow);
        Assert.Single(tooSlow.Items);
        Assert.Equal(breakfast.Id, tooSlow.Items[0].Id);

        var breakfasts = await viewerApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            $"/discovery/feed?cuisine={Uri.EscapeDataString(cuisine)}&mealType=1");
        Assert.NotNull(breakfasts);
        Assert.Single(breakfasts.Items);
        Assert.Equal(breakfast.Id, breakfasts.Items[0].Id);
    }

    [Fact]
    public async Task Search_ranks_title_hits_above_description_and_ingredient_hits()
    {
        var author = await RegisterAsync("Search Author");
        var authorApi = RecipeTestData.AuthorizedClient(factory, author.AccessToken);
        var term = $"zest{ Guid.NewGuid():N}";

        var titleHit = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write($"{term} roast chicken"));
        var descriptionHit = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write("Roast chicken") with
            {
                Description = $"Finished with {term}.",
            });
        var ingredientHit = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write("Roast chicken") with
            {
                Ingredients = [new RecipeIngredientInput(1, "whole", $"{term} peel", null)],
            });

        await RecipeTestData.PublishAsync(authorApi, titleHit.Id);
        await RecipeTestData.PublishAsync(authorApi, descriptionHit.Id);
        await RecipeTestData.PublishAsync(authorApi, ingredientHit.Id);

        var viewer = await RegisterAsync("Search Viewer");
        var viewerApi = RecipeTestData.AuthorizedClient(factory, viewer.AccessToken);

        var results = await viewerApi.GetFromJsonAsync<PagedResult<RecipeSummaryDto>>(
            $"/discovery/feed?q={term}");
        Assert.NotNull(results);
        Assert.Equal(
            [titleHit.Id, descriptionHit.Id, ingredientHit.Id],
            results.Items.Select(item => item.Id));
    }

    [Fact]
    public async Task Home_rails_are_public_and_recommendations_follow_the_taste_profile()
    {
        var author = await RegisterAsync("Rail Author");
        var authorApi = RecipeTestData.AuthorizedClient(factory, author.AccessToken);
        var token = Guid.NewGuid().ToString("N");
        var cuisine = $"TasteCuisine-{token}";
        var diet = $"TasteDiet-{token}";

        var both = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write(
                $"Both signals {token}",
                cuisine: cuisine,
                dietaryTags: [diet]));
        var cuisineOnly = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write(
                $"Cuisine only {token}",
                cuisine: cuisine,
                dietaryTags: ["Something else"]));
        var dietOnly = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write(
                $"Diet only {token}",
                cuisine: "French",
                dietaryTags: [diet]));
        var neither = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write(
                $"Neither signal {token}",
                cuisine: "French",
                dietaryTags: ["Something else"]));

        await RecipeTestData.PublishAsync(authorApi, both.Id);
        await RecipeTestData.PublishAsync(authorApi, cuisineOnly.Id);
        await RecipeTestData.PublishAsync(authorApi, dietOnly.Id);
        await RecipeTestData.PublishAsync(authorApi, neither.Id);

        var viewer = await RegisterAsync("Rail Viewer");
        var viewerApi = RecipeTestData.AuthorizedClient(factory, viewer.AccessToken);

        var beforePreferences = await viewerApi.GetFromJsonAsync<DiscoveryHomeDto>("/discovery/home");
        Assert.NotNull(beforePreferences);
        Assert.False(beforePreferences.HasTasteProfile);
        Assert.Empty(beforePreferences.Recommended);

        var preferences = await viewerApi.PutAsJsonAsync(
            "/me/preferences",
            new UpdatePreferencesRequest(
                [cuisine],
                [diet],
                CulinarySkillLevel.Intermediate,
                30,
                [],
                OnboardingCompleted: true));
        preferences.EnsureSuccessStatusCode();

        var home = await viewerApi.GetFromJsonAsync<DiscoveryHomeDto>("/discovery/home");
        Assert.NotNull(home);
        Assert.True(home.HasTasteProfile);

        var recommendedIds = home.Recommended.Select(item => item.Id).ToList();
        Assert.Contains(both.Id, recommendedIds);
        Assert.Contains(cuisineOnly.Id, recommendedIds);
        Assert.Contains(dietOnly.Id, recommendedIds);
        Assert.DoesNotContain(neither.Id, recommendedIds);
        Assert.True(
            recommendedIds.IndexOf(both.Id) < recommendedIds.IndexOf(cuisineOnly.Id));
        Assert.True(
            recommendedIds.IndexOf(cuisineOnly.Id) < recommendedIds.IndexOf(dietOnly.Id));

        Assert.All(home.Trending, item =>
        {
            Assert.Equal(RecipeVisibility.Public, item.Visibility);
            Assert.Equal(RecipeStatus.Published, item.Status);
        });
        Assert.All(home.Newest, item =>
        {
            Assert.Equal(RecipeVisibility.Public, item.Visibility);
            Assert.Equal(RecipeStatus.Published, item.Status);
        });
    }

    [Fact]
    public async Task Trending_prefers_recipes_saved_by_more_people()
    {
        var author = await RegisterAsync("Trending Author");
        var authorApi = RecipeTestData.AuthorizedClient(factory, author.AccessToken);

        var popular = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write($"Popular {Guid.NewGuid():N}"));
        var quieter = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write($"Quieter {Guid.NewGuid():N}"));
        await RecipeTestData.PublishAsync(authorApi, popular.Id);
        await RecipeTestData.PublishAsync(authorApi, quieter.Id);

        foreach (var index in Enumerable.Range(0, 3))
        {
            var saver = await RegisterAsync($"Popular Saver {index}");
            var saverApi = RecipeTestData.AuthorizedClient(factory, saver.AccessToken);
            (await saverApi.PostAsync($"/recipes/{popular.Id}/save", content: null))
                .EnsureSuccessStatusCode();
        }

        var quietSaver = await RegisterAsync("Quiet Saver");
        var quietSaverApi = RecipeTestData.AuthorizedClient(factory, quietSaver.AccessToken);
        (await quietSaverApi.PostAsync($"/recipes/{quieter.Id}/save", content: null))
            .EnsureSuccessStatusCode();

        var viewer = await RegisterAsync("Trending Viewer");
        var viewerApi = RecipeTestData.AuthorizedClient(factory, viewer.AccessToken);

        var home = await viewerApi.GetFromJsonAsync<DiscoveryHomeDto>("/discovery/home");
        Assert.NotNull(home);

        var ids = home.Trending.Select(item => item.Id).ToList();
        Assert.Contains(popular.Id, ids);
        Assert.Contains(quieter.Id, ids);
        Assert.True(ids.IndexOf(popular.Id) < ids.IndexOf(quieter.Id));
    }

    [Fact]
    public async Task Pantry_matching_ranks_recipes_by_coverage_and_ignores_staples()
    {
        var author = await RegisterAsync("Pantry Author");
        var authorApi = RecipeTestData.AuthorizedClient(factory, author.AccessToken);
        var token = Guid.NewGuid().ToString("N");
        var orzo = $"pantry-orzo-{token}";
        var lemon = $"pantry-lemon-{token}";
        var oil = $"pantry-oil-{token}";

        var complete = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write($"Complete {token}") with
            {
                Ingredients =
                [
                    new RecipeIngredientInput(250, "g", orzo, null),
                    new RecipeIngredientInput(1, null, lemon, null),
                    new RecipeIngredientInput(2, "tbsp", oil, null),
                    new RecipeIngredientInput(null, null, "salt", "to taste"),
                ],
            });
        await RecipeTestData.PublishAsync(authorApi, complete.Id);

        var partial = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write($"Partial {token}") with
            {
                Ingredients =
                [
                    new RecipeIngredientInput(250, "g", orzo, null),
                    new RecipeIngredientInput(1, null, lemon, null),
                    new RecipeIngredientInput(100, "g", $"missing-{token}-a", null),
                    new RecipeIngredientInput(100, "g", $"missing-{token}-b", null),
                ],
            });
        await RecipeTestData.PublishAsync(authorApi, partial.Id);

        var privateRecipe = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write($"Private {token}") with
            {
                Ingredients =
                [
                    new RecipeIngredientInput(250, "g", orzo, null),
                    new RecipeIngredientInput(1, null, lemon, null),
                    new RecipeIngredientInput(2, "tbsp", oil, null),
                ],
            });

        var unrelated = await RecipeTestData.CreateAsync(
            authorApi,
            RecipeTestData.Write($"Unrelated {token}") with
            {
                Ingredients = [new RecipeIngredientInput(1, null, $"cabbage-{token}", null)],
            });
        await RecipeTestData.PublishAsync(authorApi, unrelated.Id);

        var viewer = await RegisterAsync("Pantry Viewer");
        var viewerApi = RecipeTestData.AuthorizedClient(factory, viewer.AccessToken);

        var matches = await viewerApi.GetFromJsonAsync<PagedResult<PantryMatchDto>>(
            $"/discovery/pantry?ingredients={orzo},{lemon},{oil}&pageSize=20");
        Assert.NotNull(matches);
        Assert.Equal(2, matches.TotalCount);

        var first = matches.Items[0];
        Assert.Equal(complete.Id, first.Recipe.Id);
        Assert.True(first.CanCook);
        Assert.Equal(3, first.MatchedCount);
        Assert.Equal(0, first.MissingCount);
        Assert.Equal(100, first.MatchPercent);

        var second = matches.Items[1];
        Assert.Equal(partial.Id, second.Recipe.Id);
        Assert.False(second.CanCook);
        Assert.Equal(2, second.MatchedCount);
        Assert.Equal(2, second.MissingCount);
        Assert.Equal(50, second.MatchPercent);

        Assert.DoesNotContain(matches.Items, item => item.Recipe.Id == privateRecipe.Id);
        Assert.DoesNotContain(matches.Items, item => item.Recipe.Id == unrelated.Id);

        var repeated = await viewerApi.GetFromJsonAsync<PagedResult<PantryMatchDto>>(
            $"/discovery/pantry?ingredients={orzo}&ingredients={lemon}");
        Assert.NotNull(repeated);
        Assert.Contains(repeated.Items, item => item.Recipe.Id == complete.Id);
    }

    [Fact]
    public async Task Pantry_requires_at_least_one_ingredient()
    {
        var viewer = await RegisterAsync("Empty Pantry Viewer");
        var viewerApi = RecipeTestData.AuthorizedClient(factory, viewer.AccessToken);

        var empty = await viewerApi.GetAsync("/discovery/pantry?ingredients=");
        Assert.Equal(HttpStatusCode.BadRequest, empty.StatusCode);
        Assert.Equal(
            "discovery.pantry-empty",
            await RecipeTestData.ProblemCodeAsync(empty));
    }

    [Fact]
    public async Task Discovery_routes_require_a_bearer_token()
    {
        var client = factory.CreateClient();

        foreach (var path in new[] { "/discovery/feed", "/discovery/home", "/discovery/pantry?ingredients=orzo" })
        {
            var response = await client.GetAsync(path);
            Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
            Assert.Equal("auth.required", await RecipeTestData.ProblemCodeAsync(response));
        }
    }

    private async Task<SeasonPal.Application.Auth.AuthSessionDto> RegisterAsync(string name) =>
        await AuthTestData.RegisterAsync(factory.CreateClient(), AuthTestData.UniqueEmail(), name);
}
