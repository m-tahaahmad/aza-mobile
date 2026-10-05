import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/PartsInvolveProvider/parts_involve_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/parts/parts_helpers.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PartsAdjustmentControls extends StatelessWidget {
  final PartsInvolveProvider provider;
  final bool applyDep;
  final bool applySalvage;
  final VoidCallback onApplyDep;
  final VoidCallback onApplySalvage;
  final VoidCallback onAddParts;

  const PartsAdjustmentControls({
    super.key,
    required this.provider,
    required this.applyDep,
    required this.applySalvage,
    required this.onApplyDep,
    required this.onApplySalvage,
    required this.onAddParts,
  });

  @override
  Widget build(BuildContext context) {
    if (partsFieldsReadOnly()) return const SizedBox.shrink();

    return CustomerDetailSectionCard(
      title: 'Adjustments',
      icon: Icons.tune_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _AdjustmentChip(
                  label: 'Apply Dep to All',
                  isActive: applyDep,
                  onTap: onApplyDep,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _AdjustmentChip(
                  label: 'Apply Salvage to All',
                  isActive: applySalvage,
                  onTap: onApplySalvage,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: onAddParts,
            child: Container(
              height: customerDetailFieldHeight(),
              padding: customerDetailFieldContentPadding,
              decoration: customerDetailInputDecoration(),
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, size: 20.sp, color: ColorConstants.primaryColor),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Add part',
                      style: customerDetailHintTextStyle(),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 22.sp, color: const Color(0xFF98A2B3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdjustmentChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _AdjustmentChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? ColorConstants.secondaryColor.withValues(alpha: 0.25) : const Color(0xFFF4F6FB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive ? ColorConstants.primaryColor.withValues(alpha: 0.4) : const Color(0xFFE4E9F2),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: FontSizes.smallText,
            fontWeight: FontWeight.w700,
            color: isActive ? ColorConstants.primaryColor : const Color(0xFF667085),
          ),
        ),
      ),
    );
  }
}
