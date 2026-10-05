import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/PartsInvolveProvider/parts_involve_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/parts/parts_helpers.dart';
import 'package:icms_app/components/parts/parts_summary_row.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PartsTotalsCard extends StatelessWidget {
  final PartsInvolveProvider provider;
  final bool readOnly;
  final VoidCallback onGstChanged;

  const PartsTotalsCard({
    super.key,
    required this.provider,
    required this.readOnly,
    required this.onGstChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Parts Totals',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          PartsSummaryRow(
            label: 'Gross Total Parts Amount',
            value: formatPkrAmount(provider.grossTotal),
          ),
          customerDetailDivider(),
          PartsSummaryRow(
            label: 'Depreciation Amount',
            value: formatPkrAmount(provider.depreciationAmount),
            isDeduction: true,
          ),
          customerDetailDivider(),
          PartsSummaryRow(
            label: 'Total Parts Amount',
            value: formatPkrAmount(provider.partsTotal),
          ),
          customerDetailDivider(),
          customerDetailFieldLabel('GST %'),
          SizedBox(height: 8.h),
          customerDetailSizedSuffixTextField(
            controller: provider.gstController,
            suffixText: '%',
            readOnly: readOnly,
            keyboardType: TextInputType.number,
          ),
          if (!readOnly)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onGstChanged,
                  child: Text(
                    'Apply GST',
                    style: TextStyle(
                      fontSize: FontSizes.smallText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          customerDetailDivider(),
          PartsSummaryRow(
            label: 'Total Amount',
            value: formatPkrAmount(provider.overallTotal),
            isBold: true,
          ),
        ],
      ),
    );
  }
}
