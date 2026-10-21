import 'package:flutter_test/flutter_test.dart';
import 'package:seasonpal/features/auth/domain/auth_session.dart';
import 'package:seasonpal/features/discovery/domain/discovery_models.dart';
import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

void main() {
  group('auth models', () {
    test('parses a session and its user', () {
      final session = AuthSession.fromJson({
        'accessToken': 'access',
        'accessTokenExpiresAt': '2026-10-20T13:00:00Z',
        'refreshToken': 'refresh',
        'refreshTokenExpiresAt': '2026-11-19T13:00:00Z',
        'user': {
          'id': 'user-1',
          'email': 'ava@seasonpal.test',
          'displayName': 'Ava Stone',
          'onboardingCompleted': true,
        },
      });

      expect(session.accessToken, 'access');
      expect(session.accessTokenExpiresAt, DateTime.utc(2026, 10, 20, 13));
      expect(session.user.id, 'user-1');
      expect(session.user.onboardingCompleted, isTrue);

      final updated = session.copyWith(
        user: session.user.copyWith(displayName: 'Ava'),
      );
      expect(updated.user.displayName, 'Ava');
      expect(session.user.displayName, 'Ava Stone');
    });
  });

  group('user preferences', () {
    test('applies defaults for missing optional values', () {
      final preferences = UserPreferences.fromJson(const {});

      expect(preferences.favoriteCuisines, isEmpty);
      expect(preferences.dietaryRestrictions, isEmpty);
      expect(preferences.skillLevel, SkillLevel.beginner);
      expect(preferences.usualCookTimeMinutes, isNull);
      expect(preferences.interests, isEmpty);
      expect(preferences.onboardingCompleted, isFalse);
      expect(preferences.completedAt, isNull);
    });

    test('parses server values', () {
      final preferences = UserPreferences.fromJson({
        'favoriteCuisines': ['Italian'],
        'dietaryRestrictions': ['Vegetarian'],
        'skillLevel': 2,
        'usualCookTimeMinutes': 30,
        'interests': ['Baking'],
        'onboardingCompleted': true,
        'completedAt': '2026-10-20T13:00:00Z',
      });

      expect(preferences.favoriteCuisines, ['Italian']);
      expect(preferences.skillLevel, SkillLevel.advanced);
      expect(preferences.usualCookTimeMinutes, 30);
      expect(preferences.completedAt, DateTime.utc(2026, 10, 20, 13));
    });
  });

  group('recipe models', () {
    test('parses a paged response', () {
      final page = Paged<RecipeAuthor>.fromJson({
        'items': [
          {'id': 'author-1', 'displayName': 'Ava Stone'},
        ],
        'page': 2,
        'pageSize': 20,
        'totalCount': 41,
      }, (json) => RecipeAuthor.fromJson(json as Map<String, dynamic>));

      expect(page.items.single.displayName, 'Ava Stone');
      expect(page.page, 2);
      expect(page.hasNextPage, isTrue);
    });

    test('parses a recipe detail with its children', () {
      final recipe = RecipeDetail.fromJson({
        'id': 'recipe-1',
        'author': {'id': 'author-1', 'displayName': 'Ava Stone'},
        'title': 'Lemon pasta',
        'description': 'Bright and quick.',
        'cuisine': 'Italian',
        'coverImageUrl': '/media/recipe-1.jpg',
        'mealType': 3,
        'servings': 4,
        'prepTimeMinutes': 10,
        'cookTimeMinutes': 15,
        'totalTimeMinutes': 25,
        'difficulty': 1,
        'visibility': 0,
        'status': 0,
        'isAiGenerated': false,
        'sourceRecipeId': null,
        'tags': ['weeknight'],
        'dietaryTags': ['Vegetarian'],
        'ingredients': [
          {
            'id': 'ingredient-1',
            'order': 1,
            'quantity': 200,
            'unit': 'g',
            'name': 'Spaghetti',
            'note': null,
          },
        ],
        'steps': [
          {
            'id': 'step-1',
            'order': 1,
            'instruction': 'Boil the pasta.',
            'tip': null,
            'timerSeconds': 540,
          },
        ],
        'media': [
          {
            'id': 'media-1',
            'order': 1,
            'url': '/media/recipe-1.jpg',
            'kind': 0,
            'altText': 'Lemon pasta',
          },
        ],
        'isSaved': true,
        'createdAt': '2026-10-19T13:00:00Z',
        'updatedAt': '2026-10-20T13:00:00Z',
      });

      expect(recipe.author.displayName, 'Ava Stone');
      expect(recipe.mealType, MealType.dinner);
      expect(recipe.difficulty, RecipeDifficulty.medium);
      expect(recipe.ingredients.single.quantity, 200);
      expect(recipe.steps.single.timerSeconds, 540);
      expect(recipe.media.single.kind, MediaKind.image);
      expect(recipe.isSaved, isTrue);
      expect(recipe.updatedAt, DateTime.utc(2026, 10, 20, 13));
    });
  });

  group('discovery models', () {
    test('parses the home rails and taste flag', () {
      final home = DiscoveryHome.fromJson({
        'trending': [_summaryJson('trend-1')],
        'newest': [_summaryJson('new-1')],
        'recommended': const [],
        'hasTasteProfile': true,
      });

      expect(home.trending.single.id, 'trend-1');
      expect(home.newest.single.title, 'Lemon orzo');
      expect(home.recommended, isEmpty);
      expect(home.hasTasteProfile, isTrue);
      expect(home.isEmpty, isFalse);
    });

    test('parses a pantry match with its coverage', () {
      final match = PantryMatch.fromJson({
        'recipe': _summaryJson('pantry-1'),
        'matchedCount': 2,
        'missingCount': 1,
        'matchedIngredients': ['lemon', 'orzo'],
        'missingIngredients': ['spinach'],
        'matchPercent': 67,
        'canCook': false,
      });

      expect(match.recipe.id, 'pantry-1');
      expect(match.matchedIngredients, ['lemon', 'orzo']);
      expect(match.missingIngredients, ['spinach']);
      expect(match.matchPercent, 67);
      expect(match.consideredCount, 3);
      expect(match.canCook, isFalse);
    });
  });
}

Map<String, dynamic> _summaryJson(String id) => {
  'id': id,
  'title': 'Lemon orzo',
  'description': 'Bright and quick.',
  'cuisine': 'Mediterranean',
  'coverImageUrl': null,
  'mealType': 3,
  'servings': 2,
  'prepTimeMinutes': 10,
  'cookTimeMinutes': 15,
  'totalTimeMinutes': 25,
  'difficulty': 1,
  'visibility': 1,
  'status': 1,
  'isAiGenerated': false,
  'tags': ['weeknight'],
  'dietaryTags': ['Vegetarian'],
  'authorId': 'author-1',
  'authorDisplayName': 'Ava Stone',
  'savedAt': null,
  'updatedAt': '2026-10-20T13:00:00Z',
};
