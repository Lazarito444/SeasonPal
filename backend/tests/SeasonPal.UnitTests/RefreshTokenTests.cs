using SeasonPal.Domain.Entities;

namespace SeasonPal.UnitTests;

public class RefreshTokenTests
{
    private const string Hash = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";

    [Fact]
    public void Issue_returns_an_active_token()
    {
        var now = DateTimeOffset.UtcNow;
        var result = RefreshToken.Issue(Guid.NewGuid(), Hash, now, TimeSpan.FromDays(30));

        Assert.True(result.IsSuccess);
        Assert.True(result.Value.IsActive(now));
        Assert.Equal(now.AddDays(30), result.Value.ExpiresAt);
        Assert.Null(result.Value.RevokedAt);
    }

    [Fact]
    public void Token_stops_being_active_after_expiry()
    {
        var now = DateTimeOffset.UtcNow;
        var token = RefreshToken.Issue(Guid.NewGuid(), Hash, now, TimeSpan.FromMinutes(5)).Value;

        Assert.False(token.IsActive(now.AddMinutes(6)));
    }

    [Fact]
    public void Revoke_records_the_replacement_and_is_idempotent()
    {
        var now = DateTimeOffset.UtcNow;
        var token = RefreshToken.Issue(Guid.NewGuid(), Hash, now, TimeSpan.FromDays(30)).Value;
        const string replacement = "fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210";

        Assert.True(token.Revoke(now, replacement));
        Assert.False(token.Revoke(now.AddMinutes(1)));
        Assert.False(token.IsActive(now));
        Assert.Equal(replacement, token.ReplacedByTokenHash);
    }

    [Fact]
    public void Issue_rejects_a_missing_user()
    {
        var result = RefreshToken.Issue(Guid.Empty, Hash, DateTimeOffset.UtcNow, TimeSpan.FromDays(1));

        Assert.False(result.IsSuccess);
        Assert.Equal("auth.token-user-required", result.Error!.Code);
    }

    [Theory]
    [InlineData("short")]
    [InlineData("")]
    public void Issue_rejects_malformed_hashes(string hash)
    {
        var result = RefreshToken.Issue(Guid.NewGuid(), hash, DateTimeOffset.UtcNow, TimeSpan.FromDays(1));

        Assert.False(result.IsSuccess);
        Assert.Equal("auth.token-hash-invalid", result.Error!.Code);
    }

    [Fact]
    public void Issue_rejects_a_non_positive_lifetime()
    {
        var result = RefreshToken.Issue(Guid.NewGuid(), Hash, DateTimeOffset.UtcNow, TimeSpan.Zero);

        Assert.False(result.IsSuccess);
        Assert.Equal("auth.token-lifetime-invalid", result.Error!.Code);
    }
}
