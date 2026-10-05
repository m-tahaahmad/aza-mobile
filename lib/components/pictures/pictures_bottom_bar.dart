import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PicturesBottomBar extends StatelessWidget {
  final VoidCallback onDone;
  final VoidCallback? onCancelUpload;
  final bool isUploading;
  final bool isFinalizing;

  const PicturesBottomBar({
    super.key,
    required this.onDone,
    this.onCancelUpload,
    this.isUploading = false,
    this.isFinalizing = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonPadding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 0);

    return Container(
      color: const Color(0xFFF3F5F9),
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 14.h),
      child: SizedBox(
        height: 44.h,
        width: double.infinity,
        child: isUploading
            ? OutlinedButton(
                onPressed: onCancelUpload,
                style: OutlinedButton.styleFrom(
                  padding: buttonPadding,
                  side: BorderSide(color: ColorConstants.secondaryColor.withValues(alpha: 0.5)),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Cancel Upload',
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorConstants.primaryColor,
                    fontSize: FontSizes.smallText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : isFinalizing
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
    );
  }
}
