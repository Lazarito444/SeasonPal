using System.Security.Claims;
using Microsoft.IdentityModel.JsonWebTokens;

namespace SeasonPal.Api.Common;

internal static class ClaimsPrincipalExtensions
{
    extension(ClaimsPrincipal principal)
    {
        /// <summary>
        /// Reads the authenticated user id from the JWT <c>sub</c> claim. Token validation disables
        /// inbound claim mapping, so the raw JWT claim name is the one to look up.
        /// </summary>
        public Guid? GetUserId() =>
            Guid.TryParse(principal.FindFirstValue(JwtRegisteredClaimNames.Sub), out var userId)
                ? userId
                : null;
    }
}
