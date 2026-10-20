using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence.Configurations;

internal sealed class CommentConfiguration : IEntityTypeConfiguration<Comment>
{
    public void Configure(EntityTypeBuilder<Comment> builder)
    {
        builder.Property(c => c.Text).HasMaxLength(1000).IsRequired();

        builder.HasOne(c => c.Recipe)
            .WithMany()
            .HasForeignKey(c => c.RecipeId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(c => c.Author)
            .WithMany()
            .HasForeignKey(c => c.AuthorId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(c => c.Parent)
            .WithMany()
            .HasForeignKey(c => c.ParentId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.HasIndex(c => new { c.RecipeId, c.CreatedAt }).IsDescending(false, true);
    }
}

internal sealed class FollowConfiguration : IEntityTypeConfiguration<Follow>
{
    public void Configure(EntityTypeBuilder<Follow> builder)
    {
        builder.HasKey(f => new { f.FollowerId, f.FolloweeId });

        builder.HasOne(f => f.Follower)
            .WithMany()
            .HasForeignKey(f => f.FollowerId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(f => f.Followee)
            .WithMany()
            .HasForeignKey(f => f.FolloweeId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(f => f.FolloweeId);
    }
}

internal sealed class CookingHistoryEntryConfiguration : IEntityTypeConfiguration<CookingHistoryEntry>
{
    public void Configure(EntityTypeBuilder<CookingHistoryEntry> builder)
    {
        builder.Property(h => h.Notes).HasMaxLength(1000);

        builder.HasOne(h => h.User)
            .WithMany()
            .HasForeignKey(h => h.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(h => h.Recipe)
            .WithMany()
            .HasForeignKey(h => h.RecipeId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(h => new { h.UserId, h.CookedAt }).IsDescending(false, true);
    }
}

internal sealed class NotificationConfiguration : IEntityTypeConfiguration<Notification>
{
    public void Configure(EntityTypeBuilder<Notification> builder)
    {
        builder.Property(n => n.PayloadJson).HasColumnType("text");

        builder.HasOne(n => n.User)
            .WithMany()
            .HasForeignKey(n => n.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(n => new { n.UserId, n.ReadAt });
    }
}
