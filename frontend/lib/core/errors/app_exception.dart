sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

class InvalidIdException extends AppException {
  const InvalidIdException(super.message);
}

class ConnectionAppException extends AppException {
  const ConnectionAppException(super.message);
}

class TimeoutAppException extends AppException {
  const TimeoutAppException(super.message);
}

class HttpAppException extends AppException {
  const HttpAppException(super.message, this.statusCode);
  final int statusCode;
}

class InvalidResponseException extends AppException {
  const InvalidResponseException(super.message);
}
