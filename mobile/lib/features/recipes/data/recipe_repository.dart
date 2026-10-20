import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/core/network/api_client.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

/// A file chosen by the user, ready to upload. Keeping the platform picker out
/// of the repository makes the transport testable with any local file.
final class UploadCandidate {
  const UploadCandidate({
    required this.path,
    required this.fileName,
    required this.contentType,
    required this.kind,
  });

  final String path;
  final String fileName;
  final String contentType;
  final MediaKind kind;
}

/// Wire-level recipe, collection and media calls.
abstract interface class RecipeRepository {
  Future<Paged<RecipeSummary>> listOwn({int page = 1, int pageSize = 20});

  Future<Paged<RecipeSummary>> listSaved({int page = 1, int pageSize = 20});

  Future<RecipeDetail> get(String id);

  Future<RecipeDetail> create(RecipeWriteInput input);

  Future<RecipeDetail> update(String id, RecipeWriteInput input);

  Future<void> delete(String id);

  Future<void> save(String id, {String? collectionId});

  Future<void> unsave(String id);

  Future<MediaUpload> upload(UploadCandidate candidate);

  Future<Paged<CollectionSummary>> listCollections({
    int page = 1,
    int pageSize = 50,
  });

  Future<CollectionSummary> createCollection({
    required String name,
    String? description,
  });

  Future<CollectionDetail> getCollection(
    String id, {
    int page = 1,
    int pageSize = 20,
  });

  Future<void> addToCollection(String collectionId, String recipeId);

  Future<void> removeFromCollection(String collectionId, String recipeId);
}

final class ApiRecipeRepository implements RecipeRepository {
  const ApiRecipeRepository(this._dio);

  final Dio _dio;

  @override
  Future<Paged<RecipeSummary>> listOwn({int page = 1, int pageSize = 20}) => _getPaged('/recipes', page, pageSize, RecipeSummary.fromJson);

  @override
  Future<Paged<RecipeSummary>> listSaved({int page = 1, int pageSize = 20}) => _getPaged('/recipes/saved', page, pageSize, RecipeSummary.fromJson);

  @override
  Future<RecipeDetail> get(String id) async {
    final response = await _send(() => _dio.get<Object?>('/recipes/$id'));
    return RecipeDetail.fromJson(_map(response.data));
  }

  @override
  Future<RecipeDetail> create(RecipeWriteInput input) async {
    final response = await _send(
      () => _dio.post<Object?>('/recipes', data: input.toJson()),
    );
    return RecipeDetail.fromJson(_map(response.data));
  }

  @override
  Future<RecipeDetail> update(String id, RecipeWriteInput input) async {
    final response = await _send(
      () => _dio.put<Object?>('/recipes/$id', data: input.toJson()),
    );
    return RecipeDetail.fromJson(_map(response.data));
  }

  @override
  Future<void> delete(String id) async {
    await _send(() => _dio.delete<void>('/recipes/$id'));
  }

  @override
  Future<void> save(String id, {String? collectionId}) async {
    await _send(
      () => _dio.post<void>(
        '/recipes/$id/save',
        queryParameters: {'collectionId': ?collectionId},
      ),
    );
  }

  @override
  Future<void> unsave(String id) async {
    await _send(() => _dio.delete<void>('/recipes/$id/save'));
  }

  @override
  Future<MediaUpload> upload(UploadCandidate candidate) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        candidate.path,
        filename: candidate.fileName,
        contentType: DioMediaType.parse(candidate.contentType),
      ),
    });

    final response = await _send(
      () => _dio.post<Object?>('/media', data: form),
    );
    return MediaUpload.fromJson(_map(response.data));
  }

  @override
  Future<Paged<CollectionSummary>> listCollections({
    int page = 1,
    int pageSize = 50,
  }) => _getPaged('/collections', page, pageSize, CollectionSummary.fromJson);

  @override
  Future<CollectionSummary> createCollection({
    required String name,
    String? description,
  }) async {
    final response = await _send(
      () => _dio.post<Object?>(
        '/collections',
        data: {'name': name, 'description': description},
      ),
    );
    return CollectionSummary.fromJson(_map(response.data));
  }

  @override
  Future<CollectionDetail> getCollection(
    String id, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _send(
      () => _dio.get<Object?>(
        '/collections/$id',
        queryParameters: {'page': page, 'pageSize': pageSize},
      ),
    );
    final map = _map(response.data);
    final recipes = Paged<RecipeSummary>.fromJson(
      _map(map['recipes']),
      (json) => RecipeSummary.fromJson(_map(json)),
    );

    return CollectionDetail(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      isDefaultFavorites: map['isDefaultFavorites'] as bool? ?? false,
      recipeCount: map['recipeCount'] as int? ?? recipes.totalCount,
      createdAt: DateTime.parse(map['createdAt'] as String),
      recipes: recipes,
    );
  }

  @override
  Future<void> addToCollection(String collectionId, String recipeId) async {
    await _send(
      () => _dio.put<void>('/collections/$collectionId/recipes/$recipeId'),
    );
  }

  @override
  Future<void> removeFromCollection(
    String collectionId,
    String recipeId,
  ) async {
    await _send(
      () => _dio.delete<void>('/collections/$collectionId/recipes/$recipeId'),
    );
  }

  Future<Paged<T>> _getPaged<T>(
    String path,
    int page,
    int pageSize,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final response = await _send(
      () => _dio.get<Object?>(
        path,
        queryParameters: {'page': page, 'pageSize': pageSize},
      ),
    );

    return Paged<T>.fromJson(
      _map(response.data),
      (json) => fromJson(_map(json)),
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

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => ApiRecipeRepository(ref.watch(apiClientProvider).dio),
);
