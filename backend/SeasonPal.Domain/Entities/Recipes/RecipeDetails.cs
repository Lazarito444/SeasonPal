namespace SeasonPal.Domain.Entities.Recipes;

/// <summary>
/// The editable scalar fields of a <see cref="Recipe"/>. Updates take the whole shape so a
/// partial edit can never leave the recipe half-validated.
/// </summary>
/// <param name="Title">The recipe's display title.</param>
/// <param name="Description">A free-form description; null when the author supplied none.</param>
/// <param name="PreparationTimeInMinutes">Time needed to prepare the ingredients; null when unknown.</param>
/// <param name="CookingTimeInMinutes">Time needed to cook the recipe; null when unknown.</param>
/// <param name="Servings">The number of servings the recipe yields.</param>
/// <param name="Difficulty">How demanding the recipe is to prepare.</param>
public sealed record RecipeDetails(
    string Title,
    string? Description,
    int? PreparationTimeInMinutes,
    int? CookingTimeInMinutes,
    int Servings,
    RecipeDifficulty Difficulty);
