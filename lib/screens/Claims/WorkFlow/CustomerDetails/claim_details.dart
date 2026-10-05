import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:provider/provider.dart';

import '../../../../constants/font_sizes.dart';
import '../../../../constants/globals.dart';

class ClaimDetails extends StatefulWidget {
  final String? surveyDate;
  final String? claimDate;
  final String? claimType;
  final String? policeReport;

  const ClaimDetails({
    super.key,
    this.surveyDate,
    this.claimDate,
    this.claimType,
    this.policeReport,
  });

  @override
  State<ClaimDetails> createState() => _ClaimDetailsState();
}

class _ClaimDetailsState extends State<ClaimDetails> {
  final List<String> claimTypes = ['ACCIDENT', 'THIRD PARTY'];

  bool get _isReadOnly =>
      claimsType == 'Waiting for approval' ||
      claimsType == 'Re-Inspections Pending' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerDetailProvider>().setClaimType = widget.claimType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Claim Details',
      icon: Icons.description_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetailInfoRow(label: 'Survey Date', value: widget.surveyDate ?? ''),
          customerDetailDivider(),
          customerDetailInfoRow(label: 'Claim Date', value: widget.claimDate ?? ''),
          customerDetailDivider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Report to Police',
                    style: TextStyle(
                      fontSize: FontSizes.normalText1,
                      color: const Color(0xFF667085),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                customerDetailPolicePill(widget.policeReport ?? 'NO'),
              ],
            ),
          ),
          customerDetailDivider(),
          customerDetailFieldLabel('Claim Type'),
          SizedBox(height: 8.h),
          Consumer<CustomerDetailProvider>(builder: (context, customerDetailProvider, child) {
            return customerDetailSizedDropdown(
              child: DropdownSearch<String>(
                enabled: !_isReadOnly,
                items: (_, __) => claimTypes,
                itemAsString: (String u) => u,
                onChanged: (String? data) {
                  customerDetailProvider.setClaimType = data;
                },
                suffixProps: customerDetailDropdownSuffixProps,
                decoratorProps: customerDetailDropDownDecoratorProps(hintText: 'Select claim type'),
                popupProps: PopupProps.menu(
                  itemBuilder: (context, i, e, _) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.sp),
                      child: Text(i, style: TextStyle(fontSize: FontSizes.smallText)),
                    );
                  },
                  constraints: BoxConstraints(maxHeight: 80.sp),
                ),
                selectedItem: customerDetailProvider.selectedClaimType,
              ),
            );
          }),
        ],
      ),
    );
  }
}
