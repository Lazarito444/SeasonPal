namespace SeasonPal.Domain.Enums;

/// <summary>In-app community events; push delivery comes later but events originate here.</summary>
public enum NotificationType
{
    RecipeLiked = 0,
    RecipeCommented = 1,
    NewFollower = 2,
    RecipeAdapted = 3,
}
