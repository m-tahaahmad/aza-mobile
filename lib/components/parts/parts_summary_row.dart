import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PartsSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDeduction;
  final bool isBold;
  final String? suffix;

  const PartsSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isDeduction = false,
    this.isBold = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = suffix != null ? '$value$suffix' : value;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isBold ? FontSizes.normalText2 : FontSizes.normalText1,
                color: const Color(0xFF667085),
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            displayValue,
            style: TextStyle(
              fontSize: isBold ? FontSizes.normalText2 : FontSizes.normalText1,
              color: isDeduction ? const Color(0xFFE53935) : const Color(0xFF1F2937),
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
