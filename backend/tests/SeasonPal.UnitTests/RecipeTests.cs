using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.UnitTests;

/// <summary>Create-factory and guarded-transition behavior of the Recipe aggregate root.</summary>
public class RecipeTests
{
    private static readonly Guid AuthorId = Guid.NewGuid();

    [Fact]
    public void Create_returns_a_private_draft_with_sane_defaults()
    {
        var result = Recipe.Create(AuthorId, "Lemon orzo");

        Assert.True(result.IsSuccess);
        var recipe = result.Value;
        Assert.Equal(AuthorId, recipe.AuthorId);
        Assert.Equal("Lemon orzo", recipe.Title);
        Assert.Equal(RecipeVisibility.Private, recipe.Visibility);
        Assert.Equal(RecipeStatus.Draft, recipe.Status);
        Assert.Equal(2, recipe.Servings);
        Assert.False(recipe.IsAiGenerated);
        Assert.Null(recipe.SourceRecipeId);
        Assert.Empty(recipe.Ingredients);
        Assert.Empty(recipe.Steps);
        Assert.True(DateTimeOffset.UtcNow - recipe.CreatedAt < TimeSpan.FromSeconds(5));
    }

    [Fact]
    public void Create_normalizes_whitespace_in_the_title()
    {
        var result = Recipe.Create(AuthorId, "  Lemon orzo  ");

        Assert.True(result.IsSuccess);
        Assert.Equal("Lemon orzo", result.Value.Title);
    }

    [Fact]
    public void Create_rejects_a_missing_owner()
    {
        var result = Recipe.Create(Guid.Empty, "Lemon orzo");

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.owner-required", result.Error!.Code);
    }

    [Fact]
    public void Create_rejects_blank_titles()
    {
        var result = Recipe.Create(AuthorId, "   ");

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.title-size-invalid", result.Error!.Code);
    }

