using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence.Configurations;

internal sealed class RecipeConfiguration : IEntityTypeConfiguration<Recipe>
{
    public void Configure(EntityTypeBuilder<Recipe> builder)
    {
        builder.Property(r => r.Title).HasMaxLength(200).IsRequired();
        builder.Property(r => r.Description).HasMaxLength(2000);
        builder.Property(r => r.Cuisine).HasMaxLength(100);
        builder.Property(r => r.CoverImageUrl).HasMaxLength(2048);
        builder.Property(r => r.Tags).HasColumnType("text[]");
        builder.Property(r => r.DietaryTags)
            .HasColumnType("text[]")
            .HasDefaultValueSql("'{}'::text[]");

        builder.HasOne(r => r.Author)
            .WithMany()
            .HasForeignKey(r => r.AuthorId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(r => r.SourceRecipe)
            .WithMany()
            .HasForeignKey(r => r.SourceRecipeId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(r => r.Ingredients)
            .WithOne(i => i.Recipe)
            .HasForeignKey(i => i.RecipeId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(r => r.Steps)
            .WithOne(s => s.Recipe)
            .HasForeignKey(s => s.RecipeId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(r => r.Media)
            .WithOne(m => m.Recipe)
            .HasForeignKey(m => m.RecipeId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(r => r.AuthorId);
        builder.HasIndex(r => new { r.Visibility, r.Status, r.CreatedAt }).IsDescending(false, false, true);
    }
}

internal sealed class RecipeIngredientConfiguration : IEntityTypeConfiguration<RecipeIngredient>
{
    public void Configure(EntityTypeBuilder<RecipeIngredient> builder)
    {
        builder.Property(i => i.Name).HasMaxLength(200).IsRequired();
        builder.Property(i => i.Unit).HasMaxLength(50);
        builder.Property(i => i.Note).HasMaxLength(500);

        builder.HasIndex(i => new { i.RecipeId, i.Order });
    }
}

internal sealed class RecipeStepConfiguration : IEntityTypeConfiguration<RecipeStep>
{
    public void Configure(EntityTypeBuilder<RecipeStep> builder)
    {
        builder.Property(s => s.Instruction).HasMaxLength(2000).IsRequired();
        builder.Property(s => s.Tip).HasMaxLength(500);

        builder.HasIndex(s => new { s.RecipeId, s.Order });
    }
}

internal sealed class RecipeMediaConfiguration : IEntityTypeConfiguration<RecipeMedia>
{
    public void Configure(EntityTypeBuilder<RecipeMedia> builder)
    {
        builder.Property(m => m.Url).HasMaxLength(2048).IsRequired();
        builder.Property(m => m.AltText).HasMaxLength(200);

        builder.HasIndex(m => new { m.RecipeId, m.Order });
    }
}
