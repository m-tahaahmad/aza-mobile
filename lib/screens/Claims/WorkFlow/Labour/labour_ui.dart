import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/LabourParts/labour_request_model.dart';
import 'package:icms_app/Model/LabourParts/third_party_labour_update_request_model.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:provider/provider.dart';
import '../../../../HelperFunctions/helper_functions.dart';
import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Model/Workflow/workflow_response_model.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/LabourPartsProvider/labour_parts_provider.dart';
import 'package:icms_app/components/claims/customer_detail_bottom_bar.dart';
import 'package:icms_app/components/claims/customer_detail_summary_banner.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/labour/labour_parts_section.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/Model/LabourParts/plr_labour_request_model.dart' as plr;

import 'package:icms_app/utils/json_values.dart';

import '../../../../constants/globals.dart';
import 'labour_detail_widget.dart';

class LabourUI extends StatefulWidget {
  final int? id;
  final bool comeFromThirdParty;

  const LabourUI({super.key, this.id, this.comeFromThirdParty = false});

  @override
  State<LabourUI> createState() => _LabourUIState();
}

class _LabourUIState extends State<LabourUI> {
  num plrTaxAmount = 0;
  num plrGrossAmount = 0;
  List<plr.PlrLabours> plrLaboursList = [];
  bool isLoading = false;
  bool isSaved = false;
  List<Part>? partItems;
  late CustomerDetailProvider customerDetailProvider;
  late LabourPartsProvider labourPartProvider;
  CustomerDetailData? customerDetailData;
  bool isFinalizing = false;

  @override
  void initState() {
    super.initState();
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    labourPartProvider = Provider.of<LabourPartsProvider>(context, listen: false);
    customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
    partItems = labourPartProvider.labourPartsResponseModel?.data ?? [];

    if (customerDetailData == null) return;

    if (widget.comeFromThirdParty) {
      for (final element in customerDetailData!.thirdPartyLabours ?? []) {
        labourPartProvider.addSelectedPart(element.part);
      }
    } else if (HelperFunctions().usePlrAttributes()) {
      for (final element in customerDetailData!.plrLabours ?? []) {
        labourPartProvider.addSelectedPart(element.part);
      }
    } else {
      for (final element in customerDetailData!.labours ?? []) {
        labourPartProvider.addSelectedPart(element.part);
      }
    }
  }

  bool get _showBottomBar =>
      claimsType != 'Waiting for approval' &&
      claimsType != 'Docs Pending' &&
      claimsType != 'Reports Pending';

