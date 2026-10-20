using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using SeasonPal.Application.Common;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Infrastructure.Persistence;

/// <summary>Aggregate root context; entity shaping lives in the IEntityTypeConfiguration classes.</summary>
public class SeasonPalDbContext(DbContextOptions<SeasonPalDbContext> options)
    : IdentityDbContext<ApplicationUser, Microsoft.AspNetCore.Identity.IdentityRole<Guid>, Guid>(options), IUnitOfWork
{
    public DbSet<UserPreference> UserPreferences => Set<UserPreference>();

    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();

    public DbSet<Recipe> Recipes => Set<Recipe>();

    public DbSet<RecipeIngredient> RecipeIngredients => Set<RecipeIngredient>();

    public DbSet<RecipeStep> RecipeSteps => Set<RecipeStep>();

    public DbSet<RecipeMedia> RecipeMedia => Set<RecipeMedia>();

    public DbSet<Collection> Collections => Set<Collection>();

    public DbSet<CollectionRecipe> CollectionRecipes => Set<CollectionRecipe>();

    public DbSet<SavedRecipe> SavedRecipes => Set<SavedRecipe>();

    public DbSet<Rating> Ratings => Set<Rating>();

    public DbSet<Comment> Comments => Set<Comment>();

    public DbSet<Follow> Follows => Set<Follow>();

    public DbSet<CookingHistoryEntry> CookingHistory => Set<CookingHistoryEntry>();

    public DbSet<AiConversation> AiConversations => Set<AiConversation>();

    public DbSet<Notification> Notifications => Set<Notification>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.ApplyConfigurationsFromAssembly(typeof(SeasonPalDbContext).Assembly);
    }
}
