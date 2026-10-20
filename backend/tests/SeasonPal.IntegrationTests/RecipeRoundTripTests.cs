using Microsoft.EntityFrameworkCore;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;
using SeasonPal.Infrastructure.Persistence;

namespace SeasonPal.IntegrationTests;

/// <summary>Stage 1 acceptance: a recipe with ingredients and steps survives a full round-trip.</summary>
[Collection("SeasonPalApi")]
public class RecipeRoundTripTests(SeasonPalApiFactory factory)
{
    [Fact]
    public async Task Sequence_integrity_and_scalar_fields_survive_full_round_trip()
    {
        var authorId = Guid.NewGuid();
        var recipeId = Guid.NewGuid();
        var createdAt = DateTimeOffset.UtcNow.AddSeconds(-1);

        var recipe = new Recipe
        {
            Id = recipeId,
            AuthorId = authorId,
            Title = "One-pan lemon orzo",
            Description = "Weeknight dinner in a single skillet.",
            Cuisine = "Italian",
            MealType = MealType.Dinner,
            Servings = 4,
            PrepTimeMinutes = 10,
            CookTimeMinutes = 20,
            Difficulty = RecipeDifficulty.Medium,
            Visibility = RecipeVisibility.Public,
            Status = RecipeStatus.Draft,
            IsAiGenerated = false,
            CreatedAt = createdAt,
            Ingredients =
            [
                new() { Order = 1, Quantity = 2, Unit = "tbsp", Name = "olive oil" },
                new() { Order = 2, Quantity = 250, Unit = "g", Name = "orzo" },
                new() { Order = 3, Quantity = null, Unit = null, Name = "salt and pepper", Note = "to taste" },
            ],
            Steps =
            [
                new() { Order = 1, Instruction = "Heat oil in a wide pan." },
                new() { Order = 2, Instruction = "Toast the orzo in the oil.", Tip = "Keep it moving so it does not brown.", TimerSeconds = 180 },
                new() { Order = 3, Instruction = "Add water 1:1.5 and simmer.", TimerSeconds = 700 },
                new() { Order = 4, Instruction = "Finish with lemon zest and juice." },
            ],
        };

        await using (var arrange = CreateContext())
        {
            arrange.Users.Add(new ApplicationUser
            {
                Id = authorId,
                UserName = authorId.ToString(),
                Email = $"{authorId}@test.seasonpal.app",
                DisplayName = "Round-trip Author",
            });
            arrange.Recipes.Add(recipe);
            await arrange.SaveChangesAsync();
        }

        await using (var act = CreateContext())
        {
            var loaded = await act.Recipes
                .AsNoTracking()
                .Include(r => r.Ingredients)
                .Include(r => r.Steps)
                .SingleAsync(r => r.Id == recipeId);

            Assert.Equal("One-pan lemon orzo", loaded.Title);
            Assert.Equal("Italian", loaded.Cuisine);
            Assert.Equal(MealType.Dinner, loaded.MealType);
            Assert.Equal(RecipeDifficulty.Medium, loaded.Difficulty);
            Assert.Equal(RecipeVisibility.Public, loaded.Visibility);
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
