using System.Net;

namespace SeasonPal.IntegrationTests;

[Collection("SeasonPalApi")]
public class HealthEndpointsTests(SeasonPalApiFactory factory)
{
    [Fact]
    public async Task Live_reports_healthy_without_dependency_checks()
    {
        var client = factory.CreateClient();

        var response = await client.GetAsync("/health/live");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Ready_reports_healthy_when_database_is_reachable()
    {
        var client = factory.CreateClient();

        var response = await client.GetAsync("/health/ready");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Openapi_document_is_served_in_development()
    {
        var client = factory.CreateClient();

        var response = await client.GetAsync("/openapi/v1.json");
        var document = await response.Content.ReadAsStringAsync();

        // Probes are excluded from the document by the OpenAPI generator, so the
        // assertion pins the contract (served, valid document shape), not path presence.
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Contains("\"openapi\": \"3.", document, StringComparison.InvariantCultureIgnoreCase);
        Assert.Contains("SeasonPal.Api", document, StringComparison.InvariantCultureIgnoreCase);
    }
}
