import 'package:flutter/foundation.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';

String? _unparsedMessage;

/// Message for the latest values that could not be parsed, then clears it.
String? takeUnparsedNumberMessage() {
  final message = _unparsedMessage;
  _unparsedMessage = null;
  return message;
}

/// Null stays null. Numbers become their decimal string. Anything else uses [Object.toString].
String? readString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
  return value.toString();
}

/// Accepts int, other numbers (rounded), numeric strings, and bool flags.
/// Empty or null becomes null. A non-empty value that is not numeric is reported.
int? readInt(dynamic value, {String? field, String? summary, bool report = true}) {
  final parsed = readNum(value, field: field, summary: summary, report: report);
  if (parsed == null) return null;
  return parsed.round();
}

/// Parses an id. Null, blank, and non-numeric values are reported.
int? readId(dynamic value, {required String field}) {
  final summary = 'Could not read $field.';
  if (value == null || (value is String && value.trim().isEmpty)) {
    _reportUnparsed(field, value, summary: summary);
    return null;
  }
  return readInt(value, field: field, summary: summary);
}

/// Same as [readInt], with null mapped to 0.
int readIntOrZero(dynamic value, {String? field}) => readInt(value, field: field) ?? 0;

/// Accepts num and numeric strings without rounding.
/// Empty or null becomes null. A non-empty value that is not numeric is reported.
num? readNum(dynamic value, {String? field, String? summary, bool report = true}) {
  if (value == null) return null;
  if (value is bool) return value ? 1 : 0;
  if (value is num) return value;
  if (value is String) {
    final trimmed = value.trim().replaceAll(',', '');
    if (trimmed.isEmpty) return null;
    final parsed = num.tryParse(trimmed);
    if (parsed == null) {
      if (report) _reportUnparsed(field, value, summary: summary);
      return null;
    }
    return parsed;
  }
  if (report) _reportUnparsed(field, value, summary: summary);
  return null;
}

void _reportUnparsed(String? field, dynamic value, {String? summary}) {
  final label = field == null || field.isEmpty ? 'value' : field;
  final message = 'Could not read $label: $value';
  _unparsedMessage ??= summary ?? 'Some amounts could not be read and were treated as 0.';
  debugPrint(message);
  ClientErrorReporter.report(
    kind: ClientErrorKind.client,
    userVisibleMessage: message,
    originalMessage: value?.toString(),
    exceptionClass: 'Mobile.UnparsedNumber',
  );
}
