import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class MarkImportantConfirmDialog extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onYes;

  const MarkImportantConfirmDialog({
    super.key,
    required this.onNo,
    required this.onYes,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onNo,
    required VoidCallback onYes,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => MarkImportantConfirmDialog(onNo: onNo, onYes: onYes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E5),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.flag_outlined,
                size: 26.sp,
                color: const Color(0xFFE67E22),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Mark as important?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSizes.largeText,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You can flag this claim for priority review before submitting the report.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSizes.normalText1,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF667085),
                height: 1.4,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: onNo,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: ColorConstants.secondaryColor.withValues(alpha: 0.5)),
                        backgroundColor: ColorConstants.secondaryColor.withValues(alpha: 0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontSize: FontSizes.normalText2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: onYes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: FontSizes.normalText2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
