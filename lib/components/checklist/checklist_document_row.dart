import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/DocumentsModel/document_response_model.dart';
import 'package:icms_app/components/checklist/checklist_helpers.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class ChecklistDocumentRow extends StatelessWidget {
  final DocumentData document;
  final bool isComplete;
  final VoidCallback onTap;

  const ChecklistDocumentRow({
    super.key,
    required this.document,
    required this.isComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final required = isDocumentRequired(document.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: isComplete
                      ? const Color(0xFFE2F4EA)
                      : const Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  isComplete ? CupertinoIcons.check_mark : Icons.description_outlined,
                  size: 18.sp,
                  color: isComplete ? const Color(0xFF0A8F4C) : const Color(0xFF98A2B3),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            document.name ?? '',
                            style: TextStyle(
                              fontSize: FontSizes.normalText1,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        if (required) ...[
                          SizedBox(width: 4.w),
                          Text(
                            '*',
                            style: TextStyle(
                              fontSize: FontSizes.normalText1,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE53935),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (required)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          'Required',
                          style: TextStyle(
                            fontSize: FontSizes.smallText,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (isComplete)
                Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F4EA),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: FontSizes.smallText,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0A8F4C),
                    ),
                  ),
                ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: const Color(0xFF98A2B3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
