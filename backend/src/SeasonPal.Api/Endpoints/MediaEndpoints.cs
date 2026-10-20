using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SeasonPal.Api.Common;
using SeasonPal.Application.Media;
using SeasonPal.Domain.Common;

namespace SeasonPal.Api.Endpoints;

/// <summary>
/// Authenticated recipe media uploads. The client sends one file per request and stores the
/// returned root-relative URL on the recipe; the static middleware serves it under /media.
/// </summary>
public static class MediaEndpoints
{
    extension(IEndpointRouteBuilder app)
    {
        public void MapMediaEndpoints()
        {
            var group = app
                .MapGroup("/media")
                .WithTags("Media")
                .RequireAuthorization();

            group.MapPost("", UploadAsync)
                // Mobile clients authenticate with a bearer token, not cookies, so antiforgery
                // tokens add no protection here.
                .DisableAntiforgery()
                .WithSummary("Upload one recipe photo or video.")
                .Produces<MediaUploadDto>(StatusCodes.Status201Created)
                .ProducesProblem(StatusCodes.Status400BadRequest)
                .ProducesProblem(StatusCodes.Status401Unauthorized)
                .ProducesProblem(StatusCodes.Status413PayloadTooLarge)
                .ProducesProblem(StatusCodes.Status415UnsupportedMediaType);
        }
    }

    private static async Task<IResult> UploadAsync(
        [FromForm] IFormFile? file,
        IMediaStorage storage,
        CancellationToken cancellationToken)
    {
        if (file is null || file.Length == 0)
        {
            return ApplicationError
                .Of("media.file-empty", "Choose a non-empty file.")
                .ToProblem();
        }

        if (!MediaContentTypes.TryGet(file.ContentType, out var contentType))
        {
            return ApplicationError
                .Of(
                    "media.unsupported-type",
                    "Use a JPEG, PNG, WebP, GIF, MP4 or MOV file.",
                    ("type", file.ContentType))
                .ToProblem();
        }

        if (file.Length > contentType.MaxBytes)
        {
            return ApplicationError
                .Of(
                    "media.file-too-large",
                    $"Files of this type must be at most {contentType.MaxBytes} bytes.",
                    ("max", contentType.MaxBytes.ToString()))
                .ToProblem();
        }

        await using var stream = file.OpenReadStream();
        var saved = await storage.SaveAsync(stream, contentType, file.Length, cancellationToken);

        return saved.ToHttpResult(media => Results.Created(
            media.Url,
            new MediaUploadDto(media.Url, media.Kind, media.ContentType, media.SizeBytes)));
    }
}
