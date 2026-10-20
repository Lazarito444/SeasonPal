using FluentValidation;
using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Collections;

public sealed class CreateCollectionRequestValidator : AbstractValidator<CreateCollectionRequest>
{
    public CreateCollectionRequestValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(Collection.MaxNameLength);

        RuleFor(x => x.Description)
            .MaximumLength(Collection.MaxDescriptionLength);
    }
}

public sealed class UpdateCollectionRequestValidator : AbstractValidator<UpdateCollectionRequest>
{
    public UpdateCollectionRequestValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .MaximumLength(Collection.MaxNameLength);

        RuleFor(x => x.Description)
            .MaximumLength(Collection.MaxDescriptionLength);
    }
}

public sealed class ReorderCollectionRequestValidator : AbstractValidator<ReorderCollectionRequest>
{
    public ReorderCollectionRequestValidator()
    {
        RuleFor(x => x.RecipeIds)
            .NotNull()
            .WithMessage("Send the complete ordered list of recipe ids.");

        RuleFor(x => x.RecipeIds)
            .Must(ids => ids is null || ids.Count <= Collection.MaxItems)
            .WithMessage($"A collection can hold at most {Collection.MaxItems} recipes.");

        RuleFor(x => x.RecipeIds)
            .Must(ids => ids is null || ids.Distinct().Count() == ids.Count)
            .WithMessage("Each recipe id may appear only once.");

        RuleForEach(x => x.RecipeIds)
            .NotEmpty();
    }
}
