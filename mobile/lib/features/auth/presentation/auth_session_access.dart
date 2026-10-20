import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/session_access.dart';
import 'auth_controller.dart';

/// Adapts the auth controller to the API client's session contract. Wired in
/// main.dart via `sessionAccessProvider.overrideWith(AuthSessionAccess.new)`.
final class AuthSessionAccess implements SessionAccess {
  const AuthSessionAccess(this._ref);

  final Ref _ref;

  @override
  String? get accessToken =>
      _ref.read(authControllerProvider).value?.accessToken;

  @override
  Future<bool> refreshSession() =>
      _ref.read(authControllerProvider.notifier).refreshSession();
}
