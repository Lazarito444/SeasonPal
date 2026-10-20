namespace SeasonPal.Domain.Entities;

/// <summary>One turn in an AI conversation, appended only via the aggregate root.</summary>
public class AiMessage
{
    /// <summary>EF materializer.</summary>
    private AiMessage() { }

    public Guid Id { get; private set; }

    public Guid ConversationId { get; private set; }

    public AiConversation Conversation { get; private set; } = null!;

    public AiMessageRole Role { get; private set; }

    public string Content { get; private set; } = null!;

    public string? ContextJson { get; private set; }

    public DateTimeOffset CreatedAt { get; private set; }

    internal static AiMessage Assemble(
        Guid conversationId,
        AiMessageRole role,
        string content,
        string? contextJson) => new()
    {
        ConversationId = conversationId,
        Role = role,
        Content = content,
        ContextJson = contextJson,
        CreatedAt = DateTimeOffset.UtcNow,
    };
}
