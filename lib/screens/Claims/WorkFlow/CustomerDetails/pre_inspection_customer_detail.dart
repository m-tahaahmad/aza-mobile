import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:provider/provider.dart';

import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';

class PreInspectionCustomerDetail extends StatefulWidget {
  final String? requestNo;
  final String? regNo;
  final String? company;
  final String? requestDate;
  final String? inspectionDate;
  final String? insuredPerson;
  final String? insuredContact;
  final String? engineNo;
  final String? chassisNo;
  final String? make;
  final String? model;

  const PreInspectionCustomerDetail({
    super.key,
    this.requestNo,
    this.regNo,
    this.company,
    this.requestDate,
    this.inspectionDate,
    this.insuredPerson,
    this.insuredContact,
    this.engineNo,
    this.chassisNo,
    this.make,
    this.model,
  });

  @override
  State<PreInspectionCustomerDetail> createState() => _PreInspectionCustomerDetailState();
}

class _PreInspectionCustomerDetailState extends State<PreInspectionCustomerDetail> {
  late CustomerDetailProvider customerDetailProvider;

  @override
  void initState() {
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    super.initState();
    customerDetailProvider.registrationNoController.text = widget.regNo ?? '';
    customerDetailProvider.insuredPersonController.text = widget.insuredPerson ?? '';
    customerDetailProvider.insuredContactController.text = widget.insuredContact ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomerDetailSectionCard(
          title: 'Request Details',
          icon: Icons.description_outlined,
          child: Column(
            children: [
              customerDetailInfoRow(label: 'Request No.', value: widget.requestNo ?? ''),
              customerDetailDivider(),
              customerDetailInfoRow(label: 'Company', value: widget.company ?? ''),
              customerDetailDivider(),
              customerDetailInfoRow(label: 'Request Date', value: widget.requestDate ?? ''),
              customerDetailDivider(),
              customerDetailInfoRow(label: 'Inspection Date', value: widget.inspectionDate ?? ''),
            ],
          ),
        ),
        CustomerDetailSectionCard(
          title: 'Vehicle & Insurance',
          icon: Icons.directions_car_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customerDetailInfoRow(label: 'Engine No.', value: widget.engineNo ?? ''),
              customerDetailDivider(),
              customerDetailInfoRow(label: 'Chassis No.', value: widget.chassisNo ?? ''),
              customerDetailDivider(),
              customerDetailInfoRow(label: 'Make', value: widget.make ?? ''),
              customerDetailDivider(),
              customerDetailInfoRow(label: 'Model', value: widget.model ?? ''),
              customerDetailDivider(),
              customerDetailFieldLabel('Registration No.'),
              SizedBox(height: 8.h),
              customerDetailSizedTextField(
                controller: customerDetailProvider.registrationNoController,
              ),
            ],
          ),
        ),
        CustomerDetailSectionCard(
          title: 'Customer Information',
          icon: Icons.person_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customerDetailLabeledTextField(
                label: 'Insured Person',
                controller: customerDetailProvider.insuredPersonController,
              ),
              customerDetailFieldGap(),
              customerDetailLabeledTextField(
                label: 'Insured Contact',
                controller: customerDetailProvider.insuredContactController,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
