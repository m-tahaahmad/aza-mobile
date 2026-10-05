import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class AuthQuickSignInPill extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  final int colorIndex;

  const AuthQuickSignInPill({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
    this.colorIndex = 0,
  });

  static const List<Color> _avatarColors = [
    Color(0xFF4A6CC6),
    Color(0xFF6EE7B7),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> _avatarTextColors = [
    Colors.white,
    Color(0xFF065F46),
    Color(0xFF92400E),
    Colors.white,
  ];

  String get _displayName {
    final parts = name.split('.');
    if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase() + parts.first.substring(1);
    }
    if (name.isNotEmpty) {
      return name[0].toUpperCase() + name.substring(1);
    }
    return name;
  }

  String get _avatarLetter => name.isNotEmpty ? name[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColors[colorIndex % _avatarColors.length];
    final avatarTextColor = _avatarTextColors[colorIndex % _avatarTextColors.length];

    return AppPressable(
      onTap: onTap,
      borderRadius: 999.r,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected ? ColorConstants.primaryColor : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14.r,
              backgroundColor: avatarColor,
              child: Text(
                _avatarLetter,
                style: TextStyle(
                  fontSize: FontSizes.smallText,
                  fontWeight: FontWeight.w700,
                  color: avatarTextColor,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              _displayName,
              style: TextStyle(
                fontSize: FontSizes.normalText1,
                fontWeight: FontWeight.w700,
                color: ColorConstants.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
