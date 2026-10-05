String formatDashboardCount(int? count) {
  final value = count ?? 0;
  if (value > 0 && value < 10) return '0$value';
  return value.toString();
}
