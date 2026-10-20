using Microsoft.AspNetCore.Identity;

namespace SeasonPal.Domain.Entities;

/// <summary>
/// SeasonPal user. Extends ASP.NET Identity so registration/auth tables (Stage 2)
/// and recipe authorship share one primary key.
/// </summary>
public class ApplicationUser : IdentityUser<Guid>
{
    /// <summary>Community-facing name; defaults to the email prefix until onboarding sets it.</summary>
    public string DisplayName { get; set; } = string.Empty;

    public string? Bio { get; set; }

    public string? AvatarUrl { get; set; }

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
}