    [Fact]
    public void Create_rejects_titles_over_200_characters()
    {
        var result = Recipe.Create(AuthorId, new string('x', 201));

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.title-size-invalid", result.Error!.Code);
        Assert.Equal("200", result.Error.Args["max"]);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-3)]
    [InlineData(51)]
    public void Create_rejects_servings_out_of_range(int servings)
    {
        var result = Recipe.Create(AuthorId, "Lemon orzo", servings: servings);

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.serves-out-of-range", result.Error!.Code);
    }

    [Theory]
    [InlineData(1441)]
    [InlineData(-1)]
    public void Create_rejects_prep_time_out_of_range(int prepTimeMinutes)
    {
        var result = Recipe.Create(AuthorId, "Lemon orzo", prepTimeMinutes: prepTimeMinutes);

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.time-out-of-range", result.Error!.Code);
    }

    [Fact]
    public void AddIngredient_appends_contiguous_orders()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var first = recipe.AddIngredient(2, "tbsp", " olive oil ");
        var second = recipe.AddIngredient(250, "g", "orzo");

        Assert.True(first.IsSuccess);
        Assert.True(second.IsSuccess);
        Assert.Equal(2, recipe.Ingredients.Count);
        Assert.Equal(1, recipe.Ingredients[0].Order);
        Assert.Equal(2, recipe.Ingredients[1].Order);
        Assert.Equal("olive oil", recipe.Ingredients[0].Name);
    }

    [Fact]
    public void AddIngredient_rejects_a_blank_name_without_mutating()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var result = recipe.AddIngredient(1, "tsp", "   ");

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.ingredient-name-invalid", result.Error!.Code);
        Assert.Empty(recipe.Ingredients);
    }

    [Fact]
    public void AddIngredient_rejects_negative_quantities()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var result = recipe.AddIngredient(-1, "tsp", "salt");

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.ingredient-quantity-invalid", result.Error!.Code);
    }

    [Fact]
    public void AddStep_appends_steps_and_keeps_the_tip()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var result = recipe.AddStep("Toast the orzo.", "Keep it moving.", 180);

        Assert.True(result.IsSuccess);
        Assert.Single(recipe.Steps);
        Assert.Equal(1, recipe.Steps[0].Order);
        Assert.Equal("Keep it moving.", recipe.Steps[0].Tip);
        Assert.Equal(180, recipe.Steps[0].TimerSeconds);
    }

    [Fact]
    public void AddStep_rejects_blank_instructions()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var result = recipe.AddStep("");

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.step-instruction-invalid", result.Error!.Code);
    }

    [Fact]
    public void AddStep_rejects_out_of_range_timers()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var result = recipe.AddStep("Simmer.", timerSeconds: 0);

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.step-timer-out-of-range", result.Error!.Code);
    }

    [Fact]
    public void UpdateDetails_replaces_scalars_and_deduplicates_labels()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var result = recipe.UpdateDetails(
            new RecipeDetails(
                "  One-pan lemon orzo  ",
                "  Bright and quick.  ",
                "  Italian  ",
                "https://cdn.seasonpal.test/orzo.jpg",
                ["Weeknight", "weeknight", "Quick"],
                ["Vegetarian", "Gluten-free"],
                MealType.Dinner,
                4,
                10,
                20,
                RecipeDifficulty.Medium));

        Assert.True(result.IsSuccess);
        Assert.Equal("One-pan lemon orzo", recipe.Title);
        Assert.Equal("Bright and quick.", recipe.Description);
        Assert.Equal("Italian", recipe.Cuisine);
        Assert.Equal("https://cdn.seasonpal.test/orzo.jpg", recipe.CoverImageUrl);
        Assert.Equal(["Weeknight", "Quick"], recipe.Tags);
        Assert.Equal(["Vegetarian", "Gluten-free"], recipe.DietaryTags);
        Assert.Equal(MealType.Dinner, recipe.MealType);
        Assert.Equal(4, recipe.Servings);
        Assert.Equal(30, recipe.TotalTimeMinutes);
        Assert.Equal(RecipeDifficulty.Medium, recipe.Difficulty);
    }

    [Fact]
    public void UpdateDetails_rejects_too_many_tags_without_mutating()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;
        var tags = Enumerable.Range(1, Recipe.MaxTags + 1).Select(i => $"tag-{i}").ToList();

        var result = recipe.UpdateDetails(
            new RecipeDetails(
                "Renamed",
                null,
                null,
                null,
                tags,
                null,
                MealType.Unspecified,
                2,
                null,
                null,
                RecipeDifficulty.Easy));

        Assert.False(result.IsSuccess);
        Assert.Equal("recipe.tags-too-many", result.Error!.Code);
        Assert.Equal("Lemon orzo", recipe.Title);
        Assert.Empty(recipe.Tags);
    }

    [Fact]
    public void ReplaceIngredients_is_atomic_and_normalizes_units()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;
        recipe.AddIngredient(1, "tsp", "salt");

        var invalid = recipe.ReplaceIngredients(
            [
                new IngredientDraft(2, "Tablespoons", "olive oil", null),
                new IngredientDraft(1, "g", "  ", null),
            ]);

        Assert.False(invalid.IsSuccess);
        Assert.Equal("recipe.ingredient-name-invalid", invalid.Error!.Code);
        Assert.Single(recipe.Ingredients);
        Assert.Equal("salt", recipe.Ingredients[0].Name);

        var valid = recipe.ReplaceIngredients(
            [
                new IngredientDraft(2, "Tablespoons", "olive oil", " extra virgin "),
                new IngredientDraft(250, "Grams", "orzo", null),
            ]);

        Assert.True(valid.IsSuccess);
        Assert.Equal(2, recipe.Ingredients.Count);
        Assert.Equal(1, recipe.Ingredients[0].Order);
        Assert.Equal("tbsp", recipe.Ingredients[0].Unit);
        Assert.Equal("extra virgin", recipe.Ingredients[0].Note);
        Assert.Equal("g", recipe.Ingredients[1].Unit);
        Assert.Equal(2, recipe.Ingredients[1].Order);
    }

    [Fact]
    public void ReplaceSteps_and_media_assign_orders_and_keep_alt_text()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var steps = recipe.ReplaceSteps(
            [
                new StepDraft("Boil the orzo.", "Salt the water.", 600),
                new StepDraft("Toss with lemon.", null, null),
            ]);

        var media = recipe.ReplaceMedia(
            [
                new MediaDraft("https://cdn.seasonpal.test/orzo.jpg", MediaKind.Image, "Lemon orzo in a bowl"),
            ]);

        Assert.True(steps.IsSuccess);
        Assert.True(media.IsSuccess);
        Assert.Equal([1, 2], recipe.Steps.Select(step => step.Order));
        Assert.Single(recipe.Media);
        Assert.Equal("Lemon orzo in a bowl", recipe.Media[0].AltText);
        Assert.Equal(1, recipe.Media[0].Order);
    }

    [Fact]
    public void Publish_requires_content_and_toggles_publication_as_a_pair()
    {
        var recipe = Recipe.Create(AuthorId, "Lemon orzo").Value;

        var empty = recipe.Publish();
        Assert.False(empty.IsSuccess);
        Assert.Equal("recipe.publish-incomplete", empty.Error!.Code);

        recipe.AddIngredient(250, "g", "orzo");
        recipe.AddStep("Boil the orzo.");

        var published = recipe.Publish();
        Assert.True(published.IsSuccess);
        Assert.Equal(RecipeVisibility.Public, recipe.Visibility);
        Assert.Equal(RecipeStatus.Published, recipe.Status);

        recipe.Unpublish();
        Assert.Equal(RecipeVisibility.Private, recipe.Visibility);
        Assert.Equal(RecipeStatus.Draft, recipe.Status);
    }
}
