import '../../constants/keys_constants.dart';
import '../SharedPreferenceService/shared_preferences_service.dart';

class TokenStorage {
  static final SharedPreferencesService _prefs = SharedPreferencesService();

  static Future<String?> getAccessToken() async {
    final value = await _prefs.getString(KeysConstants.accessToken);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static Future<String?> getRefreshToken() async {
    final value = await _prefs.getString(KeysConstants.refreshToken);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static Future<void> setTokens(String accessToken, {String? refreshToken}) async {
    await _prefs.setString(KeysConstants.accessToken, accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _prefs.setString(KeysConstants.refreshToken, refreshToken);
    }
  }

  static Future<void> clearAuthSession() async {
    await _prefs.remove(KeysConstants.accessToken);
    await _prefs.remove(KeysConstants.refreshToken);
    await _prefs.remove(KeysConstants.isUserLogin);
    await _prefs.remove(KeysConstants.userId);
    await _prefs.remove(KeysConstants.userableId);
    await _prefs.remove(KeysConstants.zoneId);
  }

  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
