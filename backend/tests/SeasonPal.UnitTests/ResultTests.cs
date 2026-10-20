using SeasonPal.Domain.Common;

namespace SeasonPal.UnitTests;

public class ResultTests
{
    [Fact]
    public void Ok_result_exposes_payload_and_reports_success()
    {
        var result = Result<int>.Ok(4);

        Assert.True(result.IsSuccess);
        Assert.Equal(4, result.Value);
        Assert.Null(result.Error);
    }

    [Fact]
    public void Value_of_failed_result_throws()
    {
        var result = Result<int>.Fail(ApplicationError.Of("recipe.not-found", "Recipe not found."));

        Assert.False(result.IsSuccess);
        Assert.Throws<InvalidOperationException>(() => result.Value);
    }

    [Fact]
    public void Match_routes_to_the_expected_branch_on_both_paths()
    {
        var okOutcome = Result<int>.Ok(7).Match(v => v * 2, _ => -1);
        var failOutcome = Result<int>
            .Fail(ApplicationError.Of("pantry.has-no-items", "Pantry is empty."))
            .Match(_ => -1, error => error.Code.Length);

        Assert.Equal(14, okOutcome);
        Assert.Equal("pantry.has-no-items".Length, failOutcome);
    }

    [Fact]
    public void Bind_short_circuits_on_failure()
    {
        var binderRan = false;
        var result = Result<int>
            .Fail(ApplicationError.Of("collection.not-found", "Collection not found."))
            .Bind(_ =>
            {
                binderRan = true;
                return Result<int>.Ok(1);
            });

        Assert.False(binderRan);
        Assert.False(result.IsSuccess);
        Assert.Equal("collection.not-found", result.Error!.Code);
    }

    [Fact]
    public void Map_transforms_payload_and_passes_errors_through()
    {
        var mapped = Result<double>.Ok(2.5).Map(v => v * 2);
        var failed = Result<double>
            .Fail(ApplicationError.Of("rating.out-of-range", "Stars must be 1–5."))
            .Map(_ => 1.0);

        Assert.Equal(5.0, mapped.Value);
        Assert.False(failed.IsSuccess);
        Assert.Equal("rating.out-of-range", failed.Error!.Code);
    }

    [Fact]
    public void Implicit_conversion_wraps_a_payload()
    {
        Result<string> result = "lemon zest";

        Assert.True(result.IsSuccess);
        Assert.Equal("lemon zest", result.Value);
    }

    [Fact]
    public void ApplicationError_of_collects_interpolation_args()
    {
        var error = ApplicationError.Of(
            "recipe.serves-too-many",
            "Servings cannot exceed {max}.",
            ("max", "50"));

        Assert.Equal("recipe.serves-too-many", error.Code);
        Assert.Equal("Servings cannot exceed {max}.", error.FallbackMessage);
        Assert.Equal("50", error.Args["max"]);
    }

    [Fact]
    public void Unit_result_carries_business_errors_cleanly()
    {
        var ok = Result.Ok();
        var failed = Result.Fail(ApplicationError.Of("auth.forbidden", "Not allowed."));

        Assert.True(ok.IsSuccess);
        Assert.Equal("auth.forbidden", failed.Match(() => "", error => error.Code));
    }
}
