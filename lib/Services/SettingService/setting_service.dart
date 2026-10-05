import 'package:icms_app/Model/Settings/public_settings_response_model.dart';
import 'package:icms_app/Services/API/api.dart';

class SettingService {
  Future<PublicSettingsData?> fetchPublicSettings() async {
    try {
      final response = await Api.getPublicRequestData('setting/public-settings');
      if (response is! Map<String, dynamic>) return null;

      final parsed = PublicSettingsResponseModel.fromJson(response);
      if (parsed.success == true && parsed.data != null) {
        return parsed.data;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
