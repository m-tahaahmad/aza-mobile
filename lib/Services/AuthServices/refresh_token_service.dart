import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:icms_app/Services/API/api_error_parser.dart';
import 'package:icms_app/constants/globals.dart';

class RefreshTokenResult {
  final String accessToken;
  final String? refreshToken;

  RefreshTokenResult({
    required this.accessToken,
    this.refreshToken,
  });
}

class RefreshTokenException implements Exception {
  final int? statusCode;
  final String message;
  final String? code;

  RefreshTokenException(this.message, {this.statusCode, this.code});

  @override
  String toString() => message;
}

class RefreshTokenService {
  Future<RefreshTokenResult> refresh(String refreshToken) async {
    final uri = Uri.parse('${baseUrl}refresh');
    final response = await http
        .post(
          uri,
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'refresh_token': refreshToken}),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      final parsed = ApiErrorParser.parse(response.body);
      throw RefreshTokenException(
        parsed.message,
        statusCode: response.statusCode,
        code: parsed.code,
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>?;
    final accessToken = data?['access_token'] as String?;

    if (accessToken == null || accessToken.isEmpty) {
      throw RefreshTokenException('Refresh response did not include an access token');
    }

    return RefreshTokenResult(
      accessToken: accessToken,
      refreshToken: data?['refresh_token'] as String?,
    );
  }
}
