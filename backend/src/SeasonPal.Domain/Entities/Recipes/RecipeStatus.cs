namespace SeasonPal.Domain.Entities.Recipes;

/// <summary>The lifecycle stage of a recipe.</summary>
public enum RecipeStatus : byte
{
    /// <summary>Still being edited and not visible to others.</summary>
    Draft,

    /// <summary>Finished and available according to its visibility.</summary>
    Published,

    /// <summary>Retired from active use but retained for history.</summary>
    Archived
}
