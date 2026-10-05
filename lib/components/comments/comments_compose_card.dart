import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class CommentsComposeCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  const CommentsComposeCard({
    super.key,
    required this.controller,
    required this.onSend,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
      child: CustomerDetailSectionCard(
        title: 'Your comment',
        icon: Icons.edit_note_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              minLines: 3,
              maxLines: 5,
              enabled: !isSending,
              style: customerDetailInputTextStyle(),
              decoration: customerDetailInputFieldDecoration(hintText: 'Write comment'),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 40.h,
                child: ElevatedButton.icon(
                  onPressed: isSending ? null : onSend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    disabledBackgroundColor: ColorConstants.primaryColor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  icon: isSending
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.send_rounded, size: 18.sp, color: Colors.white),
                  label: Text(
                    'Send',
                    style: TextStyle(
                      fontSize: FontSizes.normalText1,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
