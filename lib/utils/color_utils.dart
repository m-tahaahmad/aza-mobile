import 'package:flutter/material.dart';

Color? parseHexColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  var value = hex.replaceAll('#', '');
  if (value.length == 6) value = 'FF$value';
  if (value.length != 8) return null;
  final intColor = int.tryParse(value, radix: 16);
  if (intColor == null) return null;
  return Color(intColor);
}

Color darkenColor(Color color, [double amount = 0.38]) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}