  void _handleBack() {
    labourPartProvider.resetProvider();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (customerDetailData == null) {
      return const SafeArea(
        child: Center(child: Text('Failed to load labour details.')),
      );
    }

    return Consumer<WorkflowProvider>(
      builder: (context, workflowProvider, child) {
        return SafeArea(
          child: Column(
            children: [
              WorkflowPageHeader(
                title: 'Labour',
                subtitle: 'Repair estimate',
                onBack: _handleBack,
              ),
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                  children: [
                    CustomerDetailSummaryBanner(
                      claimNo: customerDetailData!.intimationNo,
                      regNo: customerDetailData!.regNo,
                      branchName: customerDetailData!.policy?.insuranceCompany?.name,
                    ),
                    LabourDetailWidget(
                      plrDemand: customerDetailData?.plrDemandLabour ?? notAvailable,
                      plrAgreed: widget.comeFromThirdParty
                          ? customerDetailData?.thirdPartyDetail?.agreedLabor.toString() ?? notAvailable
                          : HelperFunctions().usePlrAttributes()
                              ? customerDetailData?.plrAgreedLabour ?? notAvailable
                              : customerDetailData?.agreedLabour ?? notAvailable,
                      plrTaxRate: widget.comeFromThirdParty
                          ? customerDetailData?.thirdPartyDetail?.taxRate.toString() ?? notAvailable
                          : HelperFunctions().usePlrAttributes()
                              ? customerDetailData?.plrTaxRate ?? notAvailable
                              : customerDetailData?.taxRate ?? notAvailable,
                      comeFromThirdParty: widget.comeFromThirdParty,
                    ),
                    LabourPartsSection(partItems: partItems),
                  ],
                ),
              ),
              if (_showBottomBar)
                CustomerDetailBottomBar(
                  isLoading: isLoading,
                  isFinalizing: isFinalizing,
                  showDone: !widget.comeFromThirdParty,
                  onSave: () => saveLaborParts(isThirdParty: widget.comeFromThirdParty),
                  onDone: () => saveLaborParts(isDone: true),
                ),
            ],
          ),
        );
      },
    );
  }

  int? _labourAmount(String text, String field) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return readInt(trimmed, field: field);
  }

  saveLaborParts({bool isDone = false, bool isThirdParty = false}) {
    final demand = _labourAmount(labourPartProvider.demandController.text, 'demand');
    final settled = _labourAmount(labourPartProvider.settledController.text, 'settled');
    final tax = _labourAmount(labourPartProvider.taxController.text, 'tax');
    if (demand == null || settled == null || tax == null) {
      showSnackBar(context, 'Enter a valid number');
      return;
    }

    dynamic requestModel;
    plrLaboursList = [];
    setState(() {
      isLoading = true;
    });
    if (labourPartProvider.settledController.text.trim().isNotEmpty &&
        labourPartProvider.taxController.text.trim().isNotEmpty) {
      plrTaxAmount = tax / 100 * settled;
      plrGrossAmount = plrTaxAmount + settled;
    }

    for (var element in labourPartProvider.selectedParts) {
      plrLaboursList.add(plr.PlrLabours(
        claimId: customerDetailData!.id,
        partId: element!.id,
        rate: '0',
        type: isThirdParty
            ? 'THIRDPARTY'
            : HelperFunctions().usePlrAttributes()
                ? 'PLR'
                : 'FINAL',
        status: 'YES',
      ));
    }

    if (isThirdParty) {
      requestModel = ThirdPartyLaborUpdateRequestModel(
        data: ThirdPartyLaborUpdateData(
          thirdPartyDetail: ThirdPartyLaborDetail(
            claimId: claimId,
            agreedLabor: settled,
            taxRate: tax,
            taxAmount: plrTaxAmount.toInt(),
            grossAmount: plrGrossAmount.toInt(),
          ),
          thirdPartyLabours: plrLaboursList,
        ),
      );
    } else if (HelperFunctions().usePlrAttributes()) {
      requestModel = plr.PLRLabourRequestModel(
        data: plr.PLRLabourRequestData(
          plrDemandLabour: demand,
          plrAgreedLabour: settled,
          plrTaxRate: tax,
          plrTaxAmount: plrTaxAmount.toInt(),
          plrGrossAmount: plrGrossAmount.toInt(),
          plrLabours: plrLaboursList,
        ),
      );
    } else {
      requestModel = LabourRequestModel(
        data: LabourRequestData(
          plrDemandLabour: demand,
          agreedLabour: settled,
          taxRate: tax,
          taxAmount: plrTaxAmount.toInt(),
          grossAmount: plrGrossAmount.toInt(),
          labours: plrLaboursList,
        ),
      );
    }

    UpdateSingleCustomer().updateCustomerDetail(context, widget.id, requestModel.toJson()).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() {
          isLoading = false;
          isSaved = true;
        });
        showSnackBar(context, 'Saved');
        if (isDone) {
          final workflowProvider = Provider.of<WorkflowProvider>(context, listen: false);
          final data = workflowProvider.workflowResponseModel?.data;
          if (labourPartProvider.selectedParts.isNotEmpty) {
            setState(() {
              isFinalizing = true;
            });
            final body = {
              'data': {
                'is_labor': 1,
              }
            };
            UpdateSingleCustomer().updateCustomerDetail(context, customerDetailData!.id, body).then((value) {
              if (!mounted) return;
              if (value.responseData?.data == 'success') {
                setState(() {
                  isFinalizing = false;
                });
                workflowProvider.setWorkflow = WorkflowResponseModel(
                  data: WorkflowData(
                    isCustomer: data!.isCustomer,
                    isDriver: data.isDriver,
                    isFirstInspPics: data.isFirstInspPics,
                    isReInspPics: data.isReInspPics,
                    isLabor: 1,
                    isParts: data.isParts,
                    isFirstInspDocs: data.isFirstInspDocs,
                    isReInspDocs: data.isReInspDocs,
                    isComments: data.isComments,
                    isReInspComment: data.isReInspComment,
                  ),
                );
                labourPartProvider.resetProvider();
                Navigator.of(context).pop(true);
              } else {
                setState(() {
                  isFinalizing = false;
                });
                showSnackBar(context, 'Something went wrong');
              }
            });
          } else {
            setState(() {
              isFinalizing = false;
            });
            showSnackBar(context, 'Details are missing!!!');
          }
        } else {
          labourPartProvider.resetProvider();
          Navigator.pop(context, true);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Something went wrong');
      }
    });
  }
}
