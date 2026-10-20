using Microsoft.EntityFrameworkCore;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;
using SeasonPal.Infrastructure.Persistence;

namespace SeasonPal.IntegrationTests;

/// <summary>Stage 1 acceptance: a recipe built through the aggregate's factory and Add methods survives a full round-trip.</summary>
[Collection("SeasonPalApi")]
public class RecipeRoundTripTests(SeasonPalApiFactory factory)
{
    [Fact]
    public async Task Sequence_integrity_and_scalar_fields_survive_full_round_trip()
    {
        var authorId = Guid.NewGuid();

        await using (var arrange = CreateContext())
        {
            arrange.Users.Add(new ApplicationUser
            {
                Id = authorId,
                UserName = authorId.ToString(),
                Email = $"{authorId}@test.seasonpal.app",
                DisplayName = "Round-trip Author",
            });

            var creation = Recipe.Create(
                authorId,
                "One-pan lemon orzo",
                description: "Weeknight dinner in a single skillet.",
                cuisine: "Italian",
                mealType: MealType.Dinner,
                servings: 4,
                prepTimeMinutes: 10,
                cookTimeMinutes: 20,
                difficulty: RecipeDifficulty.Medium);
            Assert.True(creation.IsSuccess, creation.Error?.FallbackMessage);

            var recipe = creation.Value;
            Assert.True(recipe.AddIngredient(2, "tbsp", " olive oil ").IsSuccess);
            Assert.True(recipe.AddIngredient(250, "g", "orzo").IsSuccess);
            Assert.True(recipe.AddIngredient(null, null, "salt and pepper", "to taste").IsSuccess);
            Assert.True(recipe.AddStep("Heat oil in a wide pan.").IsSuccess);
            Assert.True(recipe.AddStep("Toast the orzo in the oil.", "Keep it moving so it does not brown.", 180).IsSuccess);
            Assert.True(recipe.AddStep("Add water 1:1.5 and simmer.", null, 700).IsSuccess);
            Assert.True(recipe.AddStep("Finish with lemon zest and juice.").IsSuccess);

            arrange.Recipes.Add(recipe);
            await arrange.SaveChangesAsync();
            Guid recipeId = recipe.Id;
            Assert.NotEqual(Guid.Empty, recipeId);

            await using var act = CreateContext();
            var loaded = await act.Recipes
                .AsNoTracking()
                .Include(r => r.Ingredients)
                .Include(r => r.Steps)
                .SingleAsync(r => r.Id == recipeId);

            Assert.Equal("One-pan lemon orzo", loaded.Title);
            Assert.Equal("Italian", loaded.Cuisine);
            Assert.Equal(MealType.Dinner, loaded.MealType);
            Assert.Equal(RecipeDifficulty.Medium, loaded.Difficulty);
            Assert.Equal(RecipeVisibility.Private, loaded.Visibility);
            Assert.Equal(RecipeStatus.Draft, loaded.Status);
            Assert.False(loaded.IsAiGenerated);
            Assert.Null(loaded.SourceRecipeId);

            var ingredients = loaded.Ingredients.OrderBy(i => i.Order).ToList();
            Assert.Equal(3, ingredients.Count);
            Assert.Equal(250, ingredients[1].Quantity);
            Assert.Equal("g", ingredients[1].Unit);
            Assert.Null(ingredients[2].Quantity);
            Assert.Equal("to taste", ingredients[2].Note);

            var steps = loaded.Steps.OrderBy(s => s.Order).ToList();
            Assert.Equal(4, steps.Count);
            Assert.Equal(180, steps[1].TimerSeconds);
            Assert.Equal("Keep it moving so it does not brown.", steps[1].Tip);
            Assert.Null(steps[0].TimerSeconds);
        }
    }

    private SeasonPalDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<SeasonPalDbContext>()
            .UseNpgsql(factory.DbConnectionString)
            .Options;

        return new SeasonPalDbContext(options);
    }
}
