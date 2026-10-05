import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:icms_app/Services/AuthServices/token_storage.dart';
import 'package:icms_app/constants/globals.dart';

enum ClientErrorKind { network, timeout, http, client }

class LastApiCall {
  LastApiCall({
    required this.method,
    required this.url,
    required this.endpoint,
    required this.status,
    required this.durationMs,
    required this.at,
    this.body,
    this.traceId,
    this.httpCode,
    this.originalMessage,
    this.reported = false,
  });

  final String method;
  final String url;
  final String endpoint;
  final int status;
  final int durationMs;
  final DateTime at;
  final String? body;
  final String? traceId;
  final String? httpCode;
  final String? originalMessage;
  bool reported;

  bool get isRecent => DateTime.now().difference(at) < const Duration(seconds: 15);
}

class ClientErrorReporter {
  static const ingestPath = 'apm/client-errors';
  static const _debounce = Duration(seconds: 5);

  static LastApiCall? lastCall;
  static DateTime? _lastSentAt;
  static String? _lastSentKey;

  static bool isIngestEndpoint(String endpoint) {
    final normalized = endpoint.split('?').first.replaceAll(RegExp(r'^/+|/+$'), '');
    return normalized == ingestPath || normalized.endsWith('/$ingestPath');
  }

  static void record({
    required String method,
    required String url,
    required String endpoint,
    required int status,
    required int durationMs,
    String? body,
    String? traceId,
    String? httpCode,
    String? originalMessage,
  }) {
    if (isIngestEndpoint(endpoint) || url.contains(ingestPath)) return;

    lastCall = LastApiCall(
      method: method.toUpperCase(),
      url: url,
      endpoint: endpoint,
      status: status,
      durationMs: durationMs,
      at: DateTime.now(),
      body: _truncate(body),
      traceId: traceId,
      httpCode: httpCode,
      originalMessage: originalMessage,
    );
  }

  static void report({
    required ClientErrorKind kind,
    required String userVisibleMessage,
    String? originalMessage,
    String? httpCode,
    String? exceptionClass,
    String? stackTrace,
  }) {
    final call = lastCall;
    if (call != null && (isIngestEndpoint(call.endpoint) || call.url.contains(ingestPath))) {
      return;
    }

    final url = call?.url ?? '';
    if (!_shouldSend(kind, url)) return;

    call?.reported = true;

    final payload = <String, dynamic>{
      'source': 'mobile',
      'kind': kind.name,
      'message': userVisibleMessage,
      'original_message': originalMessage ?? call?.originalMessage,
      'method': call?.method ?? 'GET',
      'path': url,
      'status': call?.status ?? 0,
      'duration_ms': call?.durationMs ?? 0,
      'online': true,
      'http_code': httpCode ?? call?.httpCode,
      'response_body': call?.body,
      'trace_id': call?.traceId,
      'exception_class': exceptionClass ?? _exceptionClass(kind),
      if (stackTrace != null && stackTrace.isNotEmpty) 'stack_trace': stackTrace,
    };

    unawaited(_post(payload));
  }

  static void reportUserVisible(String message) {
    final call = lastCall;
    if (call != null && call.reported && call.isRecent) return;

    report(
      kind: ClientErrorKind.client,
      userVisibleMessage: message,
      originalMessage: call?.originalMessage,
      exceptionClass: 'Mobile.SomethingWentWrong',
    );
  }

  static bool _shouldSend(ClientErrorKind kind, String url) {
    final key = '${kind.name}|$url';
    final now = DateTime.now();
    if (_lastSentKey == key && _lastSentAt != null && now.difference(_lastSentAt!) < _debounce) {
      return false;
    }
    _lastSentKey = key;
    _lastSentAt = now;
    return true;
  }

  static String _exceptionClass(ClientErrorKind kind) {
    switch (kind) {
      case ClientErrorKind.network:
        return 'Mobile.NetworkError';
      case ClientErrorKind.timeout:
        return 'Mobile.Timeout';
      case ClientErrorKind.http:
        return 'Mobile.HttpError';
      case ClientErrorKind.client:
        return 'Mobile.SomethingWentWrong';
    }
  }

  static String? _truncate(String? body) {
    if (body == null) return null;
    if (body.length <= 4000) return body;
    return '${body.substring(0, 4000)}...[truncated]';
  }

  static Future<void> _post(Map<String, dynamic> payload) async {
    if (baseUrl.isEmpty) return;

    try {
      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-type': 'application/json',
      };
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      await http
          .post(
            Uri.parse('$baseUrl$ingestPath'),
            headers: headers,
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('APM client error ingest skipped: $e');
      }
    }
  }
}
