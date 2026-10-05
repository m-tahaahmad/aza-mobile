import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class CommentsMessageBubble extends StatelessWidget {
  final String? message;
  final bool isMobileSender;
  final String? authorName;

  const CommentsMessageBubble({
    super.key,
    required this.message,
    required this.isMobileSender,
    this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMobileSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isMobileSender ? ColorConstants.primaryColor : const Color(0xFFF4F6FB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: Radius.circular(isMobileSender ? 16.r : 4.r),
              bottomRight: Radius.circular(isMobileSender ? 4.r : 16.r),
            ),
            border: isMobileSender ? null : Border.all(color: const Color(0xFFE4E9F2)),
          ),
          child: Text(
            message ?? '',
            style: TextStyle(
              fontSize: FontSizes.normalText1,
              fontWeight: FontWeight.w500,
              color: isMobileSender ? Colors.white : const Color(0xFF1F2937),
              height: 1.35,
            ),
          ),
        ),
        if (authorName != null) ...[
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              authorName!,
              style: TextStyle(
                fontSize: FontSizes.smallText,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF98A2B3),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
