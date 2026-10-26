import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/claims/customer_detail_summary_card.dart';
import 'package:icms_app/components/withdraw_dialog.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/NotificationCustomerDetails/claim_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/NotificationCustomerDetails/insurance_details_notification.dart';
import 'package:icms_app/screens/Claims/WorkFlow/WorkFlow/workflow.dart';
import 'package:icms_app/utils/date_utils.dart';
import 'package:provider/provider.dart';
import '../../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../../Services/API/api_response.dart';
import '../../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../../components/workflow/workflow_async_body.dart';
import '../../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../../components/app_loader.dart';
import '../../../../../components/custom_snack_bar.dart';
import '../../../../../constants/theme_constants.dart';
import '../../../../../constants/font_sizes.dart';
import '../../WorkFlow/pre_inspection_workflow.dart';

class NotificationCustomerDetails extends StatefulWidget {
  final int? id;
  final bool isPre;

  const NotificationCustomerDetails({super.key, this.id, this.isPre = false});

  @override
  State<NotificationCustomerDetails> createState() => _NotificationCustomerDetailsState();
}

class _NotificationCustomerDetailsState
    extends State<NotificationCustomerDetails> {
  String notAvailable = '';
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;
  Future<List<ApiResponse<dynamic>>>? apisList;
  bool isLoading = false;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    _getCustomerDetails =
        CustomerDetailService().getCustomerDetail(context, widget.id);
  }

  Future _handleRefresh() async {
    _getCustomerDetails =
        CustomerDetailService().getCustomerDetail(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      color: ColorConstants.primaryColor,
      onRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        body: FutureBuilder<ApiResponse<dynamic>?>(
            future: _getCustomerDetails,
            builder: (context, AsyncSnapshot<ApiResponse<dynamic>?> snapshot) {
              final gate = workflowAsyncGate(
                snapshot: snapshot,
                fallback: 'Failed to load customer details.',
              );
              if (gate != null) return gate;

              return Consumer<CustomerDetailProvider>(
                    builder: (context, customerDetailProvider, child) {
                  final customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
                  if (customerDetailData == null) {
                    return workflowLoadMessage('Failed to load customer details.');
                  }
                  return SafeArea(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: const Color(0xFFF6F8FC),
                              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                              child: Row(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(14.r),
                                    onTap: () => Navigator.of(context).pop(true),
                                    child: Container(
                                      width: 40.w,
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F6FB),
                                        borderRadius: BorderRadius.circular(12.r),
                                        border: Border.all(color: const Color(0xFFE4E9F2)),
                                      ),
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        size: 18.sp,
                                        color: const Color(0xFF475467),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Customer Detail',
                                          style: TextStyle(
                                            fontSize: FontSizes.largeText,
                                            color: const Color(0xFF1F2937),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Claim acknowledgement',
                                          style: TextStyle(
                                            fontSize: FontSizes.smallText,
                                            color: const Color(0xFF98A2B3),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, size.height * 0.14),
                                children: [
                                  CustomerDetailSummaryCard(
                            customerName: customerDetailData.policy?.insuredName ?? notAvailable,
                            contactNo: customerDetailData.policy?.insuredContact ?? '',
                            claimNo: customerDetailData.intimationNo ?? notAvailable,
                            claimType: customerDetailData.claimType?.name ?? notAvailable,
                          ),
                          ClaimDetails(
                            claimDate: formatDisplayDateValue(
                              customerDetailData.intimationDate,
                              fallback: notAvailable,
                            ),
                            lossDate: formatDisplayDateValue(
                              customerDetailData.dateOfLoss,
                              fallback: notAvailable,
                            ),
                            policyNo: customerDetailData.policy?.policyNo ??
                                notAvailable,
                            contactNo:
                                customerDetailData.policy?.insuredContact ??
                                    notAvailable,
                          ),
                                  InsuranceDetailsNotifications(
                                    regNo: customerDetailData.regNo ??
                                        notAvailable,
                                    engineNo: customerDetailData.vehicle?.engineNo ??
                                        notAvailable,
                                    chassisNo: customerDetailData.vehicle?.chassisNo ??
                                        notAvailable,
                                    make: customerDetailData.vehicleMake?.name ??
                                        notAvailable,
                                    model: customerDetailData.vehicle?.model ??
                                        notAvailable,
                                    policeStation:
                                        customerDetailData.vehicle?.policeStation ??
                                            notAvailable,
                                    firNumber: customerDetailData.vehicle?.firNo ??
                                        notAvailable,
                                    firDate: formatDisplayDateValue(
                                      customerDetailData.vehicle?.firDate,
                                      fallback: notAvailable,
                                    ),
                                    workshopName:
                                        customerDetailData.workshop?.workshop?.name ??
                                            notAvailable,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: const Color(0xFFF3F5F9),
                          width: size.width,
                          padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
                          child: isLoading
                              ? const Center(child: AppLoader())
                              : Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 48.h,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return WithdrawDialog(
                                                    claimId: customerDetailData.id,
                                                  );
                                                });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Color(0xFFF3C1C1)),
                                            backgroundColor: const Color(0xFFFEEEEE),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.r),
                                            ),
                                          ),
                                          child: Text(
                                            'Withdraw',
                                            style: TextStyle(
                                              color: const Color(0xFFD63838),
                                              fontSize: FontSizes.normalText2,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: 48.h,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            formattedDate = formatApiDate(DateTime.now());

                                            var body = {
                                              "data": {
                                                "survey_date": formattedDate,
                                              }
                                            };

                                            final value = await UpdateSingleCustomer()
                                                .updateCustomerDetail(context, customerDetailData.id, body);
                                            if (!context.mounted) return;

                                            if (value.responseData?.data == "success") {
                                              _handleRefresh();
                                              setState(() {
                                                isLoading = false;
                                              });
                                              showSnackBar(context, 'Updated and Saved Successfully');
                                              claimsType = widget.isPre ? "pre" : "1st Inspection";
                                              final navResult = await Navigator.of(context)
                                                  .pushReplacement(MaterialPageRoute(builder: (context) {
                                                return claimsType == "pre"
                                                    ? PreInspectionWorkflow(
                                                        id: customerDetailData.id,
                                                        claimTypeId: customerDetailData.claimTypeId,
                                                        isFromNotification: true,
                                                      )
                                                    : WorkFlowScreen(
                                                        isFromNotification: true,
                                                        id: customerDetailData.id,
                                                        claimTypeId: customerDetailData.claimTypeId,
                                                      );
                                              }));
                                              if (navResult == true) {
                                                _handleRefresh();
                                              }
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              showSnackBar(context, 'Something went wrong');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorConstants.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.r),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Next',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: FontSizes.normalText2,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Icon(Icons.arrow_forward, color: Colors.white, size: 18.sp),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        ),
                      ],
                    ),
                  );
                });
            }),
      ),
    );
  }
}
