import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/components/claims/customer_detail_bottom_bar.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/claims/customer_detail_summary_banner.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/parts/parts_helpers.dart';
import 'package:icms_app/components/parts/parts_net_payable_banner.dart';
import 'package:icms_app/components/parts/parts_settlement_card.dart';
import 'package:icms_app/components/parts/parts_summary_row.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/utils/json_values.dart';
import 'package:provider/provider.dart';

import '../../../../HelperFunctions/helper_functions.dart';
import '../../../../Model/Workflow/workflow_response_model.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../constants/globals.dart';

class TotalAmountScreen extends StatefulWidget {
  final String? grossTotal;
  final String? sdGrossTotal;
  final String? depAmount;
  final String? sdDepAmount;
  final String? gst;
  final String? gstAmount;
  final String? sdGstAmount;
  final String? salAmount;
  final String? sdSalAmount;
  final String? subTotal;
  final String? sdSubTotal;
  final String? grandTotal;
  final int? sdLength;
  final bool isThirdParty;

  const TotalAmountScreen({
    super.key,
    this.grossTotal,
    this.depAmount,
    this.gst,
    this.gstAmount,
    this.salAmount,
    this.subTotal,
    this.sdGrossTotal,
    this.sdDepAmount,
    this.sdGstAmount,
    this.sdSalAmount,
    this.sdSubTotal,
    this.grandTotal,
    this.sdLength,
    this.isThirdParty = false,
  });

  @override
  State<TotalAmountScreen> createState() => _TotalAmountScreenState();
}

class _TotalAmountScreenState extends State<TotalAmountScreen> {
  bool isLoading = false;
  bool isFinalizing = false;
  bool isLumpSump = false;
  TextEditingController lumpSumpController = TextEditingController();
  TextEditingController deductibleController = TextEditingController();
  TextEditingController insuranceController = TextEditingController();
  late CustomerDetailProvider customerDetailProvider;
  CustomerDetailData? customerDetailData;

  @override
  void initState() {
    super.initState();
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
    lumpSumpController.text = customerDetailData?.workshop?.lumpSumpAmount ?? '';
    deductibleController.text = customerDetailData?.policy?.deductible ?? '';
    insuranceController.text = customerDetailData?.policy?.underInsuranceAmount ?? '';
    if (customerDetailData?.workshop?.lumpSumpAmount != null && customerDetailData!.workshop!.lumpSumpAmount != '0') {
      isLumpSump = true;
    }
  }

  @override
  void dispose() {
    lumpSumpController.dispose();
    deductibleController.dispose();
    insuranceController.dispose();
    super.dispose();
  }

  bool get _showBottomBar => !partsFieldsReadOnly();

  String get _settledLabour => widget.isThirdParty
      ? customerDetailData?.thirdPartyDetail?.agreedLabor ?? notAvailable
      : HelperFunctions().usePlrAttributes()
          ? customerDetailData?.plrAgreedLabour ?? notAvailable
          : customerDetailData?.agreedLabour ?? notAvailable;

  String get _salesTax => widget.isThirdParty
      ? customerDetailData?.thirdPartyDetail?.taxAmount ?? notAvailable
      : HelperFunctions().usePlrAttributes()
          ? customerDetailData?.plrTaxAmount ?? notAvailable
          : customerDetailData?.taxAmount ?? notAvailable;

  String get _taxValue => widget.isThirdParty
      ? customerDetailData?.thirdPartyDetail?.taxRate ?? notAvailable
      : HelperFunctions().usePlrAttributes()
          ? customerDetailData?.plrTaxRate ?? notAvailable
          : customerDetailData?.taxRate ?? notAvailable;

  String get _totalLabour => widget.isThirdParty
      ? customerDetailData?.thirdPartyDetail?.grossAmount ?? notAvailable
      : HelperFunctions().usePlrAttributes()
          ? customerDetailData?.plrGrossAmount ?? notAvailable
          : customerDetailData?.grossAmount ?? notAvailable;

  int _parse(String? value) => readIntOrZero(value, field: 'amount');

