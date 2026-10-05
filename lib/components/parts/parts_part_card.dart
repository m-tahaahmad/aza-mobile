import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/parts/parts_helpers.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/screens/Claims/WorkFlow/PartsInvolves/parts_involves_ui.dart';

class PartsPartCard extends StatelessWidget {
  final PartTableDetails detail;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PartsPartCard({
    super.key,
    required this.detail,
    this.onTap,
    this.onDelete,
  });

  String get _depLabel {
    if (detail.dep != null && detail.dep != 0) return '${detail.dep}%';
    if (detail.depPrice != 0) return formatPkrAmount(detail.depPrice);
    return '0';
  }

  String get _salLabel {
    if (detail.sal != null && detail.sal != 0) return '${detail.sal}%';
    if (detail.salPrice != 0) return formatPkrAmount(detail.salPrice);
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        detail.part?.name ?? '',
                        style: TextStyle(
                          fontSize: FontSizes.normalText2,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    if (onDelete != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: onDelete,
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Icon(Icons.delete_outline, size: 20.sp, color: const Color(0xFFE53935)),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _ConditionBadge(label: partsConditionLabel(detail.condition)),
                    if (detail.sd == 1) ...[
                      SizedBox(width: 8.w),
                      _ConditionBadge(label: 'SD', isSd: true),
                    ],
                    const Spacer(),
                    Text(
                      formatPkrAmount(detail.subTotal),
                      style: TextStyle(
                        fontSize: FontSizes.normalText2,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Divider(height: 1, color: const Color(0xFFEEF2F7)),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(child: _DetailChip(label: 'Price', value: formatPkrAmount(detail.price))),
                    SizedBox(width: 8.w),
                    Expanded(child: _DetailChip(label: 'Dep', value: _depLabel)),
                    SizedBox(width: 8.w),
                    Expanded(child: _DetailChip(label: 'Salvage', value: _salLabel)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConditionBadge extends StatelessWidget {
  final String label;
  final bool isSd;

  const _ConditionBadge({required this.label, this.isSd = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isSd ? const Color(0xFFE8F0FE) : ColorConstants.secondaryColor.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: FontSizes.smallText,
          fontWeight: FontWeight.w700,
          color: isSd ? const Color(0xFF1A56DB) : ColorConstants.primaryColor,
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;

  const _DetailChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.smallText,
            color: const Color(0xFF98A2B3),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: FontSizes.smallText,
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
