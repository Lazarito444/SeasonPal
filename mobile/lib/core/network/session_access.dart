/// The API client's view of the signed-in session.
///
/// Keeps `core/network` independent of the auth feature: main.dart wires this
/// to the auth controller, tests can wire it to a stub.
abstract interface class SessionAccess {
  String? get accessToken;

  /// Returns true when a new access token is available.
  Future<bool> refreshSession();
}
