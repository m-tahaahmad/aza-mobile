import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_request_model.dart';
import 'package:icms_app/Model/CustomersDataModel/third_party_cd_update_request_model.dart';
import 'package:icms_app/Model/WorkshopsModel/all_workshops_model.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/Services/CustomerDetailServices/update_single_customer.dart';
import 'package:icms_app/Services/WorkshopService/workshop_service.dart';
import 'package:icms_app/components/workflow/workflow_async_body.dart';
import 'package:icms_app/components/claims/customer_detail_bottom_bar.dart';
import 'package:icms_app/components/claims/customer_detail_summary_banner.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/claim_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/customer_information.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/insurance_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/pre_inspection_customer_detail.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/third_party_customer_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/workshop_details.dart';
import 'package:icms_app/utils/date_utils.dart';
import 'package:provider/provider.dart';
import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Model/Workflow/workflow_response_model.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/globals.dart';
import '../../../../constants/keys_constants.dart';
import '../../../../Services/SharedPreferenceService/shared_preferences_service.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final int? id;
  final bool comeFromThirdParty;

  const CustomerDetailsScreen({super.key, this.id, this.comeFromThirdParty = false});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  String notAvailable = '';
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;
  Future<ApiResponse<AllWorkshopsModel>>? _getWorkshops;
  Future<List<ApiResponse<dynamic>?>>? apisList;
  bool isLoading = false;
  bool isFinalizing = false;

  @override
  void initState() {
    super.initState();
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    _getWorkshops = _loadWorkshops();
    apisList = Future.wait([_getCustomerDetails!, _getWorkshops!]);
  }

  Future<ApiResponse<AllWorkshopsModel>> _loadWorkshops() async {
    var currentZoneId = zoneId;
    if (currentZoneId == null || currentZoneId.isEmpty) {
      currentZoneId = await SharedPreferencesService().getString(KeysConstants.zoneId);
      zoneId = currentZoneId;
    }
    if (!mounted) return ApiResponse.error('Widget disposed');
    return WorkshopService().getWorkshopsByZone(context, currentZoneId ?? '');
  }

  Future _handleRefresh() async {
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    _getWorkshops = _loadWorkshops();
    apisList = Future.wait([_getCustomerDetails!, _getWorkshops!]);
    await Future.delayed(const Duration(milliseconds: 1500));
    return apisList;
  }

  bool get _showBottomBar =>
      claimsType != 'Waiting for approval' &&
      claimsType != 'Re-Inspections Pending' &&
      claimsType != 'Docs Pending' &&
      claimsType != 'Reports Pending';

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorConstants.primaryColor,
      onRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        body: FutureBuilder<List<ApiResponse<dynamic>?>>(
          future: apisList,
          builder: (context, AsyncSnapshot<List<ApiResponse<dynamic>?>> snapshot) {
            final gate = workflowAsyncGate(
              snapshot: snapshot,
              fallback: 'Failed to load customer details.',
            );
            if (gate != null) return gate;

            return Consumer2<CustomerDetailProvider, WorkflowProvider>(
              builder: (context, customerDetailProvider, workflowProvider, child) {
                final customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
                if (customerDetailData == null) {
                  return workflowLoadMessage('Failed to load customer details.');
                }

                return SafeArea(
                  child: Column(
                    children: [
                      WorkflowPageHeader(
                        title: 'Customer Detail',
                        subtitle: 'Update survey details',
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                          children: _buildContent(customerDetailData),
                        ),
                      ),
                      if (_showBottomBar)
                        CustomerDetailBottomBar(
                          isLoading: isLoading,
                          isFinalizing: isFinalizing,
                          showDone: !widget.comeFromThirdParty,
                          onSave: () {
                            saveCustomerDetails(
                              customerDetailProvider: customerDetailProvider,
                              id: customerDetailData.id,
                              isThirdParty: widget.comeFromThirdParty,
                              isPreInspect: claimsType == 'pre',
                            );
                          },
                          onDone: () {
                            saveCustomerDetails(
                              customerDetailProvider: customerDetailProvider,
                              id: customerDetailData.id,
                              isDone: true,
                              workflowProvider: workflowProvider,
                              isThirdParty: widget.comeFromThirdParty,
                              isPreInspect: claimsType == 'pre',
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildContent(CustomerDetailData customerDetailData) {
    if (widget.comeFromThirdParty) {
      return [
        CustomerDetailSummaryBanner(
          claimNo: customerDetailData.intimationNo,
          regNo: customerDetailData.regNo,
          branchName: customerDetailData.policy?.insuranceCompany?.name,
        ),
        ThirdPartyCustomerDetails(
          name: customerDetailData.thirdPartyDetail?.ownerName ?? notAvailable,
          address: customerDetailData.thirdPartyDetail?.ownerAddress ?? notAvailable,
          inspectionPlace: customerDetailData.thirdPartyDetail?.placeOfInspection ?? notAvailable,
          estimatedLoss: customerDetailData.thirdPartyDetail?.estimatedLoss ?? notAvailable,
        ),
      ];
    }

    if (claimsType == 'pre') {
      return [
        CustomerDetailSummaryBanner(
          claimNo: claimId.toString(),
          regNo: customerDetailData.regNo,
          branchName: customerDetailData.policy?.insuranceCompany?.name,
        ),
        PreInspectionCustomerDetail(
          requestNo: claimId.toString(),
          regNo: customerDetailData.regNo ?? notAvailable,
          company: customerDetailData.policy?.insuranceCompany?.name ?? notAvailable,
          requestDate: formatDisplayDateValue(customerDetailData.intimationDate, fallback: notAvailable),
          inspectionDate: formatDisplayDateValue(customerDetailData.surveyDate, fallback: notAvailable),
          insuredPerson: customerDetailData.policy?.insuredName ?? notAvailable,
          insuredContact: customerDetailData.policy?.insuredContact ?? notAvailable,
          engineNo: customerDetailData.vehicle?.engineNo ?? notAvailable,
          chassisNo: customerDetailData.vehicle?.chassisNo ?? notAvailable,
          make: customerDetailData.vehicleMake?.name ?? notAvailable,
          model: customerDetailData.vehicle?.model ?? notAvailable,
        ),
      ];
    }

    return [
      CustomerDetailSummaryBanner(
        claimNo: customerDetailData.intimationNo,
        regNo: customerDetailData.regNo,
        branchName: customerDetailData.policy?.insuranceCompany?.name,
      ),
      ClaimDetails(
        surveyDate: formatDisplayDateValue(customerDetailData.surveyDate, fallback: notAvailable),
        claimDate: formatDisplayDateValue(customerDetailData.intimationDate, fallback: notAvailable),
        claimType: customerDetailData.claimType?.name ?? notAvailable,
        policeReport: customerDetailData.vehicle?.policeStation != null ? 'YES' : 'NO',
      ),
      InsuranceDetails(
        policyNum: customerDetailData.policy?.policyNo ?? notAvailable,
        lossNum: customerDetailData.lossNo ?? notAvailable,
        insuredPerson: customerDetailData.policy?.insuredName ?? notAvailable,
        regNo: customerDetailData.regNo ?? notAvailable,
        engineNo: customerDetailData.vehicle?.engineNo ?? notAvailable,
        chassisNo: customerDetailData.vehicle?.chassisNo ?? notAvailable,
        sumInsured: customerDetailData.policy?.sumInsured?.toString() ?? notAvailable,
        make: customerDetailData.vehicleMake?.name ?? notAvailable,
        model: customerDetailData.vehicle?.model ?? notAvailable,
      ),
      CustomerInformation(
        name: customerDetailData.policy?.insuredName ?? notAvailable,
        contact: customerDetailData.policy?.insuredContact ?? notAvailable,
      ),
      WorkshopDetails(
        name: customerDetailData.workshop?.workshop?.name ?? notAvailable,
        workshopId: customerDetailData.workshop?.workshopId,
        amount: customerDetailData.workshop?.lossAmount ?? notAvailable,
        payment: customerDetailData.workshop?.paymentBy ?? notAvailable,
      ),
    ];
  }

  saveCustomerDetails({
    required CustomerDetailProvider customerDetailProvider,
    int? id,
    bool isDone = false,
    WorkflowProvider? workflowProvider,
    bool isThirdParty = false,
    bool isPreInspect = false,
  }) {
    setState(() {
      isLoading = true;
    });
    dynamic customerUpdateData;
    if (isThirdParty) {
      customerUpdateData = ThirdPartyCDUpdateRequestModel(
        data: ThirdPartyUpdateData(
          thirdPartyDetail: ThirdPartyUpdateDetail(
            claimId: claimId,
            ownerName: customerDetailProvider.nameController.text.trim(),
            ownerAddress: customerDetailProvider.addressController.text.trim(),
            placeOfInspection: customerDetailProvider.inspectionPlaceController.text.trim(),
            estimatedLoss: customerDetailProvider.estimatedLossController.text,
          ),
        ),
      );
    } else if (isPreInspect) {
      customerUpdateData = {
        'data': {
          'reg_no': customerDetailProvider.registrationNoController.text.trim(),
          'policy': {
            'insured_name': customerDetailProvider.insuredPersonController.text.trim(),
            'insured_contact': customerDetailProvider.insuredContactController.text.trim(),
          }
        }
      };
    } else {
      customerUpdateData = CustomerDetailRequestModel(
        data: CustomerRequestData(
          claimTypeId: customerDetailProvider.selectedClaimType == 'ACCIDENT' ? 1 : 8,
          policy: UpdatePolicy(
            insuredName: customerDetailProvider.nameController.text.trim(),
            insuredContact: customerDetailProvider.contactController.text.trim(),
          ),
          workshop: UpdateWorkshop(
            workshopId: customerDetailProvider.selectedWorkshopId,
            lossAmount: customerDetailProvider.amountController.text.trim(),
            paymentBy: customerDetailProvider.selectedPaymentType,
          ),
        ),
      );
    }

    UpdateSingleCustomer()
        .updateCustomerDetail(context, id, isPreInspect ? customerUpdateData : customerUpdateData.toJson())
        .then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Saved');
        if (isDone) {
          if ((customerDetailProvider.nameController.text.isNotEmpty &&
                  customerDetailProvider.contactController.text.isNotEmpty &&
                  customerDetailProvider.selectedWorkShop!.isNotEmpty &&
                  customerDetailProvider.amountController.text.isNotEmpty) ||
              isPreInspect ||
              isThirdParty) {
            setState(() {
              isFinalizing = true;
            });
            var body = {
              'data': {
                'is_customer': 1,
              }
            };
            UpdateSingleCustomer().updateCustomerDetail(context, id, body).then((value) {
              if (!mounted) return;
              if (value.responseData?.data == 'success') {
                setState(() {
                  isFinalizing = false;
                });
                WorkflowData? data = workflowProvider?.workflowResponseModel?.data;
                workflowProvider?.setWorkflow = WorkflowResponseModel(
                  data: WorkflowData(
                    isCustomer: 1,
                    isDriver: data?.isDriver,
                    isFirstInspPics: data?.isFirstInspPics,
                    isReInspPics: data?.isReInspPics,
                    isLabor: data?.isLabor,
                    isParts: data?.isParts,
                    isFirstInspDocs: data?.isFirstInspDocs,
                    isReInspDocs: data?.isReInspDocs,
                    isComments: data?.isComments,
                    isReInspComment: data?.isReInspComment,
                  ),
                );
                Navigator.of(context).pop();
              }
            });
          } else {
            setState(() {
              isFinalizing = false;
            });
            showSnackBar(context, 'Details are missing!!!');
          }
        } else {
          Navigator.pop(context, customerDetailProvider.selectedClaimType == 'ACCIDENT' ? false : true);
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
