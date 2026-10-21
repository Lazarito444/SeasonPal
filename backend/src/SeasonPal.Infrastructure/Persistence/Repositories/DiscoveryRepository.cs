using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using SeasonPal.Application.Common;
using SeasonPal.Application.Discovery;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Infrastructure.Persistence.Repositories;

/// <summary>
/// Read model for discovery. It joins recipes, saves and taste signals without owning any
/// aggregate state, and keeps every query bounded so a feed rail never scans the whole table.
/// </summary>
public sealed class DiscoveryRepository(SeasonPalDbContext context) : IDiscoveryRepository
{
    /// <summary>Candidate pool for in-memory taste and pantry scoring; Stage 9 replaces this.</summary>
    private const int CandidateCap = 200;

    private const int TrendingSaveCap = 100;

    private static readonly string[] Staples =
    [
        "salt",
        "pepper",
        "black pepper",
        "water",
        "oil",
        "olive oil",
        "vegetable oil",
        "canola oil",
    ];

    public Task<IReadOnlyList<RecipeSummaryDto>> ListNewestAsync(
        int limit,
        CancellationToken cancellationToken = default) =>
        ListNewestCoreAsync(limit, cancellationToken);

    private async Task<IReadOnlyList<RecipeSummaryDto>> ListNewestCoreAsync(
        int limit,
        CancellationToken cancellationToken) =>
        await context.Recipes
            .AsNoTracking()
            .Where(recipe => recipe.Visibility == RecipeVisibility.Public
                && recipe.Status == RecipeStatus.Published)
            .OrderByDescending(recipe => recipe.CreatedAt)
            .ThenByDescending(recipe => recipe.Id)
            .Take(limit)
            .Select(RecipeSummaryProjection.Expression)
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<RecipeSummaryDto>> ListTrendingAsync(
        DiscoveryTasteProfile taste,
        int limit,
        CancellationToken cancellationToken = default)
    {
        var now = DateTimeOffset.UtcNow;
        var since30Days = now.AddDays(-30);
        var since7Days = now.AddDays(-7);

        // Saves by the author do not signal community interest, so they are excluded.
        var saveStats = await context.SavedRecipes
            .AsNoTracking()
            .Where(saved => saved.SavedAt >= since30Days && saved.UserId != saved.Recipe.AuthorId)
            .GroupBy(saved => saved.RecipeId)
            .Select(group => new { RecipeId = group.Key, Count = group.Count() })
            .OrderByDescending(row => row.Count)
            .Take(TrendingSaveCap)
            .ToListAsync(cancellationToken);

        var ids = saveStats.Select(row => row.RecipeId).ToList();
        if (ids.Count == 0)
        {
            return await ListNewestCoreAsync(limit, cancellationToken);
        }

        var recentStats = await context.SavedRecipes
            .AsNoTracking()
            .Where(saved => saved.SavedAt >= since7Days && ids.Contains(saved.RecipeId)
                && saved.UserId != saved.Recipe.AuthorId)
            .GroupBy(saved => saved.RecipeId)
            .Select(group => new { RecipeId = group.Key, Count = group.Count() })
            .ToListAsync(cancellationToken);

        var recipes = await context.Recipes
            .AsNoTracking()
            .Where(recipe => ids.Contains(recipe.Id)
                && recipe.Visibility == RecipeVisibility.Public
                && recipe.Status == RecipeStatus.Published)
            .Select(RecipeSummaryProjection.Expression)
            .ToListAsync(cancellationToken);

        var countById = saveStats.ToDictionary(row => row.RecipeId, row => row.Count);
        var recentById = recentStats.ToDictionary(row => row.RecipeId, row => row.Count);
        var cuisines = taste.Cuisines.ToHashSet(StringComparer.OrdinalIgnoreCase);

        var ranked = recipes
            .Select(recipe => new
            {
                Recipe = recipe,
                Score = countById.GetValueOrDefault(recipe.Id) * 3
                    + recentById.GetValueOrDefault(recipe.Id) * 2
                    + (recipe.Cuisine != null && cuisines.Contains(recipe.Cuisine) ? 2 : 0),
            })
            .OrderByDescending(row => row.Score)
            .ThenByDescending(row => row.Recipe.UpdatedAt)
            .Take(limit)
            .Select(row => row.Recipe)
            .ToList();

        if (ranked.Count >= limit)
        {
            return ranked;
        }

        // A young feed has more slots than saved dishes; fill them with the newest public rows.
        var known = ranked.Select(recipe => recipe.Id).ToHashSet();
        var newest = await ListNewestCoreAsync(limit, cancellationToken);
        ranked.AddRange(newest.Where(recipe => !known.Contains(recipe.Id)).Take(limit - ranked.Count));
        return ranked;
    }

