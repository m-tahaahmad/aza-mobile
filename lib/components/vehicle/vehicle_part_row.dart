import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/font_sizes.dart';

class VehiclePartRow extends StatelessWidget {
  final String partName;
  final String status;
  final bool readOnly;
  final ValueChanged<String> onStatusChanged;

  const VehiclePartRow({
    super.key,
    required this.partName,
    required this.status,
    required this.readOnly,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isYes = status.toUpperCase() == 'YES';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              partName,
              style: TextStyle(
                fontSize: FontSizes.normalText1,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
          _StatusChip(
            label: 'Yes',
            isActive: isYes,
            activeColor: const Color(0xFFE2F4EA),
            activeTextColor: const Color(0xFF0A8F4C),
            readOnly: readOnly,
            onTap: () => onStatusChanged('YES'),
          ),
          SizedBox(width: 8.w),
          _StatusChip(
            label: 'No',
            isActive: !isYes,
            activeColor: const Color(0xFFF4F6FB),
            activeTextColor: const Color(0xFF667085),
            readOnly: readOnly,
            onTap: () => onStatusChanged('NO'),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color activeTextColor;
  final bool readOnly;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.activeTextColor,
    required this.readOnly,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: readOnly ? null : onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isActive ? activeColor : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isActive ? activeTextColor.withValues(alpha: 0.25) : const Color(0xFFE4E9F2),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.smallText,
              fontWeight: FontWeight.w700,
              color: isActive ? activeTextColor : const Color(0xFF98A2B3),
            ),
          ),
        ),
      ),
    );
  }
}
