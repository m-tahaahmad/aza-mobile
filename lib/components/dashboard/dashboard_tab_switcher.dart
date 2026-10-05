import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class DashboardTabSwitcher extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const DashboardTabSwitcher({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final inset = 4.w;
          final tabWidth = (constraints.maxWidth - inset * 2) / 2;

          return Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDF8),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  left: inset + (currentIndex * tabWidth),
                  top: inset,
                  bottom: inset,
                  width: tabWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    _tab(label: 'Claim', index: 0),
                    _tab(label: 'Pre-Inspection', index: 1),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tab({required String label, required int index}) {
    final isActive = currentIndex == index;
    return Expanded(
      child: AppPressable(
        onTap: () => onChanged(index),
        borderRadius: 10.r,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: FontSizes.smallText,
              fontWeight: FontWeight.w600,
              color: isActive ? ColorConstants.primaryColor : const Color(0xFF6B7280),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
