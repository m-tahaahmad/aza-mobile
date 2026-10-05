import 'package:icms_app/constants/theme_constants.dart';

import 'dashboard_card_styles.dart';

class DashboardStageKeys {
  static const unassigned = 'unassigned';
  static const surveys = 'surveys';
  static const waiting = 'waiting';
  static const rejected = 'rejected';
  static const reinspections = 'reinspections';
  static const docs = 'docs';
  static const waitingFsr = 'waitingFsr';
  static const reports = 'reports';
}

class DashboardStageColors {
  static DashboardCardStyle styleForStage(String stageKey, {DashboardCardStyle? fallback}) {
    final resolvedFallback = fallback ?? DashboardCardStyle.grey;
    final background = ColorConstants.stageBackgroundColor(
      stageKey,
      fallback: resolvedFallback.iconBackgroundColor,
    );
    final icon = ColorConstants.stageIconColor(
      stageKey,
      fallbackBackground: resolvedFallback.iconBackgroundColor,
    );
    return DashboardCardStyle(iconColor: icon, iconBackgroundColor: background);
  }
}