  String _afterDep(String? gross, String? dep) => '${_parse(gross) - _parse(dep)}';

  String _afterGst(String? gross, String? dep, String? gstAmount) =>
      '${_parse(gross) - _parse(dep) + _parse(gstAmount)}';

  String _afterSal(String? gross, String? dep, String? gstAmount, String? sal) =>
      '${_parse(gross) - _parse(dep) + _parse(gstAmount) - _parse(sal)}';

  String calculateTotalNetPayable() {
    final labourGross = widget.isThirdParty
        ? customerDetailData?.thirdPartyDetail?.grossAmount ?? '0'
        : HelperFunctions().usePlrAttributes()
            ? customerDetailData?.plrGrossAmount ?? '0'
            : customerDetailData?.grossAmount ?? '0';
    final deductible = deductibleController.text.isNotEmpty ? deductibleController.text : '0';
    final insurance = insuranceController.text.isNotEmpty ? insuranceController.text : '0';
    return '${_parse(labourGross) + _parse(widget.grandTotal) - _parse(deductible) - _parse(insurance)}';
  }

  @override
  Widget build(BuildContext context) {
    if (customerDetailData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F5F9),
        body: SafeArea(child: Center(child: Text('Failed to load settlement details.'))),
      );
    }

    final netPayable = isLumpSump ? lumpSumpController.text : calculateTotalNetPayable();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Column(
          children: [
            WorkflowPageHeader(
              title: 'Claim Estimate',
              subtitle: 'Settlement summary',
              onBack: () => Navigator.of(context).pop(),
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
                  CustomerDetailSectionCard(
                    title: 'Labour Summary',
                    icon: Icons.handyman_outlined,
                    child: Column(
                      children: [
                        PartsSummaryRow(label: 'Settled Labour', value: formatPkrAmount(_settledLabour)),
                        customerDetailDivider(),
                        PartsSummaryRow(
                          label: 'Sales Tax',
                          value: formatPkrAmount(_salesTax),
                          suffix: _taxValue != notAvailable ? ' ($_taxValue%)' : null,
                        ),
                        customerDetailDivider(),
                        PartsSummaryRow(
                          label: 'Total Labour',
                          value: formatPkrAmount(_totalLabour),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  CustomerDetailSectionCard(
                    title: 'Parts Summary',
                    icon: Icons.build_outlined,
                    child: Column(
                      children: [
                        PartsSummaryRow(label: 'Costs of parts replaced', value: formatPkrAmount(widget.grossTotal)),
                        customerDetailDivider(),
                        PartsSummaryRow(
                          label: 'Depreciation Amount',
                          value: formatPkrAmount(widget.depAmount),
                          isDeduction: true,
                        ),
                        customerDetailDivider(),
                        PartsSummaryRow(
                          label: 'After Depreciation',
                          value: formatPkrAmount(_afterDep(widget.grossTotal, widget.depAmount)),
                        ),
                        customerDetailDivider(),
                        PartsSummaryRow(
                          label: 'GST Parts',
                          value: formatPkrAmount(widget.gstAmount),
                          suffix: widget.gst != null ? ' (${widget.gst}%)' : null,
                        ),
                        customerDetailDivider(),
                        PartsSummaryRow(
                          label: 'After GST',
                          value: formatPkrAmount(_afterGst(widget.grossTotal, widget.depAmount, widget.gstAmount)),
                        ),
                        customerDetailDivider(),
                        PartsSummaryRow(
                          label: 'Salvage',
                          value: formatPkrAmount(widget.salAmount),
                          isDeduction: true,
                        ),
                        customerDetailDivider(),
                        PartsSummaryRow(
                          label: 'SubTotal Parts Amount',
                          value: formatPkrAmount(_afterSal(widget.grossTotal, widget.depAmount, widget.gstAmount, widget.salAmount)),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  if (HelperFunctions().usePlrAttributes() && widget.sdLength != 0)
                    CustomerDetailSectionCard(
                      title: 'SD Parts Summary',
                      icon: Icons.shield_outlined,
                      child: Column(
                        children: [
                          PartsSummaryRow(label: 'Costs of parts replaced', value: formatPkrAmount(widget.sdGrossTotal)),
                          customerDetailDivider(),
                          PartsSummaryRow(
                            label: 'Depreciation Amount',
                            value: formatPkrAmount(widget.sdDepAmount),
                            isDeduction: true,
                          ),
                          customerDetailDivider(),
                          PartsSummaryRow(
                            label: 'After Depreciation',
                            value: formatPkrAmount(_afterDep(widget.sdGrossTotal, widget.sdDepAmount)),
                          ),
                          customerDetailDivider(),
                          PartsSummaryRow(
                            label: 'GST SD Parts',
                            value: formatPkrAmount(widget.sdGstAmount),
                            suffix: widget.gst != null ? ' (${widget.gst}%)' : null,
                          ),
                          customerDetailDivider(),
                          PartsSummaryRow(
                            label: 'Salvage',
                            value: formatPkrAmount(widget.sdSalAmount),
                            isDeduction: true,
                          ),
                          customerDetailDivider(),
                          PartsSummaryRow(
                            label: 'SubTotal SD Parts',
                            value: formatPkrAmount(widget.sdSubTotal),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  if (!widget.isThirdParty)
                    PartsSettlementCard(
                      deductibleController: deductibleController,
                      insuranceController: insuranceController,
                      lumpSumController: lumpSumpController,
                      isLumpSum: isLumpSump,
                      readOnly: partsFieldsReadOnly(),
                      onLumpSumChanged: (value) => setState(() => isLumpSump = value ?? false),
                    ),
                  PartsNetPayableBanner(amount: netPayable),
                ],
              ),
            ),
            if (_showBottomBar)
              CustomerDetailBottomBar(
                isLoading: isLoading,
                isFinalizing: isFinalizing,
                showDone: !widget.isThirdParty,
                onSave: () async {
                  if (widget.isThirdParty) {
                    Navigator.of(context)
                      ..pop()
                      ..pop(true);
                  } else {
                    savePartsInvolvedTotalAmount();
                  }
                },
                onDone: () => savePartsInvolvedTotalAmount(isDone: true),
              ),
          ],
        ),
      ),
    );
  }

  savePartsInvolvedTotalAmount({bool isDone = false}) async {
    setState(() {
      isLoading = true;
    });
    dynamic updateBody;
    if (isLumpSump) {
      updateBody = {
        'data': {
          'workshop': {
            'lump_sump_amount': lumpSumpController.text.toString(),
          }
        }
      };
    } else {
      updateBody = HelperFunctions().usePlrAttributes()
          ? {
              'data': {
                'plr_net_total': widget.subTotal,
                'policy': {
                  'deductible': deductibleController.text,
                  'under_insurance_amount': insuranceController.text,
                }
              }
            }
          : {
              'data': {
                'net_total': widget.subTotal,
                'policy': {
                  'deductible': deductibleController.text,
                  'under_insurance_amount': insuranceController.text,
                }
              }
            };
    }
    await UpdateSingleCustomer().updateCustomerDetail(context, customerDetailData!.id, updateBody).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Saved');
        if (isDone) {
          setState(() {
            isFinalizing = true;
          });
          var workflowProvider = Provider.of<WorkflowProvider>(context, listen: false);
          var data = workflowProvider.workflowResponseModel?.data;
          var body = {
            'data': {
              'is_parts': 1,
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
                  isLabor: data.isLabor,
                  isParts: 1,
                  isFirstInspDocs: data.isFirstInspDocs,
                  isReInspDocs: data.isReInspDocs,
                  isComments: data.isComments,
                  isReInspComment: data.isReInspComment,
                ),
              );
              Navigator.of(context)
                ..pop()
                ..pop(true);
            } else {
              setState(() {
                isFinalizing = false;
              });
              showSnackBar(context, 'Something went wrong!!!');
            }
          });
        } else {
          Navigator.of(context)
            ..pop()
            ..pop(true);
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
