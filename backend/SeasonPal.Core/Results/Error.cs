namespace SeasonPal.Core.Results;

/// <summary>
/// An expected business failure produced by an operation instead of throwing.
/// <see cref="Code"/> identifies the failure for callers to branch on, while
/// <see cref="InternalDescription"/> is for logs and diagnostics only and must never
/// be returned to clients — user-facing text is derived from the code.
/// </summary>
public sealed record Error
{
    /// <summary>Creates an error, rejecting missing codes and descriptions.</summary>
    /// <param name="code">Stable, machine-readable identifier such as <c>auth.invalid_credentials</c>.</param>
    /// <param name="internalDescription">Diagnostic detail intended for logs, never for clients.</param>
    /// <param name="args">Values referenced by the code's message template, in order.</param>
    /// <exception cref="ArgumentException">The code is null, empty or whitespace.</exception>
    /// <exception cref="ArgumentNullException">The description or args are null.</exception>
    public Error(string code, string internalDescription, params object[] args)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(code);
        ArgumentNullException.ThrowIfNull(internalDescription);
        ArgumentNullException.ThrowIfNull(args);

        Code = code;
        InternalDescription = internalDescription;
        Args = args;
    }

    /// <summary>Stable, machine-readable identifier callers branch on, e.g. <c>recipe.not_found</c>.</summary>
    public string Code { get; }

    /// <summary>Diagnostic detail for logs and traces; never surfaced to clients.</summary>
    public string InternalDescription { get; }

    /// <summary>Values the code's message template references, in order.</summary>
    public object[] Args { get; }
}
