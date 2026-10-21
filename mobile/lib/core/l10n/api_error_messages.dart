import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Translates the API failures the client knows about.
///
/// Business errors carry a stable `code` from the backend. Network failures are
/// classified by [ApiFailureKind]. Uncoded HTTP errors fall back to the server's
/// English message so information is not lost.
String localizeApiError(Translations t, ApiException error) => switch (error.code) {
  'auth.invalid-credentials' => t.errors.invalidCredentials,
  'auth.email-taken' => t.errors.emailTaken,
  'auth.refresh-token-invalid' => t.errors.sessionExpired,
  'collection.name-taken' => t.errors.collectionNameTaken,
  'recipe.publish-incomplete' => t.errors.publishIncomplete,
  'client.unexpected-response' => t.errors.generic,
  _ => switch (error.kind) {
    ApiFailureKind.timeout => t.errors.timeout,
    ApiFailureKind.connection => t.errors.connection,
    _ => switch (error.statusCode) {
      null => error.message,
      409 => t.errors.conflict,
      429 => t.errors.rateLimited,
      >= 500 => t.errors.server,
      _ => error.message,
    },
  },
};
