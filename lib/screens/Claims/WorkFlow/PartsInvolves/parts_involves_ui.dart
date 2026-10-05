import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Model/LabourParts/plr_parts_involve_request_model.dart';
import 'package:icms_app/Model/LabourParts/parts_involve_request_model.dart';
import 'package:icms_app/Model/LabourParts/third_party_parts_update_request_model.dart';
import 'package:icms_app/Providers/PartsInvolveProvider/parts_involve_provider.dart';
import 'package:icms_app/components/claims/customer_detail_bottom_bar.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/claims/customer_detail_summary_banner.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/parts/parts_add_sheet.dart';
import 'package:icms_app/components/parts/parts_adjustment_controls.dart';
import 'package:icms_app/components/parts/parts_catalog_picker_sheet.dart';
import 'package:icms_app/components/parts/parts_helpers.dart';
import 'package:icms_app/components/parts/parts_part_card.dart';
import 'package:icms_app/components/parts/parts_totals_card.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/screens/Claims/WorkFlow/PartsInvolves/total_amount.dart';
import 'package:provider/provider.dart';

import '../../../../HelperFunctions/helper_functions.dart';
import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../constants/font_sizes.dart';
import '../../../../constants/globals.dart';

class PartsInvolvesUI extends StatefulWidget {
  final int? id;
  final bool comeFromThirdParty;

  const PartsInvolvesUI({super.key, this.id, this.comeFromThirdParty = false});

  @override
  State<PartsInvolvesUI> createState() => _PartsInvolvesUIState();
}

class _PartsInvolvesUIState extends State<PartsInvolvesUI> {
  bool applyDep = false;
  bool applySalvage = false;
  late CustomerDetailProvider customerDetailProvider;
  PartsInvolveProvider? partsInvolveProvider;
  CustomerDetailData? customerDetailData;
  List<PlrPartRequestDetails> requestList = [];
  bool isLoading = false;
  List<Part>? partsData;

  @override
  void initState() {
    super.initState();
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    partsInvolveProvider = Provider.of<PartsInvolveProvider>(context, listen: false);
    customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
    partsData = partsInvolveProvider!.partsResponseModel?.data ?? [];

    if (customerDetailData == null) return;

    final plrPartDetails = customerDetailData?.plrPartDetails?.toList();
    final partDetails = customerDetailData?.partDetails?.toList();
    final thirdPartyPartDetails = customerDetailData?.thirdPartyParts?.toList();

    if (partsInvolveProvider!.partDetails.isNotEmpty) {
      partsInvolveProvider!.partDetails.clear();
    }

    if (widget.comeFromThirdParty) {
      for (final element in thirdPartyPartDetails ?? []) {
        _preloadPart(element.part, element.partType, element);
      }
    } else if (HelperFunctions().usePlrAttributes()) {
      for (final element in plrPartDetails ?? []) {
        _preloadPart(element.part, element.partType, element);
      }
    } else {
      for (final element in partDetails ?? []) {
        _preloadPart(element.part, element.partType, element);
      }
    }

    partsInvolveProvider!.calculateAmount();
  }

  void _preloadPart(Part? part, String? partType, dynamic element) {
    partsInvolveProvider!.addIntoTable(
      part: part,
      condition: partType,
      depPercent: element.depPercentage != null ? int.parse(element.depPercentage!) : 0,
      depPrice: element.dep != null ? int.parse(element.dep!) : 0,
      salPercent: element.salvagePercentage != null ? int.parse(element.salvagePercentage!) : 0,
      salPrice: element.salvage != null ? num.parse(element.salvage!).toInt() : 0,
      gstPrice: element.gst != null ? int.parse(element.gst!).toInt() : 0,
      price: element.rate != null ? int.parse(element.rate!) : 0,
      subTotal: int.parse(element.partNetAmount!),
      sd: element.isSd ?? 0,
      calculate: true,
    );
    if (element.gst != null && element.gst!.isNotEmpty) {
      partsInvolveProvider!.gstController.text = element.gstPercentage!;
    }
  }

  bool get _showBottomBar => !partsFieldsReadOnly();

  void _handleBack() {
    partsInvolveProvider?.resetProvider(clearList: true, alsoGst: true);
    Navigator.of(context).pop();
  }

  Future<void> _openPartsPicker() async {
    final parts = List<Part>.from(
      partsInvolveProvider!.partsResponseModel?.data ?? partsData ?? const <Part>[],
    );

    final alreadySelectedIds = partsInvolveProvider!.partDetails
        .map((detail) => detail.part?.id)
        .whereType<int>()
        .toSet();

    final selected = await PartsCatalogPickerSheet.show(
      context,
      partItems: parts,
      alreadySelectedIds: alreadySelectedIds,
      kind: PartsCatalogKind.part,
      singleSelect: true,
    );

    if (!mounted || selected == null || selected.isEmpty) return;

    final part = selected.first;
    partsInvolveProvider!.selectedItem = part;
    partsInvolveProvider!.resetProvider();
    final saved = await PartsAddSheet.show(
      context,
      provider: partsInvolveProvider!,
      selectedPart: part,
      allowPartSelection: false,
    );
    partsInvolveProvider!.resetProvider();
    if (!mounted) return;
    if (saved == true) {
      setState(() {});
    }
  }

