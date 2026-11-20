namespace SeasonPal.Domain.Entities.Recipes;

/// <summary>How demanding a recipe is to prepare.</summary>
public enum RecipeDifficulty : byte
{
    /// <summary>Little to no cooking experience required.</summary>
    Easy,

    /// <summary>Requires some cooking experience.</summary>
    Medium,

    /// <summary>Requires advanced techniques or careful timing.</summary>
    Hard,

    /// <summary>Intended for expert cooks.</summary>
    Expert
}
