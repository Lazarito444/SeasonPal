using SeasonPal.Domain.Common;

namespace SeasonPal.Domain.Entities;

/// <summary>
/// Aggregate root: one AI companion conversation. Messages are appended through
/// <see cref="AddMessage"/>; the title is derived from the first user message.
/// </summary>
public class AiConversation
{
    private const int MaxContentLength = 8000;
    private const int MaxTitleLength = 80;

    private readonly List<AiMessage> _messages = [];

    /// <summary>EF materializer.</summary>
    private AiConversation() { }

    public Guid Id { get; private set; }

    public Guid UserId { get; private set; }

    public ApplicationUser User { get; private set; } = null!;

    /// <summary>Empty until the first user message names it.</summary>
    public string Title { get; private set; } = string.Empty;

    public IReadOnlyList<AiMessage> Messages => _messages;

    public DateTimeOffset CreatedAt { get; private set; }

    public static Result<AiConversation> Start(Guid userId)
    {
        if (userId == Guid.Empty)
        {
            return Result<AiConversation>.Fail(
                ApplicationError.Of("conversation.owner-required", "A conversation must belong to a user."));
        }

        return new AiConversation
        {
            UserId = userId,
            CreatedAt = DateTimeOffset.UtcNow,
        };
    }

    public Result<AiMessage> AddMessage(AiMessageRole role, string content, string? contextJson = null)
    {
        if (string.IsNullOrWhiteSpace(content))
        {
            return Result<AiMessage>.Fail(
                ApplicationError.Of("conversation.message-empty", "Message content is required."));
        }

        if (content.Length > MaxContentLength)
        {
            return Result<AiMessage>.Fail(
                ApplicationError.Of(
                    "conversation.message-too-long", "Message exceeds 8000 characters.", ("max", "8000")));
        }

        if (role == AiMessageRole.User && Title.Length == 0)
        {
            Title = content.TrimEnd()[..Math.Min(content.TrimEnd().Length, MaxTitleLength)];
        }

        var message = AiMessage.Assemble(Id, role, content, contextJson);
        _messages.Add(message);
        return message;
    }
}
