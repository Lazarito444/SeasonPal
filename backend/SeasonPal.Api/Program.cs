using SeasonPal.Api.Extensions;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.Services.AddSeasonPalServices();

WebApplication app = builder.Build();

app.MapSeasonPalDocumentation();

app.UseHttpsRedirection();

app.Run();
