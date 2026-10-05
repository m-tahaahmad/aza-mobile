import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icms_app/Services/SettingService/public_settings_storage.dart';
import 'package:icms_app/Services/TenantConfig/tenant_config.dart';
import 'package:icms_app/constants/theme_constants.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TenantConfig.restoreFromStorage();
  final cached = await PublicSettingsStorage.get();
  ColorConstants.applyFromPublicSettings(cached);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