    public async Task<IReadOnlyList<RecipeSummaryDto>> ListRecommendedAsync(
        Guid userId,
        DiscoveryTasteProfile taste,
        int limit,
        CancellationToken cancellationToken = default)
    {
        // v0 has no fallback rail: without taste signals the home screen shows only
        // trending and newest, rather than mislabeling newest recipes as personal.
        if (!taste.HasSignals)
        {
            return [];
        }

        var candidates = await context.Recipes
            .AsNoTracking()
            .Where(recipe => recipe.Visibility == RecipeVisibility.Public
                && recipe.Status == RecipeStatus.Published
                && recipe.AuthorId != userId)
            .Where(recipe => !context.SavedRecipes.Any(saved =>
                saved.UserId == userId && saved.RecipeId == recipe.Id))
            .OrderByDescending(recipe => recipe.CreatedAt)
            .Take(CandidateCap)
            .Select(RecipeSummaryProjection.Expression)
            .ToListAsync(cancellationToken);

        return candidates
            .Select(recipe => new { Recipe = recipe, Score = TasteScore(recipe, taste) })
            .Where(row => row.Score > 0)
            .OrderByDescending(row => row.Score)
            .ThenByDescending(row => row.Recipe.UpdatedAt)
            .Take(limit)
            .Select(row => row.Recipe)
            .ToList();
    }

    public async Task<PagedResult<PantryMatchDto>> MatchPantryAsync(
        IReadOnlyList<string> ingredients,
        int page,
        int pageSize,
        CancellationToken cancellationToken = default)
    {
        if (ingredients.Count == 0)
        {
            return new PagedResult<PantryMatchDto>([], page, pageSize, 0);
        }

        Expression<Func<Recipe, bool>>? matchesAnyIngredient = null;
        foreach (var ingredient in ingredients)
        {
            var needle = ingredient.ToLowerInvariant();
            Expression<Func<Recipe, bool>> clause =
                recipe => recipe.Ingredients.Any(line => line.Name.ToLower().Contains(needle));
            matchesAnyIngredient = matchesAnyIngredient is null
                ? clause
                : matchesAnyIngredient.OrElse(clause);
        }

        var candidates = await context.Recipes
            .AsNoTracking()
            .Where(recipe => recipe.Visibility == RecipeVisibility.Public
                && recipe.Status == RecipeStatus.Published)
            .Where(matchesAnyIngredient!)
            .Include(recipe => recipe.Author)
            .Include(recipe => recipe.Ingredients)
            .AsSplitQuery()
            .OrderByDescending(recipe => recipe.CreatedAt)
            .Take(CandidateCap)
            .ToListAsync(cancellationToken);

        var matches = new List<PantryMatchDto>(candidates.Count);
        foreach (var recipe in candidates)
        {
            var ingredientNames = recipe.Ingredients
                .Select(line => line.Name.Trim())
                .Where(name => name.Length > 0)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            var matched = ingredientNames
                .Where(name => ingredients.Any(term =>
                    name.Contains(term, StringComparison.OrdinalIgnoreCase)))
                .ToList();

            if (matched.Count == 0)
            {
                continue;
            }

            var missing = ingredientNames
                .Except(matched, StringComparer.OrdinalIgnoreCase)
                .Where(name => !IsStaple(name))
                .ToList();

            var considered = matched.Count + missing.Count;
            var percent = considered == 0
                ? 0
                : (int)Math.Round(
                    matched.Count / (double)considered * 100,
                    MidpointRounding.AwayFromZero);

            matches.Add(new PantryMatchDto(
                RecipeSummaryDto.From(recipe),
                matched.Count,
                missing.Count,
                matched,
                missing,
                percent,
                missing.Count == 0));
        }

        var ranked = matches
            .OrderByDescending(match => match.MatchPercent)
            .ThenByDescending(match => match.MatchedCount)
            .ThenBy(match => match.MissingCount)
            .ThenByDescending(match => match.Recipe.UpdatedAt)
            .ToList();

        var items = ranked
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToList();

        return new PagedResult<PantryMatchDto>(items, page, pageSize, ranked.Count);
    }

    private static int TasteScore(RecipeSummaryDto recipe, DiscoveryTasteProfile taste)
    {
        var score = 0;

        if (recipe.Cuisine != null
            && taste.Cuisines.Any(cuisine =>
                string.Equals(cuisine, recipe.Cuisine, StringComparison.OrdinalIgnoreCase)))
        {
            score += 3;
        }

        score += recipe.DietaryTags.Count(tag => taste.DietaryRestrictions.Any(diet =>
            string.Equals(diet, tag, StringComparison.OrdinalIgnoreCase))) * 2;

        return score;
    }

    private static bool IsStaple(string name)
    {
        var normalized = name.Trim().ToLowerInvariant();

        return Staples.Contains(normalized, StringComparer.Ordinal)
            || normalized.EndsWith(" salt", StringComparison.Ordinal)
            || normalized.EndsWith(" pepper", StringComparison.Ordinal)
            || normalized.EndsWith(" oil", StringComparison.Ordinal);
    }
}
