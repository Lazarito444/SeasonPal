using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SeasonPal.Api.Common;
using SeasonPal.Application.Common;
using SeasonPal.Application.Discovery;
using SeasonPal.Application.Preferences;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Api.Endpoints;

/// <summary>
/// Public discovery: a filtered feed, the home rails, and pantry matching. Every read is limited
/// to public published recipes; personalization only changes ordering, never visibility.
/// </summary>
public static class DiscoveryEndpoints
{
    private const int HomeRailSize = 10;

    extension(IEndpointRouteBuilder app)
    {
        public void MapDiscoveryEndpoints()
        {
            var group = app
                .MapGroup("/discovery")
                .WithTags("Discovery")
                .RequireAuthorization();

            group.MapGet("/feed", FeedAsync)
                .WithSummary("Paginated public feed with text search and combinable filters.")
                .Produces<PagedResult<RecipeSummaryDto>>()
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapGet("/home", HomeAsync)
                .WithSummary("Trending, newest and taste-matched recipe rails for the home screen.")
                .Produces<DiscoveryHomeDto>()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapGet("/pantry", PantryAsync)
                .WithSummary("Public recipes ranked by how many of the supplied ingredients they use.")
                .Produces<PagedResult<PantryMatchDto>>()
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized);
        }
    }

    /// <summary>Optional feed filters; every supplied field narrows the same public feed.</summary>
    public sealed class DiscoveryFeedQuery
    {
        public string? Q { get; set; }

        public string? Cuisine { get; set; }

        public string? Diet { get; set; }

        public MealType? MealType { get; set; }

        public RecipeDifficulty? Difficulty { get; set; }

        public int? MaxTotalTimeMinutes { get; set; }

        public int? Page { get; set; }

        public int? PageSize { get; set; }
    }

    private static async Task<IResult> FeedAsync(
        [AsParameters] DiscoveryFeedQuery query,
        ISpecificationExecutor executor,
        CancellationToken cancellationToken)
    {
        if (query.MaxTotalTimeMinutes is < 0)
        {
            return Results.ValidationProblem(
                new Dictionary<string, string[]>
                {
                    ["maxTotalTimeMinutes"] = ["Total time cannot be negative."],
                });
        }

        var search = string.IsNullOrWhiteSpace(query.Q) ? null : query.Q.Trim();
        if (search is { Length: > DiscoveryFeedFilter.MaxSearchLength })
        {
            return Results.ValidationProblem(
                new Dictionary<string, string[]>
                {
                    ["q"] =
                    [
                        $"Search is limited to {DiscoveryFeedFilter.MaxSearchLength} characters.",
                    ],
                });
        }

        var (page, pageSize) = Pagination.Normalize(query.Page, query.PageSize);
        var specification = new DiscoveryFeedSpecification(
            new DiscoveryFeedFilter(
                search,
                query.Cuisine,
                query.Diet,
                query.MealType,
                query.Difficulty,
                query.MaxTotalTimeMinutes),
            page,
            pageSize);

        var result = await executor.ToPagedListAsync(specification, cancellationToken);
        return Results.Ok(result);
    }

    private static async Task<IResult> HomeAsync(
        HttpContext httpContext,
        IDiscoveryRepository discovery,
        IUserPreferenceRepository preferences,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var preference = await preferences.FindAsync(userId.Value, cancellationToken);
        var taste = preference is null
            ? DiscoveryTasteProfile.Empty
            : new DiscoveryTasteProfile(
                preference.FavoriteCuisines,
                preference.DietaryRestrictions);

        // Sequential: a DbContext is the unit of work and is not safe for parallel queries.
        var trending = await discovery.ListTrendingAsync(taste, HomeRailSize, cancellationToken);
        var newest = await discovery.ListNewestAsync(HomeRailSize, cancellationToken);
        var recommended = await discovery.ListRecommendedAsync(
            userId.Value,
            taste,
            HomeRailSize,
            cancellationToken);

        return Results.Ok(new DiscoveryHomeDto(
            trending,
            newest,
            recommended,
            taste.HasSignals));
    }

    private static async Task<IResult> PantryAsync(
        [FromQuery] string[]? ingredients,
        [FromQuery] int? page,
        [FromQuery] int? pageSize,
        IDiscoveryRepository discovery,
        CancellationToken cancellationToken)
    {
        var normalized = PantryIngredients.Normalize(ingredients);
        if (!normalized.IsSuccess)
        {
            return normalized.Error!.ToProblem();
        }

        var (normalizedPage, normalizedSize) = Pagination.Normalize(page, pageSize);
        var matches = await discovery.MatchPantryAsync(
            normalized.Value,
            normalizedPage,
            normalizedSize,
            cancellationToken);

        return Results.Ok(matches);
    }
}
