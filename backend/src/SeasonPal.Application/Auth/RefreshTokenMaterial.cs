using System.Security.Cryptography;
using System.Text;

namespace SeasonPal.Application.Auth;

/// <summary>Raw refresh-token material and its at-rest hash.</summary>
internal static class RefreshTokenMaterial
{
    /// <summary>256 bits of entropy, URL-safe so it survives JSON and query strings.</summary>
    public static string Create()
    {
        var bytes = RandomNumberGenerator.GetBytes(32);
        return Convert.ToBase64String(bytes)
            .Replace('+', '-')
            .Replace('/', '_')
            .TrimEnd('=');
    }

    public static string Hash(string rawToken)
    {
        var digest = SHA256.HashData(Encoding.UTF8.GetBytes(rawToken));
        return Convert.ToHexString(digest);
    }
}
