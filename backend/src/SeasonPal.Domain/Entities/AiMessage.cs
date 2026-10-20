namespace SeasonPal.Domain.Entities;

/// <summary>One turn in an AI conversation. <see cref="ContextJson"/> holds rolled-up pantry/save context refs.</summary>
public class AiMessage
{
    public Guid Id { get; set; }

    public Guid ConversationId { get; set; }

    public AiConversation Conversation { get; set; } = null!;

    public AiMessageRole Role { get; set; }

    public string Content { get; set; } = string.Empty;

    public string? ContextJson { get; set; }

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
}
