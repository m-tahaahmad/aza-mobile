import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Providers/LabourPartsProvider/labour_parts_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/labour/labour_part_row.dart';
import 'package:icms_app/components/parts/parts_catalog_picker_sheet.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/screens/Claims/WorkFlow/Labour/labour_detail_widget.dart';
import 'package:provider/provider.dart';

class LabourPartsSection extends StatefulWidget {
  final List<Part>? partItems;

  const LabourPartsSection({super.key, this.partItems});

  @override
  State<LabourPartsSection> createState() => _LabourPartsSectionState();
}

class _LabourPartsSectionState extends State<LabourPartsSection> {
  bool get _readOnly => labourFieldsReadOnly();

  Future<void> _openPartsPicker(LabourPartsProvider labourPartProvider) async {
    final parts = List<Part>.from(
      labourPartProvider.labourPartsResponseModel?.data ?? widget.partItems ?? const <Part>[],
    );

    final alreadySelectedIds = labourPartProvider.selectedParts
        .whereType<Part>()
        .map((part) => part.id)
        .whereType<int>()
        .toSet();

    final selected = await PartsCatalogPickerSheet.show(
      context,
      partItems: parts,
      alreadySelectedIds: alreadySelectedIds,
      kind: PartsCatalogKind.labour,
    );

    if (!mounted || selected == null || selected.isEmpty) return;

    setState(() {
      for (final part in selected) {
        if (!labourPartProvider.selectedParts.contains(part)) {
          labourPartProvider.addSelectedPart(part);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LabourPartsProvider>(
      builder: (context, labourPartProvider, child) {
        final count = labourPartProvider.selectedParts.length;
        final countLabel = count == 1 ? '1 part' : '$count parts';

        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.w),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      color: ColorConstants.secondaryColor.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.handyman_outlined, size: 18.sp, color: ColorConstants.primaryColor),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Parts Involved',
                      style: TextStyle(
                        fontSize: FontSizes.largeText,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ColorConstants.secondaryColor.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      countLabel,
                      style: TextStyle(
                        fontSize: FontSizes.smallText,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'Select the affected part from the list below to add it to the estimate.',
                style: TextStyle(
                  fontSize: FontSizes.smallText,
                  color: const Color(0xFF98A2B3),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (!_readOnly) ...[
                SizedBox(height: 12.h),
                InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () => _openPartsPicker(labourPartProvider),
                  child: Container(
                    height: customerDetailFieldHeight(),
                    padding: customerDetailFieldContentPadding,
                    decoration: customerDetailInputDecoration(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Select parts',
                            style: customerDetailHintTextStyle(),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22.sp,
                          color: const Color(0xFF98A2B3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (count > 0) ...[
                SizedBox(height: 14.h),
                ...List.generate(count, (index) {
                  final part = labourPartProvider.selectedParts[index]!;
                  return LabourPartRow(
                    partName: part.name ?? '',
                    onDelete: _readOnly
                        ? null
                        : () {
                            setState(() {
                              labourPartProvider.removeSelectedPart(part);
                            });
                          },
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }
}
