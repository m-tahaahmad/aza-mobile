import 'dart:convert';

class ParsedApiError {
  final String message;
  final String? code;
  final String? reason;

  const ParsedApiError({
    required this.message,
    this.code,
    this.reason,
  });
}

class ApiErrorParser {
  static ParsedApiError parse(dynamic body) {
    if (body == null) {
      return const ParsedApiError(message: 'Request failed');
    }

    Map<String, dynamic>? json;
    if (body is Map<String, dynamic>) {
      json = body;
    } else if (body is String && body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          json = decoded;
        }
      } catch (_) {
        return ParsedApiError(message: body);
      }
    }

    if (json == null) {
      return ParsedApiError(message: body.toString());
    }

    final error = json['error'];
    if (error is Map<String, dynamic>) {
      return ParsedApiError(
        message: error['message']?.toString() ?? 'Request failed',
        code: error['code']?.toString(),
        reason: error['reason']?.toString(),
      );
    }

    if (json['message'] != null) {
      return ParsedApiError(
        message: json['message'].toString(),
        code: json['code']?.toString(),
        reason: json['reason']?.toString(),
      );
    }

    return const ParsedApiError(message: 'Request failed');
  }
}
