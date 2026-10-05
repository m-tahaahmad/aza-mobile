import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/font_sizes.dart';

class GlobalSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  const GlobalSearchField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F8FC),
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(
          color: const Color(0xFFE8EDF8),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: TextField(
          controller: controller,
          autofocus: autofocus,
          textInputAction: TextInputAction.search,
          onSubmitted: onSubmitted,
          style: TextStyle(
            fontSize: FontSizes.normalText2,
            color: const Color(0xFF344054),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search claim, branch or plate',
            hintStyle: TextStyle(
              fontSize: FontSizes.normalText2,
              color: const Color(0xFF98A2B3),
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 18.sp,
              color: const Color(0xFF98A2B3),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
        ),
      ),
    );
  }
}
