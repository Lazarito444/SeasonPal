using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SeasonPal.Application.Media;
using SeasonPal.Domain.Common;

namespace SeasonPal.Infrastructure.Media;

/// <summary>Where uploaded recipe media lives. Empty means "media" under the content root.</summary>
public sealed class MediaStorageOptions
{
    public const string SectionName = "MediaStorage";

    public string RootPath { get; set; } = string.Empty;
}

/// <summary>
/// Local-disk media storage for development and single-node deployments. Files are named with
/// random ids and fixed extensions, so a client filename can never choose the served path or MIME
/// type. Swap this implementation for object storage without touching the API contract.
/// </summary>
public sealed class LocalMediaStorage(
    IOptions<MediaStorageOptions> options,
    ILogger<LocalMediaStorage> logger) : IMediaStorage
{
    private readonly string _rootPath = options.Value.RootPath;

    public async Task<Result<StoredMedia>> SaveAsync(
        Stream content,
        MediaContentType contentType,
        long length,
        CancellationToken cancellationToken = default)
    {
        if (!content.CanSeek)
        {
            throw new ArgumentException("Media streams must be seekable for signature checks.", nameof(content));
        }

        if (length <= 0)
        {
            return Result<StoredMedia>.Fail(
                ApplicationError.Of("media.file-empty", "Choose a non-empty file."));
        }

        if (length > contentType.MaxBytes)
        {
            return Result<StoredMedia>.Fail(
                ApplicationError.Of(
                    "media.file-too-large",
                    $"Files of this type must be at most {contentType.MaxBytes} bytes.",
                    ("max", contentType.MaxBytes.ToString())));
        }

        if (!await HasValidSignatureAsync(content, contentType, cancellationToken))
        {
            return Result<StoredMedia>.Fail(
                ApplicationError.Of(
                    "media.content-invalid",
                    "The file does not match its declared media type."));
        }

        Directory.CreateDirectory(_rootPath);
        var fileName = $"{Guid.NewGuid():N}{contentType.Extension}";
        var fullPath = Path.Combine(_rootPath, fileName);

        try
        {
            content.Position = 0;
            await using var target = new FileStream(
                fullPath,
                FileMode.CreateNew,
                FileAccess.Write,
                FileShare.None,
                bufferSize: 81_920,
                FileOptions.Asynchronous);
            await content.CopyToAsync(target, cancellationToken);
        }
        catch
        {
            // Never leave a half-written file behind for the static middleware to serve.
            if (File.Exists(fullPath))
            {
                File.Delete(fullPath);
            }

            throw;
        }

        logger.LogInformation(
            "Stored {Kind} media ({Bytes} bytes) as {FileName}",
            contentType.Kind,
            length,
            fileName);

        return Result<StoredMedia>.Ok(
            new StoredMedia(
                $"/media/{fileName}",
                contentType.Kind,
                contentType.MimeType,
                length));
    }

    private static async Task<bool> HasValidSignatureAsync(
        Stream content,
        MediaContentType contentType,
        CancellationToken cancellationToken)
    {
        var header = new byte[16];
        var read = await content.ReadAsync(header, cancellationToken);
        content.Position = 0;

        return contentType.MimeType switch
        {
            "image/jpeg" => read >= 3
                && header[0] == 0xFF
                && header[1] == 0xD8
                && header[2] == 0xFF,
            "image/png" => read >= 8
                && header[0] == 0x89
                && header[1] == 0x50
                && header[2] == 0x4E
                && header[3] == 0x47
                && header[4] == 0x0D
                && header[5] == 0x0A
                && header[6] == 0x1A
                && header[7] == 0x0A,
            "image/gif" => read >= 6
                && header[0] == 'G'
                && header[1] == 'I'
                && header[2] == 'F'
                && header[3] == '8'
                && (header[4] == '7' || header[4] == '9')
                && header[5] == 'a',
            "image/webp" => read >= 12
                && header[0] == 'R'
                && header[1] == 'I'
                && header[2] == 'F'
                && header[3] == 'F'
                && header[8] == 'W'
                && header[9] == 'E'
                && header[10] == 'B'
                && header[11] == 'P',
            "video/mp4" or "video/quicktime" => read >= 12
                && header[4] == 'f'
                && header[5] == 't'
                && header[6] == 'y'
                && header[7] == 'p',
            _ => false,
        };
    }
}
