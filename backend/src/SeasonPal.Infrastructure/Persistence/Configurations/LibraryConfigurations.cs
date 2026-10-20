using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence.Configurations;

internal sealed class CollectionConfiguration : IEntityTypeConfiguration<Collection>
{
    public void Configure(EntityTypeBuilder<Collection> builder)
    {
        builder.Property(c => c.Name).HasMaxLength(100).IsRequired();
        builder.Property(c => c.Description).HasMaxLength(500);

        builder.HasOne(c => c.User)
            .WithMany()
            .HasForeignKey(c => c.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        // One collection name per user; the favorites collection is created by the API, never hand-made twice.
        builder.HasIndex(c => new { c.UserId, c.Name }).IsUnique();

        builder.HasMany(c => c.Items)
            .WithOne(ci => ci.Collection)
            .HasForeignKey(ci => ci.CollectionId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

internal sealed class CollectionRecipeConfiguration : IEntityTypeConfiguration<CollectionRecipe>
{
    public void Configure(EntityTypeBuilder<CollectionRecipe> builder)
    {
        builder.HasKey(ci => new { ci.CollectionId, ci.RecipeId });

        builder.HasOne(ci => ci.Recipe)
            .WithMany()
            .HasForeignKey(ci => ci.RecipeId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}

internal sealed class SavedRecipeConfiguration : IEntityTypeConfiguration<SavedRecipe>
{
    public void Configure(EntityTypeBuilder<SavedRecipe> builder)
    {
        builder.HasKey(s => new { s.UserId, s.RecipeId });

        builder.HasOne(s => s.User)
            .WithMany()
            .HasForeignKey(s => s.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(s => s.Recipe)
            .WithMany()
            .HasForeignKey(s => s.RecipeId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(s => s.RecipeId);
    }
}

internal sealed class RatingConfiguration : IEntityTypeConfiguration<Rating>
{
    public void Configure(EntityTypeBuilder<Rating> builder)
    {
        builder.ToTable(r => r.HasCheckConstraint("ck_rating_stars_range", "\"Stars\" BETWEEN 1 AND 5"));

        builder.HasKey(r => new { r.UserId, r.RecipeId });

        builder.Property(r => r.Stars).IsRequired();

        builder.HasOne(r => r.User)
            .WithMany()
            .HasForeignKey(r => r.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(r => r.Recipe)
            .WithMany()
            .HasForeignKey(r => r.RecipeId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(r => r.RecipeId);
    }
}
