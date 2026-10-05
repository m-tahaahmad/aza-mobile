import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/VehicleMakeModel/vehicle_make_response_model.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/VehicleMakeProvider/vehicle_make_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:provider/provider.dart';

import '../../../../constants/font_sizes.dart';
import 'driver_information.dart';

class VehicleInformation extends StatefulWidget {
  final String? registrationNo;
  final String? engineNo;
  final String? chassisNo;
  final String? horsePower;
  final int? make;
  final String? modelYear;

  const VehicleInformation({
    super.key,
    this.registrationNo,
    this.engineNo,
    this.chassisNo,
    this.horsePower,
    this.make,
    this.modelYear,
  });

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  late CustomerDetailProvider customerDetailProvider;

  bool get _textReadOnly => driverDetailsFieldReadOnly();

  bool get _dropdownReadOnly =>
      claimsType == 'Waiting for approval' ||
      claimsType == 'Re-Inspections Pending' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';

  @override
  void initState() {
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    super.initState();
    customerDetailProvider.registrationNoController.text = widget.registrationNo ?? '';
    customerDetailProvider.engineNoController.text = widget.engineNo ?? '';
    customerDetailProvider.chassisNoController.text = widget.chassisNo ?? '';
    customerDetailProvider.horsePowerController.text = widget.horsePower ?? '';
    customerDetailProvider.selectedVehicleMakeId = widget.make ?? 0;
    customerDetailProvider.modelYearController.text = widget.modelYear ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Vehicle Information',
      icon: Icons.directions_car_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetailLabeledTextField(
            label: 'Reg No',
            controller: customerDetailProvider.registrationNoController,
            readOnly: _textReadOnly,
          ),
          customerDetailFieldGap(),
          customerDetailLabeledTextField(
            label: 'Engine No',
            controller: customerDetailProvider.engineNoController,
            readOnly: _textReadOnly,
          ),
          customerDetailFieldGap(),
          customerDetailLabeledTextField(
            label: 'Chassis No',
            controller: customerDetailProvider.chassisNoController,
            readOnly: _textReadOnly,
          ),
          customerDetailFieldGap(),
          customerDetailLabeledTextField(
            label: 'Horse Power',
            controller: customerDetailProvider.horsePowerController,
            readOnly: _textReadOnly,
            keyboardType: TextInputType.number,
          ),
          customerDetailFieldGap(),
          customerDetailFieldLabel('Make'),
          SizedBox(height: 8.h),
          Consumer<VehicleMakeProvider>(builder: (context, vehicleMakeProvider, child) {
            return customerDetailSizedDropdown(
              child: DropdownSearch<VehicleMakeData>(
                enabled: !_dropdownReadOnly,
                items: (_, __) => vehicleMakeProvider.vehicleMakeResponseModel?.data ?? [],
                itemAsString: (VehicleMakeData u) => u.name ?? '',
                compareFn: (a, b) => a.id == b.id,
                onChanged: (VehicleMakeData? data) {
                  customerDetailProvider.selectedVehicleMake = data?.name;
                  customerDetailProvider.selectedVehicleMakeId = data?.id;
                },
                suffixProps: customerDetailDropdownSuffixProps,
                decoratorProps: customerDetailDropDownDecoratorProps(hintText: 'Select vehicle make'),
                popupProps: PopupProps.dialog(
                  showSearchBox: true,
                  itemBuilder: (context, vehicleMakeData, check, _) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(vehicleMakeData.name ?? '', style: TextStyle(fontSize: FontSizes.smallText)),
                    );
                  },
                  searchFieldProps: TextFieldProps(
                    cursorColor: ColorConstants.primaryColor,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.primaryColor),
                      ),
                    ),
                  ),
                ),
                selectedItem: _selectedMake(vehicleMakeProvider),
              ),
            );
          }),
          customerDetailFieldGap(),
          customerDetailLabeledTextField(
            label: 'Model Year',
            controller: customerDetailProvider.modelYearController,
            readOnly: _textReadOnly,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  VehicleMakeData? _selectedMake(VehicleMakeProvider vehicleMakeProvider) {
    final makes = vehicleMakeProvider.vehicleMakeResponseModel?.data ?? [];
    if (customerDetailProvider.selectedVehicleMakeId != null &&
        customerDetailProvider.selectedVehicleMakeId != 0) {
      final match = makes.where((e) => e.id == customerDetailProvider.selectedVehicleMakeId).toList();
      if (match.isNotEmpty) {
        return match.first;
      }
    }
    if (customerDetailProvider.selectedVehicleMake != null) {
      return VehicleMakeData(name: customerDetailProvider.selectedVehicleMake);
    }
    return null;
  }
}
