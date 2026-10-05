import 'package:icms_app/components/dashboard/dashboard_stage_colors.dart';
import 'package:icms_app/constants/theme_constants.dart';

String stageDisplayLabel({
  String? stageKey,
  String? statusFallback,
}) {
  final key = stageKey?.trim();
  if (key != null && key.isNotEmpty) {
    if (key == 'payments') return 'Pending Payments';

    final fromSettings = ColorConstants.stageLabel(key);
    if (fromSettings != null && fromSettings.isNotEmpty) {
      return fromSettings;
    }
    return _humanizeStageKey(key);
  }

  final status = statusFallback?.toString().trim();
  if (status != null && status.isNotEmpty) {
    return status;
  }

  return 'Unknown';
}

String? stageColorKey({
  String? stageKey,
  String? statusFallback,
}) {
  final key = stageKey?.trim();
  if (key != null && key.isNotEmpty) {
    return key;
  }
  return stageKeyForClaimStatus(statusFallback?.toString());
}

String _humanizeStageKey(String key) {
  if (key == 'waitingFsr') return 'FSR Approval';
  if (key == 'waiting') return 'PLR Approval';

  return key
      .replaceAll('-', ' ')
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match.group(1)} ${match.group(2)}')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

String? stageKeyForClaimStatus(String? status) {
  switch (status) {
    case 'Pending Acknowledge':
      return DashboardStageKeys.unassigned;
    case 'Pending 1st Inspection':
      return DashboardStageKeys.surveys;
    case 'Approval for PLR':
      return DashboardStageKeys.waiting;
    case 'Rejected':
      return DashboardStageKeys.rejected;
    case 'Pending Re-Inspection':
      return DashboardStageKeys.reinspections;
    case 'Final Stage':
      return DashboardStageKeys.docs;
    case 'Approval for FSR':
      return DashboardStageKeys.waitingFsr;
    case 'Report Pending':
      return DashboardStageKeys.reports;
    case 'Finished':
    case 'Closed':
      return 'closed';
    case 'Pending Payments':
      return 'payments';
    default:
      return null;
  }
}
