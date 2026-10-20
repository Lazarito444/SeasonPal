namespace SeasonPal.IntegrationTests;

/// <summary>
/// All API/database integration tests share one Postgres container for speed;
/// xUnit runs collection members sequentially.
/// </summary>
[CollectionDefinition("SeasonPalApi")]
public sealed class SeasonPalApiCollection : ICollectionFixture<SeasonPalApiFactory>;
