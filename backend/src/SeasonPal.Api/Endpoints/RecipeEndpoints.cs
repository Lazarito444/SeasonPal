using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SeasonPal.Api.Common;
using SeasonPal.Application.Common;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Common;
using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Api.Endpoints;

/// <summary>
/// Personal recipe library: drafts and editing, publication, the saved list, and paginated
/// filtering over the signed-in author's own recipes. Reads of someone else's published recipe
/// are allowed; every mutation is owner-only.
/// </summary>
public static class RecipeEndpoints
{
    extension(IEndpointRouteBuilder app)
    {
        public void MapRecipeEndpoints()
        {
            var group = app
                .MapGroup("/recipes")
                .WithTags("Recipes")
                .RequireAuthorization();

            group.MapGet("", ListOwnAsync)
                .WithSummary("List the signed-in author's recipes, newest edit first.")
                .Produces<PagedResult<RecipeSummaryDto>>()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapGet("/saved", ListSavedAsync)
                .WithSummary("List recipes saved to the signed-in user's library.")
                .Produces<PagedResult<RecipeSummaryDto>>()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapPost("", CreateAsync)
                .AddEndpointFilter<ValidationFilter<RecipeWriteRequest>>()
                .WithSummary("Create a private recipe draft.")
                .Produces<RecipeDetailDto>(StatusCodes.Status201Created)
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapGet("/{id:guid}", GetAsync)
                .WithSummary("Read a recipe owned by the caller or published by someone else.")
                .Produces<RecipeDetailDto>()
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapPut("/{id:guid}", UpdateAsync)
                .AddEndpointFilter<ValidationFilter<RecipeWriteRequest>>()
                .WithSummary("Replace a recipe's editable content; publication is unchanged.")
                .Produces<RecipeDetailDto>()
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapDelete("/{id:guid}", DeleteAsync)
                .WithSummary("Delete one of the caller's recipes.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapPost("/{id:guid}/publish", PublishAsync)
                .WithSummary("Publish a complete recipe to the community feed.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesProblem(StatusCodes.Status400BadRequest)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapPost("/{id:guid}/unpublish", UnpublishAsync)
                .WithSummary("Return a published recipe to a private draft.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapPost("/{id:guid}/save", SaveAsync)
                .WithSummary("Save a recipe to favorites and optionally to one collection.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapDelete("/{id:guid}/save", UnsaveAsync)
                .WithSummary("Remove a recipe from the saved library, favorites and all collections.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesProblem(StatusCodes.Status401Unauthorized);
        }
    }

    /// <summary>Optional filters over the caller's own recipe list.</summary>
    public sealed class RecipeListQuery
    {
        public int? Page { get; set; }

        public int? PageSize { get; set; }

        public string? Cuisine { get; set; }

        public int? MaxTotalTimeMinutes { get; set; }

        public RecipeDifficulty? Difficulty { get; set; }

        public string? Diet { get; set; }

        public string? Tag { get; set; }
    }

    private static async Task<IResult> ListOwnAsync(
        [AsParameters] RecipeListQuery query,
        HttpContext httpContext,
        ISpecificationExecutor executor,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        if (query.MaxTotalTimeMinutes is < 0)
        {
            return Results.ValidationProblem(
                new Dictionary<string, string[]>
                {
                    ["maxTotalTimeMinutes"] = ["Total time cannot be negative."],
                });
        }

        var (page, pageSize) = Pagination.Normalize(query.Page, query.PageSize);
        var specification = new RecipeListSpecification(
            userId.Value,
            new RecipeListFilter(
                query.Cuisine,
                query.MaxTotalTimeMinutes,
                query.Difficulty,
                query.Diet,
                query.Tag),
            page,
            pageSize);

        var result = await executor.ToPagedListAsync(specification, cancellationToken);
        return Results.Ok(result);
    }

    private static async Task<IResult> ListSavedAsync(
        [AsParameters] PageQuery query,
        HttpContext httpContext,
        ISpecificationExecutor executor,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var (page, pageSize) = Pagination.Normalize(query.Page, query.PageSize);
        var specification = new SavedRecipeListSpecification(userId.Value, page, pageSize);
        var result = await executor.ToPagedListAsync(specification, cancellationToken);
        return Results.Ok(result);
    }

    private static async Task<IResult> CreateAsync(
        RecipeWriteRequest request,
        HttpContext httpContext,
        IRecipeRepository recipes,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var creation = Recipe.Create(userId.Value, request.Title ?? string.Empty);
        if (!creation.IsSuccess)
        {
            return creation.Error!.ToProblem();
        }

        var recipe = creation.Value;
        var applied = ApplyWrite(recipe, request);
        if (!applied.IsSuccess)
        {
            return applied.Error!.ToProblem();
        }

        recipes.Add(recipe);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        var stored = await recipes.FindWithDetailsAsync(recipe.Id, cancellationToken) ?? recipe;
        return Results.Created(
            $"/recipes/{recipe.Id}",
            RecipeDetailDto.From(stored, isSaved: false));
    }

    private static async Task<IResult> GetAsync(
        Guid id,
        HttpContext httpContext,
        IRecipeRepository recipes,
        ISavedRecipeRepository savedRecipes,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var recipe = await recipes.FindWithDetailsAsync(id, cancellationToken);
        if (recipe is null || !CanRead(recipe, userId.Value))
        {
            return RecipeNotFound();
        }

        var isSaved = await savedRecipes.ExistsAsync(userId.Value, id, cancellationToken);
        return Results.Ok(RecipeDetailDto.From(recipe, isSaved));
    }

    private static async Task<IResult> UpdateAsync(
        Guid id,
        RecipeWriteRequest request,
        HttpContext httpContext,
        IRecipeRepository recipes,
        ISavedRecipeRepository savedRecipes,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var recipe = await recipes.FindWithDetailsAsync(id, cancellationToken);
        if (recipe is null || recipe.AuthorId != userId.Value)
        {
            return RecipeNotFound();
        }

        var applied = ApplyWrite(recipe, request);
        if (!applied.IsSuccess)
        {
            return applied.Error!.ToProblem();
        }

        await unitOfWork.SaveChangesAsync(cancellationToken);

        var isSaved = await savedRecipes.ExistsAsync(userId.Value, id, cancellationToken);
        return Results.Ok(RecipeDetailDto.From(recipe, isSaved));
    }

    private static async Task<IResult> DeleteAsync(
        Guid id,
        HttpContext httpContext,
        IRecipeRepository recipes,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var recipe = await recipes.FindWithDetailsAsync(id, cancellationToken);
        if (recipe is null || recipe.AuthorId != userId.Value)
        {
            return RecipeNotFound();
        }

        recipes.Remove(recipe);
        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Results.NoContent();
    }

    private static async Task<IResult> PublishAsync(
        Guid id,
        HttpContext httpContext,
        IRecipeRepository recipes,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var recipe = await recipes.FindWithDetailsAsync(id, cancellationToken);
        if (recipe is null || recipe.AuthorId != userId.Value)
        {
            return RecipeNotFound();
        }

        var publish = recipe.Publish();
        if (!publish.IsSuccess)
        {
            return publish.Error!.ToProblem();
        }

        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Results.NoContent();
    }

    private static async Task<IResult> UnpublishAsync(
        Guid id,
        HttpContext httpContext,
        IRecipeRepository recipes,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var recipe = await recipes.FindWithDetailsAsync(id, cancellationToken);
        if (recipe is null || recipe.AuthorId != userId.Value)
        {
            return RecipeNotFound();
        }

        recipe.Unpublish();
        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Results.NoContent();
    }

    private static async Task<IResult> SaveAsync(
        Guid id,
        [FromQuery] Guid? collectionId,
        HttpContext httpContext,
        RecipeLibraryService library,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var saved = await library.SaveAsync(userId.Value, id, collectionId, cancellationToken);
        return saved.ToHttpResult();
    }

    private static async Task<IResult> UnsaveAsync(
        Guid id,
        HttpContext httpContext,
        RecipeLibraryService library,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var removed = await library.UnsaveAsync(userId.Value, id, cancellationToken);
        return removed.ToHttpResult();
    }

    /// <summary>Applies validated edit-form values in the order the aggregate enforces.</summary>
    private static Result ApplyWrite(Recipe recipe, RecipeWriteRequest request)
    {
        var details = new RecipeDetails(
            request.Title ?? string.Empty,
            request.Description,
            request.Cuisine,
            request.CoverImageUrl,
            request.Tags,
            request.DietaryTags,
            request.MealType,
            request.Servings,
            request.PrepTimeMinutes,
            request.CookTimeMinutes,
            request.Difficulty);

        return recipe
            .UpdateDetails(details)
            .Bind(() => recipe.ReplaceIngredients(
                request.Ingredients?
                    .Select(ingredient => new IngredientDraft(
                        ingredient.Quantity,
                        ingredient.Unit,
                        ingredient.Name ?? string.Empty,
                        ingredient.Note))
                    .ToList()))
            .Bind(() => recipe.ReplaceSteps(
                request.Steps?
                    .Select(step => new StepDraft(
                        step.Instruction ?? string.Empty,
                        step.Tip,
                        step.TimerSeconds))
                    .ToList()))
            .Bind(() => recipe.ReplaceMedia(
                request.Media?
                    .Select(media => new MediaDraft(
                        media.Url ?? string.Empty,
                        media.Kind,
                        media.AltText))
                    .ToList()));
    }

    private static bool CanRead(Recipe recipe, Guid userId) =>
        recipe.AuthorId == userId
        || (recipe.Visibility == RecipeVisibility.Public && recipe.Status == RecipeStatus.Published);

    private static IResult RecipeNotFound() =>
        ApplicationError.Of("recipe.not-found", "Recipe not found.").ToProblem();
}
