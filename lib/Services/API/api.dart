import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:icms_app/Services/AuthServices/auth_session_service.dart';
import 'package:icms_app/Services/AuthServices/refresh_token_service.dart';
import 'package:icms_app/Services/AuthServices/token_storage.dart';
import '../../constants/api_error_codes.dart';
import '../../constants/globals.dart';
import 'api_error_parser.dart';
import 'app_exceptions.dart';
import 'client_error_reporter.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

enum _HttpMethod { get, post, put, delete }

class _AuthRequest {
  final _HttpMethod method;
  final String endpoint;
  final dynamic body;
  final bool sendToken;
  final String? jsonBody;
  bool retried;

  _AuthRequest({
    required this.method,
    required this.endpoint,
    this.body,
    this.sendToken = true,
    this.jsonBody,
    this.retried = false,
  });

  _AuthRequest copyWithRetried() {
    return _AuthRequest(
      method: method,
      endpoint: endpoint,
      body: body,
      sendToken: sendToken,
      jsonBody: jsonBody,
      retried: true,
    );
  }
}

class Api {
  static const List<String> _noRefreshPaths = ['login', 'refresh'];
  static bool _isRefreshing = false;
  static final List<Completer<String>> _refreshWaiters = [];
  static final RefreshTokenService _refreshTokenService = RefreshTokenService();
  static final Dio _uploadDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    ),
  );

  static bool _isAuthEndpoint(String endpoint) {
    final normalized = endpoint.split('?').first;
    return _noRefreshPaths.any((path) => normalized == path || normalized.endsWith('/$path'));
  }

  static Future<dynamic> getPublicRequestData(String apiEndPoint) async {
    final request = _AuthRequest(method: _HttpMethod.get, endpoint: apiEndPoint, sendToken: false);
    final started = DateTime.now();
    try {
      final response = await _sendRequest(request);
      _recordCall(
        request,
        status: response.statusCode,
        started: started,
        body: response.body,
        traceId: response.headers['x-trace-id'],
      );
      return _parseSuccessResponse(response);
    } on SocketException catch (e) {
      _reportTransport(request, started, ClientErrorKind.network, 'No internet connection', e);
      throw FetchDataException('No internet connection');
    } on HandshakeException catch (e) {
      _reportTransport(request, started, ClientErrorKind.network, 'Could not connect to server', e);
      throw FetchDataException('Could not connect to server');
    } on HttpException catch (e) {
      _reportTransport(request, started, ClientErrorKind.network, 'Could not connect to server', e);
      throw FetchDataException('Could not connect to server');
    } on http.ClientException catch (e) {
      _reportTransport(request, started, ClientErrorKind.network, 'Could not connect to server', e);
      throw FetchDataException('Could not connect to server');
    } on TimeoutException catch (e) {
      _reportTransport(request, started, ClientErrorKind.timeout, 'Request timed out', e);
      throw RequestTimeOutException('Request timed out');
    }
  }

  static Future<dynamic> getRequestData(String apiEndPoint, BuildContext context) async {
    return _execute(_AuthRequest(method: _HttpMethod.get, endpoint: apiEndPoint), context);
  }

  static Future<dynamic> postRequestData(
    String apiEndPoint,
    Map<String, dynamic> body,
    BuildContext context, {
    bool sendToken = false,
    String? jsonBody,
  }) async {
    return _execute(
      _AuthRequest(
        method: _HttpMethod.post,
        endpoint: apiEndPoint,
        body: body,
        sendToken: sendToken,
        jsonBody: jsonBody,
      ),
      context,
    );
  }

  static Future<dynamic> putRequestData(
    String apiEndPoint,
    dynamic body,
    BuildContext context, {
    bool sendToken = false,
  }) async {
    return _execute(
      _AuthRequest(
        method: _HttpMethod.put,
        endpoint: apiEndPoint,
        body: body,
        sendToken: sendToken,
      ),
      context,
    );
  }

  static Future<dynamic> deleteRequestData(
    String apiEndPoint,
    BuildContext context, {
    bool sendToken = false,
  }) async {
    return _execute(
      _AuthRequest(
        method: _HttpMethod.delete,
        endpoint: apiEndPoint,
        sendToken: sendToken,
      ),
      context,
    );
  }

  static Future<dynamic> _execute(_AuthRequest request, BuildContext? context) async {
    final started = DateTime.now();
    try {
      final response = await _sendRequest(request);
      if (context != null && !context.mounted) {
        return await _handleResponse(response, request, null, started);
      }
      return await _handleResponse(response, request, context, started);
    } on SocketException catch (e) {
      _reportTransport(request, started, ClientErrorKind.network, 'No internet connection', e);
      throw FetchDataException('No internet connection');
    } on HandshakeException catch (e) {
      _reportTransport(request, started, ClientErrorKind.network, 'Could not connect to server', e);
      throw FetchDataException('Could not connect to server');
    } on HttpException catch (e) {
      _reportTransport(request, started, ClientErrorKind.network, 'Could not connect to server', e);
      throw FetchDataException('Could not connect to server');
    } on http.ClientException catch (e) {
      _reportTransport(request, started, ClientErrorKind.network, 'Could not connect to server', e);
      throw FetchDataException('Could not connect to server');
    } on TimeoutException catch (e) {
      _reportTransport(request, started, ClientErrorKind.timeout, 'Request timed out', e);
      throw RequestTimeOutException('Request timed out');
    }
  }

  static Future<http.Response> _sendRequest(_AuthRequest request, {String? accessTokenOverride}) async {
    final apiAddress = baseUrl + request.endpoint;
    if (kDebugMode) {
      debugPrint('URL: $apiAddress');
    }

    final headers = <String, String>{'Content-type': 'application/json'};
    if (request.sendToken) {
      final token = accessTokenOverride ?? await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final timeout = const Duration(seconds: 60);
    switch (request.method) {
      case _HttpMethod.get:
        return http.get(Uri.parse(apiAddress), headers: headers).timeout(
              timeout,
              onTimeout: () => http.Response('Error', 408),
            );
      case _HttpMethod.post:
        return http
            .post(
              Uri.parse(apiAddress),
              body: request.jsonBody ?? jsonEncode(request.body ?? {}),
              headers: headers,
            )
            .timeout(timeout, onTimeout: () => http.Response('Error', 408));
      case _HttpMethod.put:
        return http
            .put(
              Uri.parse(apiAddress),
              body: jsonEncode(request.body ?? {}),
              headers: headers,
            )
            .timeout(timeout, onTimeout: () => http.Response('Error', 408));
      case _HttpMethod.delete:
        return http.delete(Uri.parse(apiAddress), headers: headers).timeout(
              timeout,
              onTimeout: () => http.Response('Error', 408),
            );
    }
  }

  static Future<dynamic> _handleResponse(
    http.Response response,
    _AuthRequest request,
    BuildContext? context,
    DateTime started,
  ) async {
    if (kDebugMode) {
      debugPrint('StatusCode: ${response.statusCode}');
    }

    _recordCall(
      request,
      status: response.statusCode,
      started: started,
      body: response.body,
      traceId: response.headers['x-trace-id'],
    );

    if (response.statusCode == 401 &&
        request.sendToken &&
        !_isAuthEndpoint(request.endpoint)) {
      if (request.retried) {
        await AuthSessionService.forceLogout();
        final parsed = ApiErrorParser.parse(response.body);
        throw UnauthorisedException(parsed.message);
      }

      final newAccessToken = await _refreshAccessToken();
      final retryResponse = await _sendRequest(request.copyWithRetried(), accessTokenOverride: newAccessToken);
      if (context != null && !context.mounted) {
        return _handleResponse(retryResponse, request.copyWithRetried(), null, started);
      }
      return _handleResponse(retryResponse, request.copyWithRetried(), context, started);
    }

    if (response.statusCode == 403) {
      await _handleForbidden(response, request.endpoint);
    }

    return _parseSuccessResponse(response);
  }

  static Future<void> _handleForbidden(http.Response response, String endpoint) async {
    final parsed = ApiErrorParser.parse(response.body);
    final shouldLogout = !_isAuthEndpoint(endpoint) && ApiErrorCodes.isAccessDenied(parsed.code);

    if (shouldLogout) {
      await AuthSessionService.forceLogout(message: parsed.message);
    }

    throw UnautorizationException(parsed.message, code: parsed.code);
  }

  static Future<void> _handleForbiddenFromBody(dynamic body, String endpoint) async {
    final parsed = ApiErrorParser.parse(body);
    final shouldLogout = !_isAuthEndpoint(endpoint) && ApiErrorCodes.isAccessDenied(parsed.code);

    if (shouldLogout) {
      await AuthSessionService.forceLogout(message: parsed.message);
    }

    throw UnautorizationException(parsed.message, code: parsed.code);
  }

  static Future<String> _refreshAccessToken() async {
    if (_isRefreshing) {
      final completer = Completer<String>();
      _refreshWaiters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await AuthSessionService.forceLogout();
        throw UnauthorisedException('No refresh token available');
      }

      final result = await _refreshTokenService.refresh(refreshToken);
      await TokenStorage.setTokens(
        result.accessToken,
        refreshToken: result.refreshToken ?? refreshToken,
      );

      for (final waiter in _refreshWaiters) {
        if (!waiter.isCompleted) {
          waiter.complete(result.accessToken);
        }
      }
      _refreshWaiters.clear();

      return result.accessToken;
    } on RefreshTokenException catch (e) {
      for (final waiter in _refreshWaiters) {
        if (!waiter.isCompleted) {
          waiter.completeError(e);
        }
      }
      _refreshWaiters.clear();
      final message = ApiErrorCodes.isAccessDenied(e.code) ? e.message : e.toString();
      await AuthSessionService.forceLogout(message: message);
      throw UnauthorisedException(message);
    } catch (e) {
      for (final waiter in _refreshWaiters) {
        if (!waiter.isCompleted) {
          waiter.completeError(e);
        }
      }
      _refreshWaiters.clear();
      await AuthSessionService.forceLogout();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  static dynamic _parseSuccessResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          return json.decode(response.body.toString());
        } catch (e) {
          _reportRecorded(ClientErrorKind.http, 'Invalid JSON response', e.toString());
          rethrow;
        }
      case 400:
        final parsed = ApiErrorParser.parse(response.body);
        throw BadRequestException(parsed.message);
      case 401:
        final parsed = ApiErrorParser.parse(response.body);
        throw UnauthorisedException(parsed.message);
      case 404:
        final parsed = ApiErrorParser.parse(response.body);
        throw RequestNotFoundException(parsed.message);
      case 403:
        final parsed = ApiErrorParser.parse(response.body);
        throw UnautorizationException(parsed.message, code: parsed.code);
      case 408:
        _reportRecorded(ClientErrorKind.timeout, 'Request timed out', 'Request timed out');
        throw RequestTimeOutException('Request timed out');
      case 422:
        final parsed = ApiErrorParser.parse(response.body);
        throw BadRequestException(parsed.message);
      case 500:
        final parsed = ApiErrorParser.parse(response.body);
        _reportRecorded(ClientErrorKind.http, parsed.message, parsed.message, httpCode: '500');
        throw InternalServerException(parsed.message);
      case 503:
        final parsed = ApiErrorParser.parse(response.body);
        _reportRecorded(ClientErrorKind.http, parsed.message, parsed.message, httpCode: '503');
        throw ServerNotFoundException(parsed.message);
      default:
        final message =
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}';
        _reportRecorded(ClientErrorKind.http, message, message, httpCode: '${response.statusCode}');
        throw FetchDataException(message);
    }
  }

  static void _recordCall(
    _AuthRequest request, {
    required int status,
    required DateTime started,
    String? body,
    String? traceId,
    String? httpCode,
    String? originalMessage,
  }) {
    ClientErrorReporter.record(
      method: request.method.name,
      url: baseUrl + request.endpoint,
      endpoint: request.endpoint,
      status: status,
      durationMs: DateTime.now().difference(started).inMilliseconds,
      body: body,
      traceId: traceId,
      httpCode: httpCode,
      originalMessage: originalMessage,
    );
  }

  static void _reportTransport(
    _AuthRequest request,
    DateTime started,
    ClientErrorKind kind,
    String message,
    Object error,
  ) {
    _recordCall(
      request,
      status: 0,
      started: started,
      httpCode: error.runtimeType.toString(),
      originalMessage: error.toString(),
    );
    ClientErrorReporter.report(
      kind: kind,
      userVisibleMessage: message,
      originalMessage: error.toString(),
      httpCode: error.runtimeType.toString(),
      stackTrace: error is Error ? error.stackTrace?.toString() : null,
    );
  }

  static void _reportRecorded(
    ClientErrorKind kind,
    String userVisibleMessage,
    String originalMessage, {
    String? httpCode,
  }) {
    ClientErrorReporter.report(
      kind: kind,
      userVisibleMessage: userVisibleMessage,
      originalMessage: originalMessage,
      httpCode: httpCode,
    );
  }

  static Future<Response<dynamic>> uploadFile(
    String endPoint, {
    required Future<Map<String, dynamic>> Function() buildFields,
    bool sendToken = false,
    CancelToken? cancelToken,
  }) async {
    return _uploadWithRetry(
      endPoint,
      buildFields: buildFields,
      sendToken: sendToken,
      retried: false,
      attempt: 0,
      cancelToken: cancelToken,
    );
  }

  /// Rebuilds [FormData] on every attempt so a 401 → refresh → retry cycle can
  /// re-send the same payload (Dio FormData cannot be reused after finalize).
  static Future<Response<dynamic>> _uploadWithRetry(
    String endPoint, {
    required Future<Map<String, dynamic>> Function() buildFields,
    bool sendToken = false,
    required bool retried,
    required int attempt,
    String? accessTokenOverride,
    CancelToken? cancelToken,
  }) async {
    final started = DateTime.now();
    final token = accessTokenOverride ?? await TokenStorage.getAccessToken();
    if (kDebugMode && sendToken) {
      debugPrint('Token: $token');
    }

    final apiAddress = baseUrl + endPoint;
    if (kDebugMode) {
      debugPrint('${retried ? "Retry upload" : "Upload"}: $apiAddress');
    }

    final payload = FormData.fromMap(await buildFields());

    try {
      final response = await _uploadDio.post(
        apiAddress,
        data: payload,
        options: Options(
          headers: sendToken
              ? {
                  'Authorization': 'Bearer $token',
                }
              : null,
          contentType: Headers.multipartFormDataContentType,
        ),
        onSendProgress: (int sent, int total) {
          if (kDebugMode) {
            debugPrint('Progress :: $sent $total');
          }
        },
        cancelToken: cancelToken,
      );
      ClientErrorReporter.record(
        method: 'POST',
        url: apiAddress,
        endpoint: endPoint,
        status: response.statusCode ?? 200,
        durationMs: DateTime.now().difference(started).inMilliseconds,
        body: _dioBodySnippet(response.data),
        traceId: response.headers.value('x-trace-id'),
      );
      return response;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        if (kDebugMode) {
          debugPrint('Cancelled: $e');
        }
        ClientErrorReporter.report(
          kind: ClientErrorKind.client,
          userVisibleMessage: 'Upload cancelled',
          originalMessage: e.toString(),
          exceptionClass: 'Mobile.UploadCancelled',
        );
        rethrow;
      }

      ClientErrorReporter.record(
        method: 'POST',
        url: apiAddress,
        endpoint: endPoint,
        status: e.response?.statusCode ?? 0,
        durationMs: DateTime.now().difference(started).inMilliseconds,
        body: _dioBodySnippet(e.response?.data),
        traceId: e.response?.headers.value('x-trace-id'),
        httpCode: e.type.name,
        originalMessage: e.message,
      );

      if (e.response?.statusCode == 401 && sendToken && !retried && !_isAuthEndpoint(endPoint)) {
        final newAccessToken = await _refreshAccessToken();
        return _uploadWithRetry(
          endPoint,
          buildFields: buildFields,
          sendToken: sendToken,
          retried: true,
          attempt: attempt,
          accessTokenOverride: newAccessToken,
          cancelToken: cancelToken,
        );
      }

      if (e.response?.statusCode == 401 && retried) {
        await AuthSessionService.forceLogout();
      }

      if (_isRetryableUpload(e) && attempt < 2) {
        final delayMs = 500 * (1 << attempt);
        if (kDebugMode) {
          debugPrint('Retrying upload after ${delayMs}ms (attempt ${attempt + 1})');
        }
        await Future<void>.delayed(Duration(milliseconds: delayMs));
        return _uploadWithRetry(
          endPoint,
          buildFields: buildFields,
          sendToken: sendToken,
          retried: retried,
          attempt: attempt + 1,
          accessTokenOverride: accessTokenOverride,
          cancelToken: cancelToken,
        );
      }

      final kind = _dioErrorKind(e);
      if (kind != null) {
        ClientErrorReporter.report(
          kind: kind,
          userVisibleMessage: e.message ?? 'Upload failed',
          originalMessage: e.toString(),
          httpCode: e.type.name,
        );
      }

      if (e.response?.statusCode == 403) {
        await _handleForbiddenFromBody(e.response?.data, endPoint);
      }

      rethrow;
    }
  }

  static bool _isRetryableUpload(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.unknown:
        return e.response == null;
      default:
        return false;
    }
  }

  static ClientErrorKind? _dioErrorKind(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ClientErrorKind.timeout;
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return ClientErrorKind.network;
      case DioExceptionType.badResponse:
        return ClientErrorKind.http;
      case DioExceptionType.unknown:
        return e.response == null ? ClientErrorKind.network : ClientErrorKind.http;
      case DioExceptionType.cancel:
        return null;
    }
  }

  static String? _dioBodySnippet(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    try {
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }
}
