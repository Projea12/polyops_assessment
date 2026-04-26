abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error occurred']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

class ConflictFailure extends Failure {
  final String localVersion;
  final String serverVersion;
  const ConflictFailure({
    required this.localVersion,
    required this.serverVersion,
  }) : super('Conflict detected between local and server versions');
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
