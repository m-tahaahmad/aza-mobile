import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setString(String key, String? value) async {
    SharedPreferences prefs = await _prefs;
    if (value != null && value.isNotEmpty) {
      prefs.setString(key, value);
    }
  }

  Future<void> setJsonString(String key, Map<String, dynamic> value) async {
    SharedPreferences prefs = await _prefs;
    if (value.isNotEmpty) {
      prefs.setString(key, jsonEncode(value));
    }
  }

  Future<Map<String, dynamic>?> getJsonMap(String key) async {
    SharedPreferences prefs = await _prefs;
    if (!prefs.containsKey(key)) return null;
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    return null;
  }

  Future<String?> getString(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key) ? prefs.getString(key) : "";
  }

  Future<bool> checkKey(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.remove(key);
  }

  Future<void> clearLocalData() async {
    SharedPreferences prefs = await _prefs;
    await prefs.clear();
    debugPrint("Cleared All Data");
  }
}
