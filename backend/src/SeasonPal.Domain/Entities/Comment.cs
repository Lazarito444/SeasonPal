namespace SeasonPal.Domain.Entities;

/// <summary>Comment thread on a recipe; single-level replies via <see cref="ParentId"/>.</summary>
public class Comment
{
    public Guid Id { get; set; }

    public Guid RecipeId { get; set; }

    public Recipe Recipe { get; set; } = null!;

    public Guid AuthorId { get; set; }

    public ApplicationUser Author { get; set; } = null!;

    /// <summary>Null for top-level comments.</summary>
    public Guid? ParentId { get; set; }

    public Comment? Parent { get; set; }

    public string Text { get; set; } = string.Empty;

    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    public DateTimeOffset? EditedAt { get; set; }
}
