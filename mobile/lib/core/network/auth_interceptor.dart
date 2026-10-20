import 'package:dio/dio.dart';

/// Reads the current access token and refreshes the session when it expired.
typedef AccessTokenReader = String? Function();

typedef SessionRefresher = Future<bool> Function();

/// Attaches the access token and transparently retries once after a 401.
///
/// Refreshing is serialized by [QueuedInterceptor]; if a queued request already
/// has a newer token than the one it failed with, it retries without refreshing
/// again.
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.dio,
    required this.accessToken,
    required this.refreshSession,
  });

  final Dio dio;
  final AccessTokenReader accessToken;
  final SessionRefresher refreshSession;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _applyToken(options);
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra['authRetried'] == true) {
      handler.next(err);
      return;
    }

    final attempted = err.requestOptions.headers['Authorization'];
    final current = accessToken();
    final needsRefresh =
        current == null || attempted == null || attempted != 'Bearer $current';

    if (needsRefresh && !await refreshSession()) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions..extra['authRetried'] = true;
    _applyToken(options);

    try {
      handler.resolve(await dio.fetch<Object?>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  void _applyToken(RequestOptions options) {
    final token = accessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
  }
}
