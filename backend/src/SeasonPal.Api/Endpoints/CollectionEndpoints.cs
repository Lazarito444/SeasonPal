using Microsoft.AspNetCore.Http;
using SeasonPal.Api.Common;
using SeasonPal.Application.Collections;
using SeasonPal.Application.Common;
using SeasonPal.Application.Recipes;
using SeasonPal.Domain.Common;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Api.Endpoints;

/// <summary>
/// User collections, including the implicit favorites collection. Saving a recipe always
/// touches favorites first; adding it to a custom collection is an optional second step. Every
/// endpoint is scoped to the signed-in owner.
/// </summary>
public static class CollectionEndpoints
{
    extension(IEndpointRouteBuilder app)
    {
        public void MapCollectionEndpoints()
        {
            var group = app
                .MapGroup("/collections")
                .WithTags("Collections")
                .RequireAuthorization();

            group.MapGet("", ListAsync)
                .WithSummary("List the signed-in user's collections, newest first.")
                .Produces<PagedResult<CollectionSummaryDto>>()
                .ProducesProblem(StatusCodes.Status401Unauthorized);

            group.MapPost("", CreateAsync)
                .AddEndpointFilter<ValidationFilter<CreateCollectionRequest>>()
                .WithSummary("Create a custom collection.")
                .Produces<CollectionSummaryDto>(StatusCodes.Status201Created)
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status409Conflict);

            group.MapGet("/{id:guid}", GetAsync)
                .WithSummary("Read one collection and a page of its recipes in display order.")
                .Produces<CollectionDetailDto>()
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapPut("/{id:guid}", UpdateAsync)
                .AddEndpointFilter<ValidationFilter<UpdateCollectionRequest>>()
                .WithSummary("Rename a custom collection and replace its description.")
                .Produces<CollectionSummaryDto>()
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound)
                .ProducesProblem(StatusCodes.Status409Conflict);

