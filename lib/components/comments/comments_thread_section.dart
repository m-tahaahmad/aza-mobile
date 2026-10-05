import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/components/comments/comments_helpers.dart';
import 'package:icms_app/components/comments/comments_message_bubble.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class CommentsThreadSection extends StatelessWidget {
  final List<Comments> comments;

  const CommentsThreadSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    final countLabel = comments.length == 1 ? '1 message' : '${comments.length} messages';

    return CustomerDetailSectionCard(
      title: 'Conversation',
      icon: Icons.chat_bubble_outline,
      child: comments.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  'No comments yet',
                  style: TextStyle(
                    fontSize: FontSizes.normalText1,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF98A2B3),
                  ),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorConstants.secondaryColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    countLabel,
                    style: TextStyle(
                      fontSize: FontSizes.smallText,
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                ...List.generate(comments.length, (index) {
                  final comment = comments[index];
                  final isMobile = comment.sender == 'mobile';
                  final nextUserId = index < comments.length - 1 ? comments[index + 1].userId : null;
                  final showAuthor = shouldShowAuthorName(
                    index: index,
                    total: comments.length,
                    currentUserId: comment.userId,
                    nextUserId: nextUserId,
                  );

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Align(
                      alignment: isMobile ? Alignment.centerRight : Alignment.centerLeft,
                      child: CommentsMessageBubble(
                        message: comment.message,
                        isMobileSender: isMobile,
                        authorName: showAuthor ? (comment.user?.userable?.fullName ?? 'Username') : null,
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
