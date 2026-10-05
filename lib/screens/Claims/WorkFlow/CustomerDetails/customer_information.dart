import 'package:flutter/material.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:provider/provider.dart';

class CustomerInformation extends StatefulWidget {
  final String? name;
  final String? contact;

  const CustomerInformation({super.key, this.name, this.contact});

  @override
  State<CustomerInformation> createState() => _CustomerInformationState();
}

class _CustomerInformationState extends State<CustomerInformation> {
  late CustomerDetailProvider customerDetailProvider;

  bool get _readOnly =>
      claimsType == 'Waiting for approval' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';

  @override
  void initState() {
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    super.initState();
    customerDetailProvider.nameController.text = widget.name ?? '';
    customerDetailProvider.contactController.text = widget.contact ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Customer Information',
      icon: Icons.person_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetailLabeledTextField(
            label: 'Customer Name',
            controller: customerDetailProvider.nameController,
            readOnly: _readOnly,
          ),
          customerDetailFieldGap(),
          customerDetailLabeledTextField(
            label: 'Customer Contact',
            controller: customerDetailProvider.contactController,
            readOnly: _readOnly,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
