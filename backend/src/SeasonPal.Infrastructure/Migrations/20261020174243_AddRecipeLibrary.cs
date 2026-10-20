using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SeasonPal.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddRecipeLibrary : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<List<string>>(
                name: "DietaryTags",
                table: "Recipes",
                type: "text[]",
                nullable: false,
                defaultValueSql: "'{}'::text[]");

            migrationBuilder.AddColumn<int>(
                name: "Order",
                table: "CollectionRecipes",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            // Existing memberships get a stable initial order from their saved timestamps; new
            // rows are ordered by the Collection aggregate.
            migrationBuilder.Sql(
                """
                UPDATE "CollectionRecipes" AS target
                SET "Order" = ranked.position
                FROM (
                    SELECT "CollectionId", "RecipeId",
                           ROW_NUMBER() OVER (PARTITION BY "CollectionId" ORDER BY "AddedAt") AS position
                    FROM "CollectionRecipes"
                ) AS ranked
                WHERE target."CollectionId" = ranked."CollectionId"
                  AND target."RecipeId" = ranked."RecipeId";
                """);

            migrationBuilder.CreateIndex(
                name: "IX_CollectionRecipes_CollectionId_Order",
                table: "CollectionRecipes",
                columns: new[] { "CollectionId", "Order" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_CollectionRecipes_CollectionId_Order",
                table: "CollectionRecipes");

            migrationBuilder.DropColumn(
                name: "DietaryTags",
                table: "Recipes");

            migrationBuilder.DropColumn(
                name: "Order",
                table: "CollectionRecipes");
        }
    }
}