            group.MapDelete("/{id:guid}", DeleteAsync)
                .WithSummary("Delete a custom collection; favorites cannot be deleted.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound)
                .ProducesProblem(StatusCodes.Status409Conflict);

            group.MapPut("/{id:guid}/recipes/{recipeId:guid}", AddRecipeAsync)
                .WithSummary("Add a recipe to a collection, saving it to the library if needed.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapDelete("/{id:guid}/recipes/{recipeId:guid}", RemoveRecipeAsync)
                .WithSummary("Remove a recipe from a collection; favorites removal unsaves it everywhere.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);

            group.MapPut("/{id:guid}/order", ReorderAsync)
                .AddEndpointFilter<ValidationFilter<ReorderCollectionRequest>>()
                .WithSummary("Replace the collection's recipe order with the complete ordered id list.")
                .Produces(StatusCodes.Status204NoContent)
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status400BadRequest)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status404NotFound);
        }
    }

    private static async Task<IResult> ListAsync(
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
        var specification = new CollectionListSpecification(userId.Value, page, pageSize);
        var result = await executor.ToPagedListAsync(specification, cancellationToken);
        return Results.Ok(result);
    }

    private static async Task<IResult> CreateAsync(
        CreateCollectionRequest request,
        HttpContext httpContext,
        ICollectionRepository collections,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var name = request.Name ?? string.Empty;
        if (await collections.NameExistsAsync(
            userId.Value,
            name.Trim().ToLowerInvariant(),
            cancellationToken: cancellationToken))
        {
            return NameTaken();
        }

        var creation = Collection.Create(userId.Value, name, request.Description);
        if (!creation.IsSuccess)
        {
            return creation.Error!.ToProblem();
        }

        collections.Add(creation.Value);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return Results.Created(
            $"/collections/{creation.Value.Id}",
            CollectionSummaryDto.From(creation.Value, recipeCount: 0));
    }

    private static async Task<IResult> GetAsync(
        Guid id,
        [AsParameters] PageQuery query,
        HttpContext httpContext,
        ICollectionRepository collections,
        ISpecificationExecutor executor,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var collection = await collections.FindOwnedAsync(id, userId.Value, cancellationToken);
        if (collection is null)
        {
            return CollectionNotFound();
        }

        var (page, pageSize) = Pagination.Normalize(query.Page, query.PageSize);
        var specification = new CollectionRecipeListSpecification(
            collection.Id,
            userId.Value,
            page,
            pageSize);

        var recipes = await executor.ToPagedListAsync(specification, cancellationToken);
        var recipeCount = await collections.CountItemsAsync(collection.Id, cancellationToken);

        return Results.Ok(
            new CollectionDetailDto(
                collection.Id,
                collection.Name,
                collection.Description,
                collection.IsDefaultFavorites,
                recipeCount,
                collection.CreatedAt,
                recipes));
    }

    private static async Task<IResult> UpdateAsync(
        Guid id,
        UpdateCollectionRequest request,
        HttpContext httpContext,
        ICollectionRepository collections,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var collection = await collections.FindOwnedAsync(id, userId.Value, cancellationToken);
        if (collection is null)
        {
            return CollectionNotFound();
        }

        if (collection.IsDefaultFavorites)
        {
            return FavoritesProtected();
        }

        var name = request.Name ?? string.Empty;
        if (await collections.NameExistsAsync(
            userId.Value,
            name.Trim().ToLowerInvariant(),
            collection.Id,
            cancellationToken))
        {
            return NameTaken();
        }

        var update = collection.UpdateDetails(name, request.Description);
        if (!update.IsSuccess)
        {
            return update.Error!.ToProblem();
        }

        await unitOfWork.SaveChangesAsync(cancellationToken);
        var recipeCount = await collections.CountItemsAsync(collection.Id, cancellationToken);
        return Results.Ok(CollectionSummaryDto.From(collection, recipeCount));
    }

    private static async Task<IResult> DeleteAsync(
        Guid id,
        HttpContext httpContext,
        ICollectionRepository collections,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var collection = await collections.FindOwnedAsync(id, userId.Value, cancellationToken);
        if (collection is null)
        {
            return CollectionNotFound();
        }

        if (collection.IsDefaultFavorites)
        {
            return FavoritesProtected();
        }

        collections.Remove(collection);
        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Results.NoContent();
    }

    private static async Task<IResult> AddRecipeAsync(
        Guid id,
        Guid recipeId,
        HttpContext httpContext,
        RecipeLibraryService library,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var result = await library.SaveAsync(userId.Value, recipeId, id, cancellationToken);
        return result.ToHttpResult();
    }

    private static async Task<IResult> RemoveRecipeAsync(
        Guid id,
        Guid recipeId,
        HttpContext httpContext,
        RecipeLibraryService library,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var result = await library.RemoveFromCollectionAsync(
            userId.Value,
            id,
            recipeId,
            cancellationToken);

        return result.ToHttpResult();
    }

    private static async Task<IResult> ReorderAsync(
        Guid id,
        ReorderCollectionRequest request,
        HttpContext httpContext,
        ICollectionRepository collections,
        IUnitOfWork unitOfWork,
        CancellationToken cancellationToken)
    {
        var userId = httpContext.User.GetUserId();
        if (userId is null)
        {
            return Results.Unauthorized();
        }

        var collection = await collections.FindOwnedWithItemsAsync(id, userId.Value, cancellationToken);
        if (collection is null)
        {
            return CollectionNotFound();
        }

        var reorder = collection.Reorder(request.RecipeIds ?? []);
        if (!reorder.IsSuccess)
        {
            return reorder.Error!.ToProblem();
        }

        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Results.NoContent();
    }

    private static IResult CollectionNotFound() =>
        ApplicationError.Of("collection.not-found", "Collection not found.").ToProblem();

    private static IResult NameTaken() =>
        ApplicationError.Of(
            "collection.name-taken",
            "A collection with that name already exists.").ToProblem();

    private static IResult FavoritesProtected() =>
        ApplicationError.Of(
            "collection.favorites-protected",
            "The favorites collection cannot be renamed, edited or deleted.").ToProblem();
}
