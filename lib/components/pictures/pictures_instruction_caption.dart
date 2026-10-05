import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/font_sizes.dart';

Widget picturesInstructionCaption() {
  return Padding(
    padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 8.h),
    child: Text(
      'Capture clear photos of the vehicle from all angles. Tap a tile to add it.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: FontSizes.smallText,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF98A2B3),
        height: 1.4,
      ),
    ),
  );
}
