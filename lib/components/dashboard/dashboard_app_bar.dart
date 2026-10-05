import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class DashboardAppBar extends StatelessWidget {
  final String userName;
  final String? organizationName;
  final VoidCallback onSearchTap;
  final VoidCallback onLogoutTap;

  const DashboardAppBar({
    super.key,
    required this.userName,
    this.organizationName,
    required this.onSearchTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final orgName = organizationName?.trim() ?? '';

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.isNotEmpty ? userName : 'Surveyor',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: FontSizes.extraLargeText,
                    fontWeight: FontWeight.w800,
                    color: ColorConstants.black,
                    height: 1.1,
                  ),
                ),
                if (orgName.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    orgName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: FontSizes.normalText1,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                      height: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppPressable(
              onTap: onSearchTap,
              borderRadius: 12.r,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  CupertinoIcons.search,
                  color: const Color(0xFF6B7280),
                  size: 20.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppPressable(
              onTap: onLogoutTap,
              borderRadius: 12.r,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  CupertinoIcons.square_arrow_right,
                  color: const Color(0xFFDC2626),
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
