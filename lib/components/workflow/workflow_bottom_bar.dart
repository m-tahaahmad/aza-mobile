import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class WorkflowBottomBar extends StatelessWidget {
  final VoidCallback onWithdraw;
  final VoidCallback? onThirdParty;
  final VoidCallback onSubmit;
  final bool isLoading;

  const WorkflowBottomBar({
    super.key,
    required this.onWithdraw,
    required this.onSubmit,
    this.onThirdParty,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonPadding = EdgeInsets.symmetric(horizontal: 6.w, vertical: 0);
    final labelStyle = TextStyle(
      fontSize: FontSizes.smallText,
      fontWeight: FontWeight.w700,
    );

    return Container(
      color: const Color(0xFFF3F5F9),
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44.h,
              child: OutlinedButton(
                onPressed: onWithdraw,
                style: OutlinedButton.styleFrom(
                  padding: buttonPadding,
                  side: const BorderSide(color: Color(0xFFF3C1C1)),
                  backgroundColor: const Color(0xFFFEEEEE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Withdraw',
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle.copyWith(color: const Color(0xFFD63838)),
                ),
              ),
            ),
          ),
          if (onThirdParty != null) ...[
            SizedBox(width: 6.w),
            Expanded(
              child: SizedBox(
                height: 44.h,
                child: OutlinedButton(
                  onPressed: onThirdParty,
                  style: OutlinedButton.styleFrom(
                    padding: buttonPadding,
                    side: BorderSide(color: ColorConstants.secondaryColor.withValues(alpha: 0.5)),
                    backgroundColor: ColorConstants.secondaryColor.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'Third Party',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle.copyWith(color: ColorConstants.primaryColor),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(width: 6.w),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 44.h,
              child: isLoading
                  ? const Center(child: AppLoader())
                  : ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: buttonPadding,
                        backgroundColor: ColorConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: labelStyle.copyWith(color: Colors.white),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
