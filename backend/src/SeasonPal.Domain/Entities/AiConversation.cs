namespace SeasonPal.Domain.Entities;

/// <summary>Container for one AI companion conversation; messages persist for later context.</summary>
public class AiConversation
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public ApplicationUser User { get; set; } = null!;

    /// <summary>Derived from the first user message; empty until then.</summary>
    public string Title { get; set; } = string.Empty;

    public List<AiMessage> Messages { get; set; } = [];

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
}
