import 'package:flutter/material.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:provider/provider.dart';

import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';

class ThirdPartyCustomerDetails extends StatefulWidget {
  final String? name;
  final String? address;
  final String? inspectionPlace;
  final String? estimatedLoss;

  const ThirdPartyCustomerDetails({
    super.key,
    this.name,
    this.address,
    this.inspectionPlace,
    this.estimatedLoss,
  });

  @override
  State<ThirdPartyCustomerDetails> createState() => _ThirdPartyCustomerDetailsState();
}

class _ThirdPartyCustomerDetailsState extends State<ThirdPartyCustomerDetails> {
  late CustomerDetailProvider customerDetailProvider;

  @override
  void initState() {
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    super.initState();
    customerDetailProvider.nameController.text = widget.name ?? '';
    customerDetailProvider.addressController.text = widget.address ?? '';
    customerDetailProvider.inspectionPlaceController.text = widget.inspectionPlace ?? '';
    customerDetailProvider.estimatedLossController.text = widget.estimatedLoss ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Third Party Details',
      icon: Icons.groups_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetailLabeledTextField(
            label: 'Name',
            controller: customerDetailProvider.nameController,
          ),
          customerDetailFieldGap(),
          customerDetailLabeledTextField(
            label: 'Address',
            controller: customerDetailProvider.addressController,
          ),
          customerDetailFieldGap(),
          customerDetailLabeledTextField(
            label: 'Place of Inspection',
            controller: customerDetailProvider.inspectionPlaceController,
          ),
          customerDetailFieldGap(),
          customerDetailLabeledPkrTextField(
            label: 'Estimated Loss',
            controller: customerDetailProvider.estimatedLossController,
          ),
        ],
      ),
    );
  }
}
