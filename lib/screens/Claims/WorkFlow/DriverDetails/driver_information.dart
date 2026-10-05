import 'package:flutter/material.dart';
import 'package:icms_app/HelperFunctions/helper_functions.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:provider/provider.dart';

bool driverDetailsFieldReadOnly() {
  if (claimsType == '1st Inspection' ||
      claimsType == 'Re-Inspections Pending' ||
      claimsType == 'Rejected') {
    return false;
  }
  if (claimsType == 'Waiting for approval' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending') {
    return true;
  }
  return false;
}

bool driverDetailsDateReadOnly() {
  return claimsType == 'Waiting for approval' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';
}

class DriverInformation extends StatefulWidget {
  final String? licenseName;
  final String? licenseNumber;
  final String? licenseExpiry;
  final String? mileage;
  final bool comeFromThirdParty;

  const DriverInformation({
    super.key,
    this.licenseName,
    this.licenseNumber,
    this.comeFromThirdParty = false,
    this.licenseExpiry,
    this.mileage,
  });

  @override
  State<DriverInformation> createState() => _DriverInformationState();
}

class _DriverInformationState extends State<DriverInformation> {
  late CustomerDetailProvider customerDetailProvider;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    super.initState();
    customerDetailProvider.licenseNameController.text = widget.licenseName ?? '';
    customerDetailProvider.licenseNumberController.text = widget.licenseNumber ?? '';
    customerDetailProvider.licenseExpiryController.text = widget.licenseExpiry ?? '';
    customerDetailProvider.odometerController.text = widget.mileage ?? '';
  }

  void _pickLicenseExpiry() {
    if (driverDetailsDateReadOnly()) return;
    HelperFunctions().selectDate(context, selectedDate, (date) {
      customerDetailProvider.licenseExpiryController.text = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = driverDetailsFieldReadOnly();
    final dateReadOnly = driverDetailsDateReadOnly();
    final odometerRequired = claimsType == '1st Inspection';

    return CustomerDetailSectionCard(
      title: "Driver's Information",
      icon: Icons.badge_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetailLabeledTextField(
            label: 'License Name',
            controller: customerDetailProvider.licenseNameController,
            readOnly: readOnly,
            hintText: 'Name as on license',
          ),
          customerDetailFieldGap(),
          customerDetailLabeledTextField(
            label: 'License No',
            controller: customerDetailProvider.licenseNumberController,
            readOnly: readOnly,
            hintText: 'e.g. LHR-2024-XXXX',
          ),
          customerDetailFieldGap(),
          customerDetailLabeledDateField(
            label: 'License Expiry',
            controller: customerDetailProvider.licenseExpiryController,
            readOnly: dateReadOnly,
            onTap: _pickLicenseExpiry,
          ),
          if (!widget.comeFromThirdParty) ...[
            customerDetailFieldGap(),
            customerDetailLabeledSuffixTextField(
              label: 'Odometer',
              controller: customerDetailProvider.odometerController,
              suffixText: 'km',
              hintText: 'Current reading',
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              isRequired: odometerRequired,
              helperText: odometerRequired
                  ? 'Required — record the reading shown on the dashboard.'
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}
