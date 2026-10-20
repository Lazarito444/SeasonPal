using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using SeasonPal.Application.Media;
using SeasonPal.Domain.Enums;

namespace SeasonPal.IntegrationTests;

[Collection("SeasonPalApi")]
public class MediaEndpointsTests(SeasonPalApiFactory factory)
{
    // 1x1 transparent PNG; small enough to keep the test fast but a real signature.
    private static readonly byte[] OnePixelPng = Convert.FromBase64String(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=");

    [Fact]
    public async Task Uploading_a_png_returns_a_cookable_url_that_static_files_serve()
    {
        var session = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail());
        var api = RecipeTestData.AuthorizedClient(factory, session.AccessToken);

        using var form = new MultipartFormDataContent();
        using var image = new ByteArrayContent(OnePixelPng);
        image.Headers.ContentType = new MediaTypeHeaderValue("image/png");
        form.Add(image, "file", "cover.png");

        var response = await api.PostAsync("/media", form);
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);

        var uploaded = await response.Content.ReadFromJsonAsync<MediaUploadDto>();
        Assert.NotNull(uploaded);
        Assert.StartsWith("/media/", uploaded.Url);
        Assert.EndsWith(".png", uploaded.Url);
        Assert.Equal(MediaKind.Image, uploaded.Kind);
        Assert.Equal("image/png", uploaded.ContentType);
        Assert.Equal(OnePixelPng.Length, uploaded.SizeBytes);
        Assert.DoesNotContain("cover.png", uploaded.Url);

        // The mobile client loads media without a bearer header, like a browser would.
        var publicClient = factory.CreateClient();
        var download = await publicClient.GetAsync(uploaded.Url);
        Assert.Equal(HttpStatusCode.OK, download.StatusCode);
        Assert.Equal("image/png", download.Content.Headers.ContentType?.MediaType);
        Assert.Equal(OnePixelPng, await download.Content.ReadAsByteArrayAsync());
    }

    [Fact]
    public async Task Uploads_require_auth_and_a_supported_matching_file()
    {
        var anonymous = factory.CreateClient();
        using var anonymousForm = new MultipartFormDataContent();
        anonymousForm.Add(new ByteArrayContent(OnePixelPng), "file", "cover.png");
        var unauthorized = await anonymous.PostAsync("/media", anonymousForm);
        Assert.Equal(HttpStatusCode.Unauthorized, unauthorized.StatusCode);
        Assert.Equal("auth.required", await RecipeTestData.ProblemCodeAsync(unauthorized));

        var session = await AuthTestData.RegisterAsync(
            factory.CreateClient(),
            AuthTestData.UniqueEmail());
        var api = RecipeTestData.AuthorizedClient(factory, session.AccessToken);

        using var wrongTypeForm = new MultipartFormDataContent();
        var text = new ByteArrayContent("not an image"u8.ToArray());
        text.Headers.ContentType = new MediaTypeHeaderValue("text/plain");
        wrongTypeForm.Add(text, "file", "notes.txt");
        var wrongType = await api.PostAsync("/media", wrongTypeForm);
        Assert.Equal(HttpStatusCode.UnsupportedMediaType, wrongType.StatusCode);
        Assert.Equal("media.unsupported-type", await RecipeTestData.ProblemCodeAsync(wrongType));

        using var spoofedForm = new MultipartFormDataContent();
        var spoofed = new ByteArrayContent("pretend png"u8.ToArray());
        spoofed.Headers.ContentType = new MediaTypeHeaderValue("image/png");
        spoofedForm.Add(spoofed, "file", "cover.png");
        var spoofedResponse = await api.PostAsync("/media", spoofedForm);
        Assert.Equal(HttpStatusCode.UnsupportedMediaType, spoofedResponse.StatusCode);
        Assert.Equal("media.content-invalid", await RecipeTestData.ProblemCodeAsync(spoofedResponse));
    }
}
