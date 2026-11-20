namespace SeasonPal.Domain.Interfaces;

/// <summary>An entity that can be marked as deleted without being removed from storage.</summary>
public interface ISoftDeletable
{
    /// <summary>When the entity was soft-deleted, or <see langword="null"/> while it is active.</summary>
    DateTimeOffset? DeletedAt { get; }

    /// <summary>Marks the entity as deleted at the current time.</summary>
    void SoftDelete();
}
