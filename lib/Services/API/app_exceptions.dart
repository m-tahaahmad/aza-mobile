class AppException implements Exception {
  final dynamic _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  /// Parsed user-facing message without the legacy prefix.
  String get message {
    final raw = _message?.toString().trim();
    if (raw == null || raw.isEmpty) return 'Request failed';
    return raw;
  }

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException([message]) : super(message, "Request Timeout");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class RequestNotFoundException extends AppException {
  RequestNotFoundException([message]) : super(message, "Request Not Found");
}

class UnautorizationException extends AppException {
  final String? code;

  UnautorizationException(super.message, {this.code});
}

class InternalServerException extends AppException {
  InternalServerException([message]) : super(message, "Internal Server Error");
}

class ServerNotFoundException extends AppException {
  ServerNotFoundException([message]) : super(message, "Server Not Found");
}
