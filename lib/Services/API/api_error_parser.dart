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
  static const blockedMessage = 'Request blocked. Please try again.';
  static const unreadableMessage = 'Something went wrong';

  static final RegExp _htmlTag = RegExp(r'<\s*/?\s*[a-zA-Z][^>]*>');

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
        return ParsedApiError(message: messageForUnstructuredBody(body));
      }
    }

    if (json == null) {
      return ParsedApiError(message: messageForUnstructuredBody(body.toString()));
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

  /// User-facing text, including a block reason when the API sends one.
  static String displayMessage(ParsedApiError parsed) {
    final reason = parsed.reason?.trim();
    if (reason == null || reason.isEmpty) return parsed.message;
    return '${parsed.message} Reason: $reason';
  }

  /// Replaces HTML (including gateway bot-check pages) with a short message.
  /// Plain text is left unchanged so snackbars can still show API errors.
  static String sanitizeForDisplay(String message) {
    if (!looksLikeHtml(message)) return message;
    return looksLikeBotChallenge(message) ? blockedMessage : unreadableMessage;
  }

  static String messageForUnstructuredBody(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return 'Request failed';
    if (looksLikeHtml(trimmed)) return sanitizeForDisplay(trimmed);
    if (trimmed.length <= 200) return trimmed;
    return unreadableMessage;
  }

  static bool looksLikeHtml(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('<!doctype') ||
        lower.contains('<html') ||
        lower.contains('<head') ||
        lower.contains('<body')) {
      return true;
    }
    return _htmlTag.hasMatch(value);
  }

  static bool looksLikeBotChallenge(String value) {
    final lower = value.toLowerCase();
    return lower.contains('recaptcha') ||
        lower.contains('bot verification') ||
        lower.contains('cf-challenge');
  }
}
