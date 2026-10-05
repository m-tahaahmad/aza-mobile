import 'package:flutter/material.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';

showSnackBar(BuildContext context, String message, {Color? color, textColor}) {
  if (RegExp(r'something went wrong', caseSensitive: false).hasMatch(message)) {
    ClientErrorReporter.reportUserVisible(message);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: FontSizes.normalText1, color: textColor, fontWeight: FontWeight.w300),
      ),
      behavior: SnackBarBehavior.floating,
      width: MediaQuery.of(context).size.width * 0.95,
      duration: const Duration(seconds: 1, milliseconds: 500),
      backgroundColor: color,
    ),
  );
}
