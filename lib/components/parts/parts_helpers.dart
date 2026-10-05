import 'package:icms_app/constants/globals.dart';

bool partsFieldsReadOnly() {
  return claimsType == 'Waiting for approval' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';
}

String formatPkrAmount(dynamic value) {
  if (value == null) return 'PKR 0';
  final text = value.toString().trim();
  if (text.isEmpty) return 'PKR 0';
  return 'PKR $text';
}

String partsConditionLabel(String? condition) {
  if (condition == '0' || condition == 'New') return 'New';
  if (condition == 'used') return 'Used';
  if (condition == 'non-genuine') return 'N.G';
  return condition ?? '';
}

String partsConditionValue(String? label) {
  if (label == 'New') return '0';
  if (label == 'Used') return 'used';
  if (label == 'N.G') return 'non-genuine';
  return label ?? '';
}
