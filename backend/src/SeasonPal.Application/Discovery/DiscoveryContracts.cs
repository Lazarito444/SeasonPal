using SeasonPal.Application.Common;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Application.Discovery;

/// <summary>
/// The viewer's taste signals used by the v0 discovery heuristics. Kept as a value object so
/// Infrastructure can score without loading preferences itself.
/// </summary>
public sealed record DiscoveryTasteProfile(
    IReadOnlyList<string> Cuisines,
    IReadOnlyList<string> DietaryRestrictions)
{
    public static DiscoveryTasteProfile Empty { get; } = new([], []);

    public bool HasSignals => Cuisines.Count > 0 || DietaryRestrictions.Count > 0;
}

/// <summary>Optional filters for the public discovery feed; every field is combinable.</summary>
public sealed record DiscoveryFeedFilter(
    string? Search,
    string? Cuisine,
    string? Diet,
    MealType? MealType,
    RecipeDifficulty? Difficulty,
    int? MaxTotalTimeMinutes)
{
    public const int MaxSearchLength = 100;
}

/// <summary>Home rails: what is moving, what is fresh, and what fits this cook's taste.</summary>
public sealed record DiscoveryHomeDto(
    IReadOnlyList<RecipeSummaryDto> Trending,
    IReadOnlyList<RecipeSummaryDto> Newest,
    IReadOnlyList<RecipeSummaryDto> Recommended,
    bool HasTasteProfile);

/// <summary>
/// A public recipe scored against the ingredients the cook already has. Missing counts ignore
/// pantry staples, so salt and oil never make a complete dish look incomplete.
/// </summary>
public sealed record PantryMatchDto(
    RecipeSummaryDto Recipe,
    int MatchedCount,
    int MissingCount,
    IReadOnlyList<string> MatchedIngredients,
    IReadOnlyList<string> MissingIngredients,
    int MatchPercent,
    bool CanCook);

/// <summary>Read side of discovery. Joins recipes, saves and preferences; no aggregate state.</summary>
public interface IDiscoveryRepository
{
    Task<IReadOnlyList<RecipeSummaryDto>> ListTrendingAsync(
        DiscoveryTasteProfile taste,
        int limit,
        CancellationToken cancellationToken = default);

    Task<IReadOnlyList<RecipeSummaryDto>> ListNewestAsync(
        int limit,
        CancellationToken cancellationToken = default);

    Task<IReadOnlyList<RecipeSummaryDto>> ListRecommendedAsync(
        Guid userId,
        DiscoveryTasteProfile taste,
        int limit,
        CancellationToken cancellationToken = default);

    Task<PagedResult<PantryMatchDto>> MatchPantryAsync(
        IReadOnlyList<string> ingredients,
        int page,
        int pageSize,
        CancellationToken cancellationToken = default);
}
