using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence.Configurations;

internal sealed class AiConversationConfiguration : IEntityTypeConfiguration<AiConversation>
{
    public void Configure(EntityTypeBuilder<AiConversation> builder)
    {
        builder.Property(c => c.Title).HasMaxLength(200);

        builder.HasOne(c => c.User)
            .WithMany()
            .HasForeignKey(c => c.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(c => c.Messages)
            .WithOne(m => m.Conversation)
            .HasForeignKey(m => m.ConversationId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(c => new { c.UserId, c.CreatedAt }).IsDescending(false, true);
    }
}

internal sealed class AiMessageConfiguration : IEntityTypeConfiguration<AiMessage>
{
    public void Configure(EntityTypeBuilder<AiMessage> builder)
    {
        builder.Property(m => m.Content).HasMaxLength(8000).IsRequired();
        builder.Property(m => m.ContextJson).HasColumnType("text");

        builder.HasIndex(m => new { m.ConversationId, m.CreatedAt }).IsDescending(false, true);
    }
}
