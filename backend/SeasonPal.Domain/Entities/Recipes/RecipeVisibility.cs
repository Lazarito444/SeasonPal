namespace SeasonPal.Domain.Entities.Recipes;

/// <summary>Which users are allowed to view a recipe.</summary>
public enum RecipeVisibility : byte
{
    /// <summary>Visible to everyone.</summary>
    Public,

    /// <summary>Visible only to users following the creator.</summary>
    FollowersOnly,

    /// <summary>Visible only to the creator.</summary>
    Private,
}
