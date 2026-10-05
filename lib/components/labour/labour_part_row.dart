import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class LabourPartRow extends StatelessWidget {
  final String partName;
  final VoidCallback? onDelete;

  const LabourPartRow({
    super.key,
    required this.partName,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE4E9F2)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: ColorConstants.secondaryColor.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.build_outlined,
              size: 16.sp,
              color: ColorConstants.primaryColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              partName,
              style: TextStyle(
                fontSize: FontSizes.normalText1,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          if (onDelete != null)
            InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: onDelete,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE4E2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  CupertinoIcons.trash,
                  size: 16.sp,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
