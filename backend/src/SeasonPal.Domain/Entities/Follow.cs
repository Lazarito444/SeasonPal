namespace SeasonPal.Domain.Entities;

/// <summary>Creator follow edge: <see cref="FollowerId"/> subscribes to <see cref="FolloweeId"/>.</summary>
public class Follow
{
    public Guid FollowerId { get; set; }

    public ApplicationUser Follower { get; set; } = null!;

    public Guid FolloweeId { get; set; }

    public ApplicationUser Followee { get; set; } = null!;

    public DateTimeOffset FollowedAt { get; set; } = DateTimeOffset.UtcNow;
}
