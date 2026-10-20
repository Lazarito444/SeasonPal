namespace SeasonPal.Domain.Common;

/// <summary>
/// Typed, localizable business error. <see cref="FallbackMessage"/> is English-only text for
/// logs and unspecified-locale defaults; UIs localize through <see cref="Code"/> + <see cref="Args"/>
/// so wording lives outside the domain.
/// </summary>
public sealed record ApplicationError(string Code, string FallbackMessage, IReadOnlyDictionary<string, string?> Args)
{
    /// <summary>Factory that normalizes empty arg lists into an empty immutable dictionary.</summary>
    public static ApplicationError Of(string code, string fallbackMessage, params (string Key, string? Value)[] args)
    {
        var dictionary = args.Length == 0
            ? new Dictionary<string, string?>()
            : args.ToDictionary(a => a.Key, a => a.Value);

        return new ApplicationError(code, fallbackMessage, dictionary);
    }
}
