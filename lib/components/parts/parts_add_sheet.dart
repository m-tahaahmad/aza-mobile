import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/HelperFunctions/helper_functions.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Providers/PartsInvolveProvider/parts_involve_provider.dart';
import 'package:icms_app/Services/API/api_response.dart';
import 'package:icms_app/Services/PartsService/parts_service.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/parts/parts_helpers.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PartsAddSheet extends StatefulWidget {
  final PartsInvolveProvider provider;
  final int? index;
  final Part? selectedPart;
  final String? condition;
  final num? dep;
  final String? selectedDepType;
  final num? sal;
  final String? selectedSalType;
  final num? price;
  final int? sd;
  final bool showDelete;
  final bool allowPartSelection;

  const PartsAddSheet({
    super.key,
    required this.provider,
    this.index,
    this.selectedPart,
    this.condition,
    this.dep,
    this.selectedDepType,
    this.sal,
    this.selectedSalType,
    this.price,
    this.sd,
    this.showDelete = false,
    this.allowPartSelection = true,
  });

  static Future<bool?> show(
    BuildContext context, {
    required PartsInvolveProvider provider,
    int? index,
    Part? selectedPart,
    String? condition,
    num? dep,
    String? selectedDepType,
    num? sal,
    String? selectedSalType,
    num? price,
    int? sd,
    bool showDelete = false,
    bool allowPartSelection = true,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PartsAddSheet(
        provider: provider,
        index: index,
        selectedPart: selectedPart,
        condition: condition,
        dep: dep,
        selectedDepType: selectedDepType,
        sal: sal,
        selectedSalType: selectedSalType,
        price: price,
        sd: sd,
        showDelete: showDelete,
        allowPartSelection: allowPartSelection,
      ),
    );
  }

  @override
  State<PartsAddSheet> createState() => _PartsAddSheetState();
}

class _PartsAddSheetState extends State<PartsAddSheet> {
  static const _conditionItems = ['New', 'Used', 'N.G'];

  String? _selectedDep = 'Percentage';
  String? _selectedSalvage = 'Percentage';
  String? _selectedCondition = 'New';
  final ValueNotifier<bool?> _isSd = ValueNotifier<bool?>(false);
  final GlobalKey<DropdownSearchState<Part>> _partDropdownKey = GlobalKey<DropdownSearchState<Part>>();
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  void _prefill() {
    final provider = widget.provider;
    if (widget.selectedPart != null) {
      provider.selectedItem = widget.selectedPart;
    }
    if (widget.price != null) {
      provider.partPriceController.text = widget.price.toString();
    }
    if (widget.dep != null) {
      provider.partDepController.text = widget.dep.toString();
      _selectedDep = widget.dep == 0 ? 'Percentage' : widget.selectedDepType ?? 'Percentage';
    }
    if (widget.sal != null) {
      provider.salvageController.text = widget.sal.toString();
      _selectedSalvage = widget.sal == 0 ? 'Percentage' : widget.selectedSalType ?? 'Percentage';
    }
    if (widget.condition != null) {
      _selectedCondition = partsConditionLabel(widget.condition);
    }
    if (widget.sd == null || widget.sd == 0) {
      _isSd.value = false;
    } else {
      _isSd.value = true;
    }
  }

  @override
  void dispose() {
    _isSd.dispose();
    super.dispose();
  }

