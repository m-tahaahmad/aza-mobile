import 'package:intl/intl.dart';

final DateFormat _displayDateFormat = DateFormat.yMMMEd();
final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

String formatDisplayDate(DateTime date) {
  return _displayDateFormat.format(date);
}

String formatDisplayDateValue(
  Object? value, {
  String fallback = '',
}) {
  if (value == null) return fallback;

  if (value is DateTime) {
    return formatDisplayDate(value);
  }

  final raw = value.toString().trim();
  if (raw.isEmpty) return fallback;

  final parsed = DateTime.tryParse(raw);
  if (parsed != null) {
    return formatDisplayDate(parsed);
  }

  return raw;
}

String formatApiDate(DateTime date) {
  return _apiDateFormat.format(date);
}
