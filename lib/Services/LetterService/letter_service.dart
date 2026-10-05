import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/globals.dart';
import '../AuthServices/token_storage.dart';

/// Generates a letter that requires document selection (alert3, total-loss-docs, theft-docs)
/// by POSTing selected document names and returns the preview URL from the response body.
Future<String?> generateLetterWithDocuments(
  BuildContext context,
  String endpoint,
  int claimId,
  List<String> documents,
) async {
  if (documents.isEmpty) return null;

  final uri = Uri.parse('$baseUrl$endpoint/$claimId');
  final token = await TokenStorage.getAccessToken();
  if (token == null || token.isEmpty) return null;

  final response = await http
      .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'documents': documents}),
      )
      .timeout(
        const Duration(seconds: 60),
        onTimeout: () => http.Response('', 408),
      );

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    return response.body.trim();
  }
  return null;
}
