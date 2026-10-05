import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:provider/provider.dart';

import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../constants/globals.dart';

class InsuranceDetails extends StatefulWidget {
  final String? policyNum;
  final String? lossNum;
  final String? insuredPerson;
  final String? regNo;
  final String? engineNo;
  final String? chassisNo;
  final String? sumInsured;
  final String? make;
  final String? model;

  const InsuranceDetails({
    super.key,
    this.policyNum,
    this.lossNum,
    this.insuredPerson,
    this.regNo,
    this.engineNo,
    this.chassisNo,
    this.sumInsured,
    this.make,
    this.model,
  });

  @override
  State<InsuranceDetails> createState() => _InsuranceDetailsState();
}

class _InsuranceDetailsState extends State<InsuranceDetails> {
  late CustomerDetailProvider customerDetailProvider;

  bool get _regReadOnly =>
      claimsType == 'Waiting for approval' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';

  @override
  void initState() {
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    super.initState();
    customerDetailProvider.registrationNoController.text = widget.regNo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Vehicle & Insurance',
      icon: Icons.directions_car_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetailInfoRow(label: 'Policy No.', value: widget.policyNum ?? ''),
          customerDetailDivider(),
          customerDetailInfoRow(label: 'Loss No.', value: widget.lossNum ?? ''),
          customerDetailDivider(),
          customerDetailInfoRow(label: 'Insured Person', value: widget.insuredPerson ?? ''),
          customerDetailDivider(),
          customerDetailInfoRow(label: 'Engine No.', value: widget.engineNo ?? ''),
          customerDetailDivider(),
          customerDetailInfoRow(label: 'Chassis No.', value: widget.chassisNo ?? ''),
          customerDetailDivider(),
          customerDetailInfoRow(label: 'Make', value: widget.make ?? ''),
          customerDetailDivider(),
          customerDetailInfoRow(label: 'Model', value: widget.model ?? ''),
          customerDetailDivider(),
          customerDetailInfoRow(
            label: 'Sum Insured',
            value: widget.sumInsured?.toString() ?? '',
            muted: widget.sumInsured == null || widget.sumInsured.toString().isEmpty,
          ),
          customerDetailDivider(),
          customerDetailFieldLabel('Registration No.'),
          SizedBox(height: 8.h),
          customerDetailSizedTextField(
            controller: customerDetailProvider.registrationNoController,
            readOnly: _regReadOnly,
          ),
        ],
      ),
    );
  }
}
