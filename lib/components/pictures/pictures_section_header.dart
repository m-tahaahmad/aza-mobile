import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PicturesSectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const PicturesSectionHeader({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: FontSizes.normalText2,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: ColorConstants.secondaryColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$count added',
              style: TextStyle(
                fontSize: FontSizes.smallText,
                fontWeight: FontWeight.w700,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
