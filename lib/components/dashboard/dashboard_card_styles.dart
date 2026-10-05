import 'package:flutter/material.dart';

class DashboardCardStyle {
  final Color iconColor;
  final Color iconBackgroundColor;

  const DashboardCardStyle({
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  static const blue = DashboardCardStyle(
    iconColor: Color(0xFF2563EB),
    iconBackgroundColor: Color(0xFFDBEAFE),
  );

  static const purple = DashboardCardStyle(
    iconColor: Color(0xFF7C3AED),
    iconBackgroundColor: Color(0xFFEDE9FE),
  );

  static const red = DashboardCardStyle(
    iconColor: Color(0xFFDC2626),
    iconBackgroundColor: Color(0xFFFEE2E2),
  );

  static const orange = DashboardCardStyle(
    iconColor: Color(0xFFEA580C),
    iconBackgroundColor: Color(0xFFFFEDD5),
  );

  static const green = DashboardCardStyle(
    iconColor: Color(0xFF059669),
    iconBackgroundColor: Color(0xFFD1FAE5),
  );

  static const grey = DashboardCardStyle(
    iconColor: Color(0xFF6B7280),
    iconBackgroundColor: Color(0xFFF3F4F6),
  );

  static const teal = DashboardCardStyle(
    iconColor: Color(0xFF0D9488),
    iconBackgroundColor: Color(0xFFCCFBF1),
  );
}
