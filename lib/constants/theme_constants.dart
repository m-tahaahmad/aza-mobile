import 'package:flutter/material.dart';
import 'package:icms_app/Model/Settings/public_settings_response_model.dart';
import 'package:icms_app/utils/color_utils.dart';

class ColorConstants {
  static const Color transparent = Colors.transparent;
  static Color baseColor = const Color(0xfffafcf9);
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color disableButtonColor = Colors.grey;

  static const Color _defaultPrimary = Color(0xff4a6cc6);
  static const Color _defaultSecondary = Color(0xff82A1DD);
  static const Color _defaultNotificationBar = Color(0xff4461B4);

  static Color primaryColor = _defaultPrimary;
  static Color secondaryColor = _defaultSecondary;
  static Color notificationBar = _defaultNotificationBar;
  static Color searchbarBackground = _defaultSecondary;

  static final Map<String, Color> _stageBackgroundColors = {};
  static final Map<String, String> _stageLabels = {};

  static void applyFromPublicSettings(PublicSettingsData? settings) {
    primaryColor = parseHexColor(settings?.primaryColor) ?? _defaultPrimary;
    secondaryColor = parseHexColor(settings?.secondaryColor) ?? _defaultSecondary;
    searchbarBackground = secondaryColor;

    _stageBackgroundColors.clear();
    _stageLabels.clear();
    for (final stage in settings?.claimStageColors?.stages ?? <ClaimStage>[]) {
      final key = stage.key;
      final color = parseHexColor(stage.color);
      if (key != null && key.isNotEmpty && color != null) {
        _stageBackgroundColors[key] = color;
      }
      final label = stage.label;
      if (key != null && key.isNotEmpty && label != null && label.isNotEmpty) {
        _stageLabels[key] = label;
      }
    }
  }

  static String? stageLabel(String stageKey) => _stageLabels[stageKey];

  static Color stageBackgroundColor(String stageKey, {required Color fallback}) {
    return _stageBackgroundColors[stageKey] ?? fallback;
  }

  static Color stageIconColor(String stageKey, {required Color fallbackBackground}) {
    final background = stageBackgroundColor(stageKey, fallback: fallbackBackground);
    return darkenColor(background);
  }
}
