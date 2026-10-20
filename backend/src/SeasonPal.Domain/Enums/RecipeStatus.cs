namespace SeasonPal.Domain.Enums;

/// <summary>Lifecycle; community publishing UI lands at Stage 10 but the state already exists.</summary>
public enum RecipeStatus
{
    Draft = 0,
    Published = 1,
    Archived = 2,
}
