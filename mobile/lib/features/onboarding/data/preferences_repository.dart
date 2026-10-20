import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../domain/user_preferences.dart';

abstract interface class PreferencesRepository {
  Future<UserPreferences> fetch();

  Future<UserPreferences> save(UserPreferences preferences);
}

final class ApiPreferencesRepository implements PreferencesRepository {
  const ApiPreferencesRepository(this._dio);

  final Dio _dio;

  @override
  Future<UserPreferences> fetch() async {
    try {
      final response = await _dio.get<Object?>('/me/preferences');
      return _parse(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  @override
  Future<UserPreferences> save(UserPreferences preferences) async {
    try {
      final response = await _dio.put<Object?>(
        '/me/preferences',
        data: {
          'favoriteCuisines': preferences.favoriteCuisines,
          'dietaryRestrictions': preferences.dietaryRestrictions,
          'skillLevel': preferences.skillLevel.wireValue,
          'usualCookTimeMinutes': preferences.usualCookTimeMinutes,
          'interests': preferences.interests,
          'onboardingCompleted': preferences.onboardingCompleted,
        },
      );
      return _parse(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  UserPreferences _parse(Object? data) {
    if (data is! Map<String, dynamic>) {
      throw const ApiException(
        message: 'The server returned an unexpected response.',
        code: 'client.unexpected-response',
      );
    }

    return UserPreferences.fromJson(data);
  }
}

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => ApiPreferencesRepository(ref.watch(apiClientProvider).dio),
);

/// Home reads this for the preference-derived greeting and summary.
final myPreferencesProvider = FutureProvider.autoDispose<UserPreferences>(
  (ref) => ref.watch(preferencesRepositoryProvider).fetch(),
);