  Future<void> _createPartFromSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty || _creating) return;

    setState(() => _creating = true);
    _partDropdownKey.currentState?.updatePopupState();

    final result = await PartsService().createPart(context, trimmed);
    if (!mounted) return;

    setState(() => _creating = false);
    _partDropdownKey.currentState?.updatePopupState();

    final created = result.responseData;
    if (result.status != Status.completed || created == null) return;

    widget.provider.selectedItem = created;
    _partDropdownKey.currentState?.popupValidate([created]);
  }

  void _save() {
    final provider = widget.provider;
    if (provider.selectedItem == null ||
        provider.partPriceController.text.isEmpty ||
        _selectedCondition == null) {
      showSnackBar(context, 'Some details are missing');
      return;
    }

    final subtotal = provider.calculateSubtotal(
      dep: _selectedDep == 'Percentage' && provider.partDepController.text.isNotEmpty
          ? int.parse(provider.partDepController.text.trim())
          : 0,
      depPrice: _selectedDep == 'Price' && provider.partDepController.text.isNotEmpty
          ? int.parse(provider.partDepController.text.trim())
          : 0,
      sal: _selectedSalvage == 'Percentage' && provider.salvageController.text.trim().isNotEmpty
          ? int.parse(provider.salvageController.text.trim())
          : 0,
      salPrice: _selectedSalvage == 'Price' && provider.salvageController.text.trim().isNotEmpty
          ? int.parse(provider.salvageController.text.trim())
          : 0,
      gst: provider.gstController.text.isNotEmpty ? int.parse(provider.gstController.text.trim()) : 0,
      price: provider.partPriceController.text.isNotEmpty ? int.parse(provider.partPriceController.text.trim()) : 0,
      subtotal: 0,
    );

    final partCondition = partsConditionValue(_selectedCondition);
    final gstPrice = provider.calculatePartGst(
      provider.partPriceController.text.isNotEmpty ? int.parse(provider.partPriceController.text.trim()) : 0,
      _selectedDep == 'Percentage' && provider.partDepController.text.trim().isNotEmpty
          ? int.parse(provider.partDepController.text.trim())
          : 0,
      _selectedDep == 'Price' && provider.partDepController.text.trim().isNotEmpty
          ? int.parse(provider.partDepController.text.trim())
          : 0,
      provider.gstController.text.isNotEmpty ? int.parse(provider.gstController.text.trim()) : 0,
    );

    if (widget.index == null) {
      provider.addIntoTable(
        part: provider.selectedItem,
        condition: partCondition,
        depPercent: _selectedDep == 'Percentage' && provider.partDepController.text.trim().isNotEmpty
            ? int.parse(provider.partDepController.text.trim())
            : 0,
        depPrice: _selectedDep == 'Price' && provider.partDepController.text.trim().isNotEmpty
            ? int.parse(provider.partDepController.text.trim())
            : 0,
        salPercent: _selectedSalvage == 'Percentage' && provider.salvageController.text.trim().isNotEmpty
            ? int.parse(provider.salvageController.text.trim())
            : 0,
        salPrice: _selectedSalvage == 'Price' && provider.salvageController.text.trim().isNotEmpty
            ? int.parse(provider.salvageController.text.trim())
            : 0,
        gstPrice: gstPrice,
        price: provider.partPriceController.text.isNotEmpty ? int.parse(provider.partPriceController.text.trim()) : 0,
        subTotal: subtotal,
        sd: _isSd.value! ? 1 : 0,
      );
    } else {
      provider.updateTableIndex(
        widget.index!,
        part: provider.selectedItem,
        condition: partCondition,
        depPercent: _selectedDep == 'Percentage' && provider.partDepController.text.trim().isNotEmpty
            ? int.parse(provider.partDepController.text.trim())
            : 0,
        depPrice: _selectedDep == 'Price' && provider.partDepController.text.trim().isNotEmpty
            ? int.parse(provider.partDepController.text.trim())
            : 0,
        salPercent: _selectedSalvage == 'Percentage' && provider.salvageController.text.trim().isNotEmpty
            ? int.parse(provider.salvageController.text.trim())
            : 0,
        salPrice: _selectedSalvage == 'Price' && provider.salvageController.text.trim().isNotEmpty
            ? int.parse(provider.salvageController.text.trim())
            : 0,
        price: provider.partPriceController.text.isNotEmpty ? int.parse(provider.partPriceController.text.trim()) : 0,
        gstPrice: gstPrice,
        subTotal: subtotal,
        sd: _isSd.value! ? 1 : 0,
      );
    }

    provider.calculateAmount();
    Navigator.of(context).pop(true);
  }

  void _delete() {
    widget.provider.partDetails.removeAt(widget.index!);
    widget.provider.calculateAmount();
    if (widget.provider.partDetails.isEmpty) {
      widget.provider.gstController.text = '0';
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final parts = widget.provider.partsResponseModel?.data ?? [];

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5F9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.index == null ? 'Add part details' : 'Edit part',
                      style: TextStyle(
                        fontSize: FontSizes.largeText,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, size: 22.sp, color: const Color(0xFF667085)),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                child: CustomerDetailSectionCard(
                  title: 'Part details',
                  icon: Icons.build_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.allowPartSelection) ...[
                        customerDetailFieldLabel('Part'),
                        SizedBox(height: 8.h),
                        customerDetailSizedDropdown(
                          child: DropdownSearch<Part>(
                            key: _partDropdownKey,
                            items: (_, __) => parts,
                            itemAsString: (Part u) => u.name ?? '',
                            decoratorProps: customerDetailDropDownDecoratorProps(hintText: 'Select part'),
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                style: customerDetailInputTextStyle(),
                                decoration: customerDetailInputFieldDecoration(hintText: 'Search'),
                              ),
                              emptyBuilder: (context, searchEntry) {
                                final query = searchEntry.trim();
                                if (query.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(24.w),
                                      child: Text(
                                        'No parts found',
                                        style: TextStyle(
                                          fontSize: FontSizes.normalText1,
                                          color: const Color(0xFF98A2B3),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return ListTile(
                                  enabled: !_creating,
                                  leading: _creating
                                      ? SizedBox(
                                          width: 22.w,
                                          height: 22.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: ColorConstants.primaryColor,
                                          ),
                                        )
                                      : Icon(Icons.add, size: 22.sp, color: ColorConstants.primaryColor),
                                  title: Text(
                                    'Create "$query"',
                                    style: TextStyle(
                                      fontSize: FontSizes.normalText1,
                                      fontWeight: FontWeight.w600,
                                      color: _creating ? const Color(0xFF98A2B3) : ColorConstants.primaryColor,
                                    ),
                                  ),
                                  onTap: _creating ? null : () => _createPartFromSearch(query),
                                );
                              },
                            ),
                            onChanged: (val) => widget.provider.selectedItem = val,
                            selectedItem: widget.provider.selectedItem,
                          ),
                        ),
                        customerDetailFieldGap(),
                      ],
                      customerDetailLabeledPkrTextField(
                        label: 'Price',
                        controller: widget.provider.partPriceController,
                      ),
                      customerDetailFieldGap(),
                      customerDetailFieldLabel('Depreciation'),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: customerDetailSizedTextField(
                              controller: widget.provider.partDepController,
                              keyboardType: TextInputType.number,
                              hintText: '0',
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _TypeDropdown(
                              value: _selectedDep,
                              onChanged: (value) => setState(() => _selectedDep = value),
                            ),
                          ),
                        ],
                      ),
                      customerDetailFieldGap(),
                      customerDetailFieldLabel('Salvage'),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: customerDetailSizedTextField(
                              controller: widget.provider.salvageController,
                              keyboardType: TextInputType.number,
                              hintText: '0',
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _TypeDropdown(
                              value: _selectedSalvage,
                              onChanged: (value) => setState(() => _selectedSalvage = value),
                            ),
                          ),
                        ],
                      ),
                      customerDetailFieldGap(),
                      customerDetailFieldLabel('Condition'),
                      SizedBox(height: 8.h),
                      customerDetailSizedDropdown(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCondition,
                          decoration: customerDetailInputFieldDecoration(hintText: 'Select condition'),
                          style: customerDetailInputTextStyle(),
                          items: _conditionItems
                              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                              .toList(),
                          onChanged: (value) => setState(() => _selectedCondition = value),
                        ),
                      ),
                      if (HelperFunctions().usePlrAttributes()) ...[
                        customerDetailFieldGap(),
                        ValueListenableBuilder<bool?>(
                          valueListenable: _isSd,
                          builder: (context, value, child) {
                            return CheckboxListTile(
                              value: _isSd.value ?? false,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              activeColor: ColorConstants.primaryColor,
                              onChanged: (checked) => _isSd.value = checked,
                              title: Text(
                                'SD',
                                style: TextStyle(
                                  fontSize: FontSizes.normalText1,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2937),
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: const Color(0xFFF3F5F9),
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
              child: Row(
                children: [
                  if (widget.showDelete) ...[
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: _delete,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE53935)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: const Color(0xFFE53935),
                              fontSize: FontSizes.normalText2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                  Expanded(
                    flex: widget.showDelete ? 2 : 1,
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                        ),
                        child: Text(
                          'Save part',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: FontSizes.normalText2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _TypeDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: customerDetailInputFieldDecoration(),
      style: customerDetailInputTextStyle().copyWith(fontSize: FontSizes.smallText),
      items: const [
        DropdownMenuItem(value: 'Percentage', child: Text('%')),
        DropdownMenuItem(value: 'Price', child: Text('PKR')),
      ],
      onChanged: onChanged,
    );
  }
}
