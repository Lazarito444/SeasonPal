import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/core/network/api_client.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/features/discovery/domain/discovery_models.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

/// Wire-level discovery reads: the filtered public feed, the home rails and
/// pantry matching. Personalization only changes order, never visibility.
abstract interface class DiscoveryRepository {
  Future<Paged<RecipeSummary>> feed({
    String? query,
    String? cuisine,
    String? diet,
    MealType? mealType,
    RecipeDifficulty? difficulty,
    int? maxTotalTimeMinutes,
    int page = 1,
    int pageSize = 20,
  });

  Future<DiscoveryHome> home();

  Future<Paged<PantryMatch>> pantry({
    required List<String> ingredients,
    int page = 1,
    int pageSize = 20,
  });
}

final class ApiDiscoveryRepository implements DiscoveryRepository {
  const ApiDiscoveryRepository(this._dio);

  final Dio _dio;

  @override
  Future<Paged<RecipeSummary>> feed({
    String? query,
    String? cuisine,
    String? diet,
    MealType? mealType,
    RecipeDifficulty? difficulty,
    int? maxTotalTimeMinutes,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _send(
      () => _dio.get<Object?>(
        '/discovery/feed',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
          if (cuisine != null && cuisine.isNotEmpty) 'cuisine': cuisine,
          if (diet != null && diet.isNotEmpty) 'diet': diet,
          if (mealType != null) 'mealType': mealType.wireValue,
          if (difficulty != null) 'difficulty': difficulty.wireValue,
          'maxTotalTimeMinutes': ?maxTotalTimeMinutes,
        },
      ),
    );

    return Paged<RecipeSummary>.fromJson(
      _map(response.data),
      (json) => RecipeSummary.fromJson(_map(json)),
    );
  }

  @override
  Future<DiscoveryHome> home() async {
    final response = await _send(() => _dio.get<Object?>('/discovery/home'));
    return DiscoveryHome.fromJson(_map(response.data));
  }

  @override
  Future<Paged<PantryMatch>> pantry({
    required List<String> ingredients,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _send(
      () => _dio.get<Object?>(
        '/discovery/pantry',
        queryParameters: {
          'ingredients': ingredients,
          'page': page,
          'pageSize': pageSize,
        },
      ),
    );

    return Paged<PantryMatch>.fromJson(
      _map(response.data),
      (json) => PantryMatch.fromJson(_map(json)),
    );
  }

  Future<Response<T>> _send<T>(Future<Response<T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  static Map<String, dynamic> _map(Object? data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const ApiException(
      message: 'The server returned an unexpected response.',
      code: 'client.unexpected-response',
    );
  }
}

final discoveryRepositoryProvider = Provider<DiscoveryRepository>(
  (ref) => ApiDiscoveryRepository(ref.watch(apiClientProvider).dio),
);
