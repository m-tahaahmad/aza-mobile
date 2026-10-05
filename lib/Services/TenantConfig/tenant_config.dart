import 'package:icms_app/Env/env.dart';
import 'package:icms_app/Services/SharedPreferenceService/shared_preferences_service.dart';
import 'package:icms_app/constants/keys_constants.dart';
import 'package:icms_app/constants/globals.dart';

class TenantConfig {
  static final SharedPreferencesService _prefs = SharedPreferencesService();

  static Future<String?> getServerName() async {
    final value = await _prefs.getString(KeysConstants.serverName);
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  static Future<void> saveServerName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await _prefs.setString(KeysConstants.serverName, trimmed);
    applyBaseUrl(trimmed);
  }

  static void applyBaseUrl(String serverName) {
    final trimmed = serverName.trim();
    if (trimmed.isEmpty) return;
    tenantName = trimmed;
    baseUrl = Env.apiUrlForTenant(trimmed);
  }

  static Future<void> restoreFromStorage() async {
    final serverName = await getServerName();
    if (serverName != null && serverName.isNotEmpty) {
      applyBaseUrl(serverName);
    }
  }
}
