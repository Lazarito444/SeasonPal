import 'package:dio/dio.dart';

/// A user-presentable API failure.
///
/// Parses ProblemDetails from the backend so screens show the API's English
/// fallback while keeping the machine-readable `code` for future localization.
final class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.fieldErrors = const {},
  });

  factory ApiException.fromDio(DioException error) {
    final response = error.response;
    final data = response?.data;
    var message = _fallbackMessage(response?.statusCode, error.type);
    String? code;
    var fieldErrors = const <String, List<String>>{};

    if (data is Map) {
      final title = data['title'];
      if (title is String && title.trim().isNotEmpty) {
        message = title;
      }

      final rawCode = data['code'];
      if (rawCode is String && rawCode.isNotEmpty) {
        code = rawCode;
      }

      final errors = data['errors'];
      if (errors is Map) {
        fieldErrors = {
          for (final entry in errors.entries)
            entry.key.toString(): _messages(entry.value),
        };
      }
    }

    return ApiException(
      message: message,
      statusCode: response?.statusCode,
      code: code,
      fieldErrors: fieldErrors,
    );
  }

  final String message;
  final int? statusCode;
  final String? code;
  final Map<String, List<String>> fieldErrors;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;

  static List<String> _messages(Object? value) => switch (value) {
    final List<dynamic> values =>
      values.map((item) => item.toString()).toList(growable: false),
    final Object item => [item.toString()],
    _ => const [],
  };

  static String _fallbackMessage(int? statusCode, DioExceptionType type) {
    if (statusCode != null) {
      return switch (statusCode) {
        401 => 'Your session has expired. Sign in again.',
        409 => 'That account already exists.',
        429 => 'Too many attempts. Wait a moment and try again.',
        >= 500 => 'Something went wrong on our side. Try again.',
        _ => 'Something went wrong. Try again.',
      };
    }

    return switch (type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout =>
        'The kitchen is taking too long to answer. Try again.',
      DioExceptionType.connectionError =>
        'Could not reach SeasonPal. Check your connection and try again.',
      _ => 'Something went wrong. Try again.',
    };
  }
}