  Future<void> _openEditPart(int index) async {
    final detail = partsInvolveProvider!.partDetails[index];
    final saved = await PartsAddSheet.show(
      context,
      provider: partsInvolveProvider!,
      index: index,
      selectedPart: detail.part,
      price: detail.price,
      dep: detail.dep != 0 ? detail.dep : detail.depPrice,
      selectedDepType: detail.dep != 0 ? 'Percentage' : 'Price',
      sal: detail.sal != 0 ? detail.sal : detail.salPrice,
      selectedSalType: detail.sal != 0 ? 'Percentage' : 'Price',
      condition: detail.condition,
      sd: detail.sd,
      showDelete: true,
      allowPartSelection: true,
    );
    partsInvolveProvider!.resetProvider();
    if (saved == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _showDepDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => _AdjustmentDialog(
        title: 'Apply Depreciation to All',
        label: 'Depreciation %',
        controller: partsInvolveProvider!.partDepController,
        onDone: () {
          partsInvolveProvider!.applyDep(partsInvolveProvider!.partDepController.text);
          setState(() {
            applyDep = partsInvolveProvider!.partDepController.text != '0' &&
                partsInvolveProvider!.partDepController.text.isNotEmpty;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _showSalvageDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => _AdjustmentDialog(
        title: 'Apply Salvage to All',
        label: 'Salvage %',
        controller: partsInvolveProvider!.salvageController,
        onDone: () {
          partsInvolveProvider!.applySalvage(partsInvolveProvider!.salvageController.text);
          setState(() {
            applySalvage = partsInvolveProvider!.salvageController.text != '0' &&
                partsInvolveProvider!.salvageController.text.isNotEmpty;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deletePart(int index) {
    setState(() {
      partsInvolveProvider!.partDetails.removeAt(index);
      partsInvolveProvider!.calculateAmount();
      if (partsInvolveProvider!.partDetails.isEmpty) {
        partsInvolveProvider!.gstController.text = '0';
      }
    });
  }

  void onSaved({bool isThirdParty = false}) {
    dynamic requestModel;
    setState(() {
      isLoading = true;
    });
    if (requestList.isNotEmpty) {
      requestList.clear();
    }
    for (final element in partsInvolveProvider!.partDetails) {
      requestList.add(PlrPartRequestDetails(
        claimId: customerDetailData!.id,
        partId: element.part!.id,
        provider: '0',
        rate: element.price.toString(),
        gstPercentage: partsInvolveProvider!.gstController.text.isNotEmpty ? partsInvolveProvider!.gstController.text.trim() : '0',
        gst: element.gstPrice!.toInt().toString(),
        salvagePercentage: element.sal.toString(),
        salvage: element.salPrice.toInt().toString(),
        dep: element.depPrice.toInt().toString(),
        depPercentage: element.dep.toString(),
        partNetAmount: element.subTotal.toString(),
        partType: element.condition,
        isSd: element.sd,
        type: isThirdParty ? 'THIRDPARTY' : HelperFunctions().usePlrAttributes() ? 'PLR' : 'FINAL',
      ));
    }

    if (isThirdParty) {
      requestModel = ThirdPartyPartsUpdateRequestModel(
        data: ThirdPartyPartsUpdateData(
          thirdPartyDetail: ThirdPartyPartsDetail(
            claimId: claimId,
            totalParts: partsInvolveProvider!.grossTotal.toInt(),
            totalGst: partsInvolveProvider!.plrGst.toInt(),
            totalDep: partsInvolveProvider!.depreciationAmount.toInt(),
            totalSalvage: partsInvolveProvider!.plrSalvage.toInt(),
            netTotal: partsInvolveProvider!.overallTotal.toInt(),
          ),
          thirdPartyParts: requestList,
        ),
      );
    } else if (HelperFunctions().usePlrAttributes()) {
      requestModel = PLRPartInvolveRequestModel(
        data: Data(
          plrTotalParts: partsInvolveProvider!.grossTotal.toInt(),
          plrTotalGst: partsInvolveProvider!.plrGst.toInt(),
          plrTotalDep: partsInvolveProvider!.depreciationAmount.toInt(),
          plrTotalSalvage: partsInvolveProvider!.plrSalvage.toInt(),
          plrNetTotal: partsInvolveProvider!.overallTotal.toInt(),
          plrPartDetails: requestList,
        ),
      );
    } else {
      requestModel = PartsInvolveRequestModel(
        data: DataPartsInvolve(
          totalParts: partsInvolveProvider!.grossTotal.toInt(),
          totalGst: partsInvolveProvider!.plrGst.toInt(),
          totalDep: partsInvolveProvider!.depreciationAmount.toInt(),
          totalSalvage: partsInvolveProvider!.plrSalvage.toInt(),
          netTotal: partsInvolveProvider!.overallTotal.toInt(),
          partDetails: requestList,
        ),
      );
    }

    UpdateSingleCustomer().updateCustomerDetail(context, customerDetailData!.id, requestModel.toJson()).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Saved');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TotalAmountScreen(
            grossTotal: (partsInvolveProvider!.grossTotal - partsInvolveProvider!.sdGrossTotal).toString(),
            sdGrossTotal: partsInvolveProvider!.sdGrossTotal.toString(),
            depAmount: (partsInvolveProvider!.depreciationAmount - partsInvolveProvider!.sdDepreciationAmount).toString(),
            sdDepAmount: partsInvolveProvider!.sdDepreciationAmount.toString(),
            gst: partsInvolveProvider!.gstController.text.isNotEmpty ? partsInvolveProvider!.gstController.text.trim() : '0',
            gstAmount: (partsInvolveProvider!.plrGst - partsInvolveProvider!.sdPlrGst).toString(),
            sdGstAmount: partsInvolveProvider!.sdPlrGst.toString(),
            salAmount: (partsInvolveProvider!.plrSalvage - partsInvolveProvider!.sdPlrSalvage).toString(),
            sdSalAmount: partsInvolveProvider!.sdPlrSalvage.toString(),
            subTotal: (partsInvolveProvider!.overallTotal - partsInvolveProvider!.sdOverallTotal).toString(),
            sdSubTotal: partsInvolveProvider!.sdOverallTotal.toString(),
            grandTotal: partsInvolveProvider!.overallTotal.toString(),
            sdLength: partsInvolveProvider!.sdPartsLength,
            isThirdParty: isThirdParty,
          );
        }));
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Something went wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (customerDetailData == null || partsInvolveProvider == null) {
      return const SafeArea(
        child: Center(child: Text('Failed to load parts details.')),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          WorkflowPageHeader(
            title: 'Parts Involved',
            subtitle: 'Repair estimate',
            onBack: _handleBack,
          ),
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              children: [
                CustomerDetailSummaryBanner(
                  claimNo: customerDetailData!.intimationNo,
                  regNo: customerDetailData!.regNo,
                  branchName: customerDetailData!.policy?.insuranceCompany?.name,
                ),
                PartsAdjustmentControls(
                  provider: partsInvolveProvider!,
                  applyDep: applyDep,
                  applySalvage: applySalvage,
                  onApplyDep: _showDepDialog,
                  onApplySalvage: _showSalvageDialog,
                  onAddParts: _openPartsPicker,
                ),
                if (partsInvolveProvider!.partDetails.isEmpty)
                  CustomerDetailSectionCard(
                    title: 'Added Parts',
                    icon: Icons.inventory_2_outlined,
                    child: Text(
                      'No parts added yet. Tap "Add parts" to begin.',
                      style: TextStyle(
                        fontSize: FontSizes.normalText1,
                        color: const Color(0xFF98A2B3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  CustomerDetailSectionCard(
                    title: 'Added Parts',
                    icon: Icons.inventory_2_outlined,
                    child: Column(
                      children: List.generate(partsInvolveProvider!.partDetails.length, (index) {
                        final detail = partsInvolveProvider!.partDetails[index];
                        return PartsPartCard(
                          detail: detail,
                          onTap: partsFieldsReadOnly() ? null : () => _openEditPart(index),
                          onDelete: partsFieldsReadOnly() ? null : () => _deletePart(index),
                        );
                      }),
                    ),
                  ),
                PartsTotalsCard(
                  provider: partsInvolveProvider!,
                  readOnly: partsFieldsReadOnly(),
                  onGstChanged: () {
                    setState(() {
                      partsInvolveProvider!.applyGst(partsInvolveProvider!.gstController.text);
                    });
                  },
                ),
              ],
            ),
          ),
          if (_showBottomBar)
            CustomerDetailBottomBar(
              isLoading: isLoading,
              showDone: false,
              onSave: () => onSaved(isThirdParty: widget.comeFromThirdParty),
            ),
        ],
      ),
    );
  }
}

class _AdjustmentDialog extends StatelessWidget {
  final String title;
  final String label;
  final TextEditingController controller;
  final VoidCallback onDone;

  const _AdjustmentDialog({
    required this.title,
    required this.label,
    required this.controller,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: FontSizes.largeText,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16.h),
            customerDetailFieldLabel(label),
            SizedBox(height: 8.h),
            customerDetailSizedTextField(
              controller: controller,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: onDone,
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PartTableDetails {
  Part? part;
  String? condition;
  num? dep;
  num depPrice;
  num? sal;
  num salPrice;
  num? gstPrice;
  num? price;
  num? subTotal;
  int sd;

  PartTableDetails(this.part, this.condition, this.dep, this.depPrice, this.sal, this.salPrice, this.gstPrice, this.price,
      this.subTotal, this.sd);
}
