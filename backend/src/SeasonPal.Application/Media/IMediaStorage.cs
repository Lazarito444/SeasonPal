using SeasonPal.Domain.Common;
using SeasonPal.Domain.Enums;

namespace SeasonPal.Application.Media;

/// <summary>
/// Deployment-neutral persistence for recipe photos and videos. The returned URL is what the
/// client stores on a recipe; storage never returns a local filesystem path.
/// </summary>
public interface IMediaStorage
{
    /// <summary>
    /// Validates and stores one upload. <paramref name="length"/> is the declared byte count;
    /// implementations must also enforce <see cref="MediaContentTypes.MaxBytes"/>.
    /// </summary>
    Task<Result<StoredMedia>> SaveAsync(
        Stream content,
        MediaContentType contentType,
        long length,
        CancellationToken cancellationToken = default);
}

/// <summary>Public metadata for a stored upload.</summary>
public sealed record StoredMedia(
    string Url,
    MediaKind Kind,
    string ContentType,
    long SizeBytes);

/// <summary>The upload response; the URL is safe to write straight onto a recipe.</summary>
public sealed record MediaUploadDto(
    string Url,
    MediaKind Kind,
    string ContentType,
    long SizeBytes);

/// <summary>
/// One supported upload format. Extensions are chosen here rather than taken from the client's
/// filename, and the MIME type is fixed so a stored file can never be served as HTML.
/// </summary>
public sealed record MediaContentType(
    string MimeType,
    string Extension,
    MediaKind Kind)
{
    public long MaxBytes => Kind == MediaKind.Image
        ? MediaConstraints.MaxImageBytes
        : MediaConstraints.MaxVideoBytes;
}

/// <summary>Product-level upload limits shared by the endpoint and the storage implementation.</summary>
public static class MediaConstraints
{
    public const long MaxImageBytes = 10 * 1024 * 1024;

    /// <summary>Kept below Kestrel's 30 MB default request body limit.</summary>
    public const long MaxVideoBytes = 24 * 1024 * 1024;
}

/// <summary>Supported image and video formats, matched by the multipart content type.</summary>
public static class MediaContentTypes
{
    private static readonly IReadOnlyDictionary<string, MediaContentType> ByMimeType =
        new Dictionary<string, MediaContentType>(StringComparer.OrdinalIgnoreCase)
        {
            ["image/jpeg"] = new("image/jpeg", ".jpg", MediaKind.Image),
            ["image/png"] = new("image/png", ".png", MediaKind.Image),
            ["image/webp"] = new("image/webp", ".webp", MediaKind.Image),
            ["image/gif"] = new("image/gif", ".gif", MediaKind.Image),
            ["video/mp4"] = new("video/mp4", ".mp4", MediaKind.Video),
            ["video/quicktime"] = new("video/quicktime", ".mov", MediaKind.Video),
        };

    public static bool TryGet(string? value, out MediaContentType contentType)
    {
        var mimeType = value?.Split(';', 2)[0].Trim();
        if (!string.IsNullOrEmpty(mimeType) && ByMimeType.TryGetValue(mimeType, out var found))
        {
            contentType = found;
            return true;
        }

        contentType = null!;
        return false;
    }
}
