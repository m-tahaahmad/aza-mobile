import 'package:icms_app/Model/Settings/public_settings_response_model.dart';
import 'package:icms_app/constants/keys_constants.dart';
import 'package:icms_app/Services/SharedPreferenceService/shared_preferences_service.dart';

class PublicSettingsStorage {
  static final SharedPreferencesService _prefs = SharedPreferencesService();

  static Future<void> save(PublicSettingsData settings) async {
    await _prefs.setJsonString(KeysConstants.publicSettings, settings.toJson());
  }

  static Future<PublicSettingsData?> get() async {
    final cached = await _prefs.getJsonMap(KeysConstants.publicSettings);
    if (cached == null) return null;
    return PublicSettingsData.fromJson(cached);
  }
}
