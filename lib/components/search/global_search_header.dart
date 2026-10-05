import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/font_sizes.dart';

class GlobalSearchHeader extends StatelessWidget {
  final String subtitle;
  final VoidCallback onBack;

  const GlobalSearchHeader({
    super.key,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F8FC),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      child: Row(
        children: [
          AppPressable(
            borderRadius: 12.r,
            onTap: onBack,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE4E9F2)),
              ),
              child: Icon(
                CupertinoIcons.back,
                size: 18.sp,
                color: const Color(0xFF475467),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search claims',
                  style: TextStyle(
                    fontSize: FontSizes.bigText,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: FontSizes.normalText1,
                    color: const Color(0xFF98A2B3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
