import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class CustomerDetailBottomBar extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback? onDone;
  final bool isLoading;
  final bool isFinalizing;
  final bool showDone;

  const CustomerDetailBottomBar({
    super.key,
    required this.onSave,
    this.onDone,
    this.isLoading = false,
    this.isFinalizing = false,
    this.showDone = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonPadding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 0);

    return Container(
      color: const Color(0xFFF3F5F9),
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44.h,
              child: OutlinedButton(
                onPressed: isLoading ? null : onSave,
                style: OutlinedButton.styleFrom(
                  padding: buttonPadding,
                  side: BorderSide(color: ColorConstants.secondaryColor.withValues(alpha: 0.5)),
                  backgroundColor: ColorConstants.secondaryColor.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: isLoading
                    ? const AppLoader()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.floppy_disk, size: 15.sp, color: ColorConstants.primaryColor),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              'Save',
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontSize: FontSizes.smallText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          if (showDone) ...[
            SizedBox(width: 6.w),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 44.h,
                child: isFinalizing
                    ? const Center(child: AppLoader())
                    : ElevatedButton(
                        onPressed: onDone,
                        style: ElevatedButton.styleFrom(
                          padding: buttonPadding,
                          backgroundColor: ColorConstants.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 16.sp),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                'Done',
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: FontSizes.smallText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
