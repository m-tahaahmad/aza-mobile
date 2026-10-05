import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PartsSettlementCard extends StatelessWidget {
  final TextEditingController deductibleController;
  final TextEditingController insuranceController;
  final TextEditingController lumpSumController;
  final bool isLumpSum;
  final bool readOnly;
  final ValueChanged<bool?> onLumpSumChanged;

  const PartsSettlementCard({
    super.key,
    required this.deductibleController,
    required this.insuranceController,
    required this.lumpSumController,
    required this.isLumpSum,
    required this.readOnly,
    required this.onLumpSumChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Settlement Details',
      icon: Icons.account_balance_wallet_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetailFieldLabel('Deductible'),
          SizedBox(height: 8.h),
          customerDetailSizedTextField(
            controller: deductibleController,
            readOnly: readOnly,
            keyboardType: TextInputType.number,
            hintText: '0',
          ),
          customerDetailFieldGap(),
          customerDetailFieldLabel('Under Insurance'),
          SizedBox(height: 8.h),
          customerDetailSizedTextField(
            controller: insuranceController,
            readOnly: readOnly,
            keyboardType: TextInputType.number,
            hintText: '0',
          ),
          customerDetailFieldGap(),
          CheckboxListTile(
            value: isLumpSum,
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: ColorConstants.primaryColor,
            onChanged: readOnly ? null : onLumpSumChanged,
            title: Text(
              'Lump Sum Settlement',
              style: TextStyle(
                fontSize: FontSizes.normalText1,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          if (isLumpSum) ...[
            SizedBox(height: 8.h),
            customerDetailFieldLabel('Lump Sum Amount'),
            SizedBox(height: 8.h),
            customerDetailSizedTextField(
              controller: lumpSumController,
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              hintText: '0',
            ),
          ],
        ],
      ),
    );
  }
}
