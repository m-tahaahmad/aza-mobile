import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PicturesSegmentedTabs extends StatelessWidget {
  final TabController controller;
  final ValueChanged<int>? onTabTap;

  const PicturesSegmentedTabs({
    super.key,
    required this.controller,
    this.onTabTap,
  });

  static const _labels = ['1st Inspection', 'Re-inspection', 'SD'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 0),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EDF5),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: List.generate(_labels.length, (index) {
                final isActive = controller.index == index;
                return Expanded(
                  child: AppPressable(
                    onTap: () => onTabTap?.call(index),
                    borderRadius: 10.r,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        _labels[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FontSizes.smallText,
                          fontWeight: FontWeight.w700,
                          color: isActive ? ColorConstants.primaryColor : const Color(0xFF98A2B3),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
