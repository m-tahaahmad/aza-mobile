import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/font_sizes.dart';

import 'dashboard_helpers.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final int? count;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final VoidCallback onTap;
  final bool showCount;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.onTap,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    final value = count ?? 0;
    final countText = formatDashboardCount(count);
    final isZero = value == 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppPressable(
        onTap: onTap,
        borderRadius: 18.r,
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(icon, color: iconColor, size: 18.sp),
                  ),
                  const Spacer(),
                  if (showCount)
                    Text(
                      countText,
                      style: TextStyle(
                        fontSize: FontSizes.hugeText,
                        fontWeight: FontWeight.w700,
                        color: isZero ? const Color(0xFFD1D5DB) : const Color(0xFF111827),
                        height: 1,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FontSizes.normalText1,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
