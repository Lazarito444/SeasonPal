using SeasonPal.Domain.Entities;
using SeasonPal.Domain.Enums;

namespace SeasonPal.UnitTests;

public class AiConversationTests
{
    [Fact]
    public void Start_guards_the_owner()
    {
        var result = AiConversation.Start(Guid.Empty);

        Assert.False(result.IsSuccess);
        Assert.Equal("conversation.owner-required", result.Error!.Code);
    }

    [Fact]
    public void Start_creates_an_untitled_conversation()
    {
        var result = AiConversation.Start(Guid.NewGuid());

        Assert.True(result.IsSuccess);
        Assert.Equal(string.Empty, result.Value.Title);
        Assert.Empty(result.Value.Messages);
    }

    [Fact]
    public void AddMessage_names_the_conversation_from_the_first_user_message_only()
    {
        var conversation = AiConversation.Start(Guid.NewGuid()).Value;

        Assert.True(conversation.AddMessage(AiMessageRole.Assistant, "Hi! What shall we cook?").IsSuccess);
        Assert.Equal(string.Empty, conversation.Title);

        Assert.True(conversation.AddMessage(AiMessageRole.User, "Something quick with eggs").IsSuccess);
        Assert.Equal("Something quick with eggs", conversation.Title);

        Assert.True(conversation.AddMessage(AiMessageRole.Assistant, "Butter bean scramble?").IsSuccess);
        Assert.Equal("Something quick with eggs", conversation.Title);
    }

    [Fact]
    public void AddMessage_rejects_blank_content()
    {
        var conversation = AiConversation.Start(Guid.NewGuid()).Value;

        var result = conversation.AddMessage(AiMessageRole.User, "   ");

        Assert.False(result.IsSuccess);
        Assert.Equal("conversation.message-empty", result.Error!.Code);
        Assert.Empty(conversation.Messages);
    }

    [Fact]
    public void AddMessage_rejects_content_over_8000_characters()
    {
        var conversation = AiConversation.Start(Guid.NewGuid()).Value;

        var result = conversation.AddMessage(AiMessageRole.User, new string('a', 8001));

        Assert.False(result.IsSuccess);
        Assert.Equal("conversation.message-too-long", result.Error!.Code);
    }
}
