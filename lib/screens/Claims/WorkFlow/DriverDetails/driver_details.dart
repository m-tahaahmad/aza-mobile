import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/VehicleMakeModel/vehicle_make_response_model.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/Services/CustomerDetailServices/update_single_customer.dart';
import 'package:icms_app/Services/VehicleMakeService/vehicle_make_service.dart';
import 'package:icms_app/components/workflow/workflow_async_body.dart';
import 'package:icms_app/components/claims/customer_detail_bottom_bar.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:provider/provider.dart';
import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Model/Workflow/workflow_response_model.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/globals.dart';
import 'vehicle_information.dart';
import 'driver_information.dart';

class DriverDetailsScreen extends StatefulWidget {
  final int? id;
  final bool comeFromThirdParty;

  const DriverDetailsScreen({super.key, this.id, this.comeFromThirdParty = false});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  String notAvailable = '';
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;
  Future<ApiResponse<VehicleMakeResponseModel>>? _getVehicleMake;
  Future<List<ApiResponse<dynamic>?>>? apisList;
  bool isLoading = false;
  bool isFinalizing = false;

  @override
  void initState() {
    super.initState();
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    _getVehicleMake = VehicleMakeService().getAllVehicleMake(context);
    apisList = Future.wait([_getCustomerDetails!, _getVehicleMake!]);
  }

  Future _handleRefresh() async {
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    _getVehicleMake = VehicleMakeService().getAllVehicleMake(context);
    apisList = Future.wait([_getCustomerDetails!, _getVehicleMake!]);
    await Future.delayed(const Duration(milliseconds: 1500));
    return apisList;
  }

  bool get _showBottomBar =>
      claimsType != 'Waiting for approval' &&
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
              fallback: 'Failed to load driver details.',
            );
            if (gate != null) return gate;

            return Consumer2<CustomerDetailProvider, WorkflowProvider>(
              builder: (context, customerDetailProvider, workflowProvider, child) {
                final customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
                if (customerDetailData == null) {
                  return workflowLoadMessage('Failed to load driver details.');
                }

                return SafeArea(
                  child: Column(
                    children: [
                      WorkflowPageHeader(
                        title: 'Driver Details',
                        subtitle: 'License & odometer reading',
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                          children: [
                            DriverInformation(
                              licenseName: widget.comeFromThirdParty
                                  ? customerDetailData.thirdPartyDetail?.driverName ?? notAvailable
                                  : customerDetailData.vehicle?.licenseName ?? notAvailable,
                              licenseNumber: widget.comeFromThirdParty
                                  ? customerDetailData.thirdPartyDetail?.licenseNo ?? notAvailable
                                  : customerDetailData.vehicle?.licenseNo ?? notAvailable,
                              licenseExpiry: widget.comeFromThirdParty
                                  ? customerDetailData.thirdPartyDetail?.licenseExpiry ?? notAvailable
                                  : customerDetailData.vehicle?.licenseExpiry ?? notAvailable,
                              mileage: customerDetailData.vehicle?.millage ?? notAvailable,
                              comeFromThirdParty: widget.comeFromThirdParty,
                            ),
                            if (widget.comeFromThirdParty)
                              VehicleInformation(
                                registrationNo: customerDetailData.thirdPartyDetail?.regNo ?? notAvailable,
                                engineNo: customerDetailData.thirdPartyDetail?.engineNo ?? notAvailable,
                                chassisNo: customerDetailData.thirdPartyDetail?.chassisNo ?? notAvailable,
                                horsePower: customerDetailData.thirdPartyDetail?.horsePower ?? notAvailable,
                                make: customerDetailData.thirdPartyDetail?.makeId ?? 0,
                                modelYear: customerDetailData.thirdPartyDetail?.model ?? notAvailable,
                              ),
                          ],
                        ),
                      ),
                      if (_showBottomBar)
                        CustomerDetailBottomBar(
                          isLoading: isLoading,
                          isFinalizing: isFinalizing,
                          showDone: !widget.comeFromThirdParty,
                          onSave: () {
                            saveDriverDetails(
                              customerDetailProvider: customerDetailProvider,
                              id: customerDetailData.id,
                              isThirdParty: widget.comeFromThirdParty,
                            );
                          },
                          onDone: () {
                            saveDriverDetails(
                              customerDetailProvider: customerDetailProvider,
                              id: customerDetailData.id,
                              isDone: true,
                              workflowProvider: workflowProvider,
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

  saveDriverDetails({
    required CustomerDetailProvider customerDetailProvider,
    int? id,
    bool isDone = false,
    WorkflowProvider? workflowProvider,
    bool isThirdParty = false,
  }) {
    setState(() {
      isLoading = true;
    });
    if (!isThirdParty &&
        claimsType == '1st Inspection' &&
        customerDetailProvider.odometerController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Odometer is required');
      return;
    }
    Map<String, Map<String, Map<String, Object?>>> body;
    if (isThirdParty) {
      body = {
        'data': {
          'third_party_detail': {
            'claim_id': claimId,
            'driver_name': customerDetailProvider.licenseNameController.text.trim(),
            'license_no': customerDetailProvider.licenseNumberController.text.trim(),
            'license_expiry': customerDetailProvider.licenseExpiryController.text,
            'reg_no': customerDetailProvider.registrationNoController.text.trim(),
            'engine_no': customerDetailProvider.engineNoController.text.trim(),
            'chassis_no': customerDetailProvider.chassisNoController.text.trim(),
            'horse_power': customerDetailProvider.horsePowerController.text.trim(),
            'make_id': customerDetailProvider.selectedVehicleMakeId,
            'model': customerDetailProvider.modelYearController.text.trim(),
          }
        }
      };
    } else {
      body = {
        'data': {
          'vehicle': {
            'license_name': customerDetailProvider.licenseNameController.text.trim(),
            'license_no': customerDetailProvider.licenseNumberController.text.trim(),
            'license_expiry': customerDetailProvider.licenseExpiryController.text,
            'millage': customerDetailProvider.odometerController.text.trim()
          }
        }
      };
    }

    UpdateSingleCustomer().updateCustomerDetail(context, id, body).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Saved');
        if (isDone) {
          if (customerDetailProvider.licenseNameController.text.isNotEmpty ||
              customerDetailProvider.licenseNumberController.text.isNotEmpty ||
              customerDetailProvider.licenseExpiryController.text.isNotEmpty) {
            setState(() {
              isFinalizing = true;
            });
            var body = {
              'data': {
                'is_driver': 1,
              }
            };
            UpdateSingleCustomer().updateCustomerDetail(context, id, body).then((value) {
              if (!mounted) return;
              if (value.responseData?.data == 'success') {
                setState(() {
                  isFinalizing = false;
                });
                WorkflowData? data = workflowProvider!.workflowResponseModel?.data!;
                workflowProvider.setWorkflow = WorkflowResponseModel(
                  data: WorkflowData(
                    isCustomer: data?.isCustomer,
                    isDriver: 1,
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
