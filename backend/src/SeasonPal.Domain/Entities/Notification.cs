namespace SeasonPal.Domain.Entities;

/// <summary>In-app notification; payload is JSON so new event shapes need no migration.</summary>
public class Notification
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public ApplicationUser User { get; set; } = null!;

    public NotificationType Type { get; set; }

    public string? PayloadJson { get; set; }

    public DateTimeOffset? ReadAt { get; set; }

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
}
