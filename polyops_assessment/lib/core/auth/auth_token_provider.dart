import 'package:injectable/injectable.dart';

/// Provides the Bearer token injected into every API and WebSocket request.
/// In production this would read from secure storage; here we use a mock token.
@lazySingleton
class AuthTokenProvider {
  static const _mockToken = 'mock_bearer_token_swamp_kyc';

  String get token => _mockToken;

  String get bearerHeader => 'Bearer $token';
}
