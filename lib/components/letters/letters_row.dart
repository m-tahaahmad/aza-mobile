import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/letters/letters_helpers.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class LettersRow extends StatelessWidget {
  final LetterType letter;
  final VoidCallback onTap;

  const LettersRow({
    super.key,
    required this.letter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: const Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: 18.sp,
                  color: const Color(0xFF98A2B3),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      letter.title,
                      style: TextStyle(
                        fontSize: FontSizes.normalText1,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    if (letter.requiresDocuments)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          'Documents required',
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
              if (letter.requiresDocuments)
                Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorConstants.secondaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Docs',
                    style: TextStyle(
                      fontSize: FontSizes.smallText,
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.primaryColor,
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
