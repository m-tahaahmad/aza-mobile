import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/WorkshopsProvider/workshops_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/workshops/workshop_picker_sheet.dart';
import 'package:provider/provider.dart';

import '../../../../Model/WorkshopsModel/all_workshops_model.dart';
import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/font_sizes.dart';
import '../../../../constants/globals.dart';

class WorkshopDetails extends StatefulWidget {
  final String? name;
  final int? workshopId;
  final String? amount;
  final String? payment;

  const WorkshopDetails({
    super.key,
    this.name,
    this.workshopId,
    this.amount,
    this.payment,
  });

  @override
  State<WorkshopDetails> createState() => _WorkshopDetailsState();
}

class _WorkshopDetailsState extends State<WorkshopDetails> {
  late CustomerDetailProvider customerDetailProvider;
  late final TextEditingController _workshopNameController;
  final List<String> paymentOptions = ['Workshop', 'Insured', 'Double'];

  bool get _readOnly =>
      claimsType == 'Waiting for approval' ||
      claimsType == 'Re-Inspections Pending' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';

  @override
  void initState() {
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    super.initState();
    customerDetailProvider.selectedWorkShop = widget.name;
    customerDetailProvider.selectedWorkshopId = widget.workshopId;
    customerDetailProvider.amountController.text = widget.amount ?? '';
    customerDetailProvider.selectedPaymentType = widget.payment;
    _workshopNameController = TextEditingController(text: _displayWorkshopName(widget.name));
  }

  @override
  void dispose() {
    _workshopNameController.dispose();
    super.dispose();
  }

  String _displayWorkshopName(String? name) {
    if (name == null || name.isEmpty) return '';
    return name;
  }

  WorkshopsData? get _selectedWorkshop {
    final id = customerDetailProvider.selectedWorkshopId;
    final name = customerDetailProvider.selectedWorkShop;
    if (id == null && (name == null || name.isEmpty)) return null;
    return WorkshopsData(id: id, name: name);
  }

  Future<void> _openWorkshopPicker() async {
    if (_readOnly) return;

    final workshops = context.read<WorkshopsProvider>().allWorkshopsModel?.data ?? [];
    final selected = await WorkshopPickerSheet.show(
      context,
      workshops: workshops,
      selected: _selectedWorkshop,
    );

    if (!mounted || selected == null) return;

    setState(() {
      customerDetailProvider.selectedWorkShop = selected.name;
      customerDetailProvider.selectedWorkshopId = selected.id;
      _workshopNameController.text = selected.name ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Workshop Details',
      icon: Icons.home_repair_service_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetailFieldLabel('Workshop Name'),
          SizedBox(height: 8.h),
          customerDetailSizedDropdown(
            child: TextField(
              controller: _workshopNameController,
              readOnly: true,
              onTap: _readOnly ? null : _openWorkshopPicker,
              style: customerDetailInputTextStyle(),
              textAlignVertical: TextAlignVertical.center,
              decoration: customerDetailInputFieldDecoration(hintText: 'Select workshop').copyWith(
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 22.sp,
                  color: _readOnly ? const Color(0xFF98A2B3) : ColorConstants.primaryColor,
                ),
              ),
            ),
          ),
          customerDetailFieldGap(),
          customerDetailLabeledPkrTextField(
            label: 'Estimated Amount',
            controller: customerDetailProvider.amountController,
          ),
          customerDetailFieldGap(),
          customerDetailFieldLabel('Payment'),
          SizedBox(height: 8.h),
          customerDetailSizedDropdown(
            child: DropdownSearch<String>(
              enabled: !_readOnly,
              items: (_, __) => paymentOptions,
              itemAsString: (String u) => u,
              onChanged: (String? data) {
                customerDetailProvider.selectedPaymentType = data;
              },
              suffixProps: customerDetailDropdownSuffixProps,
              decoratorProps: customerDetailDropDownDecoratorProps(hintText: 'Select payment method'),
              popupProps: PopupProps.menu(
                itemBuilder: (context, i, e, _) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.sp),
                    child: Text(i, style: TextStyle(fontSize: FontSizes.smallText)),
                  );
                },
                constraints: BoxConstraints(maxHeight: 105.sp),
              ),
              selectedItem: customerDetailProvider.selectedPaymentType,
            ),
          ),
        ],
      ),
    );
  }
}
