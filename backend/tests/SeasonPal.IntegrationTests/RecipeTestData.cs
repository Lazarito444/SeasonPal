using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Enums;

namespace SeasonPal.IntegrationTests;

/// <summary>Builders and small assertions shared by recipe and collection endpoint tests.</summary>
internal static class RecipeTestData
{
    public static HttpClient AuthorizedClient(SeasonPalApiFactory factory, string accessToken)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);
        return client;
    }

    public static RecipeWriteRequest Write(
        string title,
        string? cuisine = "Italian",
        int? prepTimeMinutes = 10,
        int? cookTimeMinutes = 20,
        RecipeDifficulty difficulty = RecipeDifficulty.Easy,
        IReadOnlyList<string>? tags = null,
        IReadOnlyList<string>? dietaryTags = null,
        bool includeContent = true,
        MealType mealType = MealType.Dinner,
        int servings = 2)
    {
        return new RecipeWriteRequest(
            title,
            $"{title} description",
            cuisine,
            null,
            tags ?? ["Weeknight"],
            dietaryTags ?? ["Vegetarian"],
            mealType,
            servings,
            prepTimeMinutes,
            cookTimeMinutes,
            difficulty,
            includeContent
                ?
                [
                    new RecipeIngredientInput(2, "tablespoons", "olive oil", null),
                    new RecipeIngredientInput(250, "grams", "orzo", null),
                ]
                : [],
            includeContent
                ?
                [
                    new RecipeStepInput("Warm the oil.", null, null),
                    new RecipeStepInput("Cook the orzo.", "Stir often.", 600),
                ]
                : [],
            []);
    }

    public static async Task<RecipeDetailDto> CreateAsync(
        HttpClient client,
        RecipeWriteRequest request)
    {
        var response = await client.PostAsJsonAsync("/recipes", request);
        if (response.StatusCode != HttpStatusCode.Created)
        {
            var body = await response.Content.ReadAsStringAsync();
            throw new InvalidOperationException(
                $"Recipe creation failed with {(int)response.StatusCode}: {body}");
        }

        return (await response.Content.ReadFromJsonAsync<RecipeDetailDto>())!;
    }

    public static async Task PublishAsync(HttpClient client, Guid recipeId)
    {
        var response = await client.PostAsync($"/recipes/{recipeId}/publish", content: null);
        response.EnsureSuccessStatusCode();
    }

    public static async Task<string?> ProblemCodeAsync(HttpResponseMessage response)
    {
        using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
        return document.RootElement.TryGetProperty("code", out var code)
            ? code.GetString()
            : null;
    }
}
