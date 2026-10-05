import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../Services/API/api_response.dart';
import '../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../components/app_loader.dart';
import '../../components/custom_filled_button.dart';
import '../../components/custom_snack_bar.dart';
import '../../constants/theme_constants.dart';
import '../../constants/font_sizes.dart';
import '../../constants/globals.dart';

class NotificationClaimBottomSheet extends StatefulWidget {
  final AnimationController? controller;
  final String? claimId;
  final String? notificationTitle;

  const NotificationClaimBottomSheet({super.key, this.claimId, this.controller, this.notificationTitle});

  @override
  State<NotificationClaimBottomSheet> createState() => _NotificationClaimBottomSheetState();
}

class _NotificationClaimBottomSheetState extends State<NotificationClaimBottomSheet> {
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;

  @override
  void initState() {
    super.initState();
    debugPrint("ClaimId :: ${widget.claimId}");
    if (widget.claimId != null) {
      _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, int.parse(widget.claimId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.32,
      decoration:
      const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              widget.notificationTitle!,
              style: GoogleFonts.playfairDisplay(
                textStyle: TextStyle(color: Colors.black, fontSize: FontSizes.bigText, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          widget.claimId != null
              ? FutureBuilder<ApiResponse<CustomerDetailResponseModel>?>(
                  future: _getCustomerDetails,
                  builder: (context, AsyncSnapshot<ApiResponse<CustomerDetailResponseModel>?> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: AppLoader());
                    } else {
                      return Consumer<CustomerDetailProvider>(builder: (context, customerDetailProvider, child) {
                        CustomerDetailData? customerDetailData = customerDetailProvider.customerDetailResponseModel!.data;
                        return customerDetailData != null
                            ? customerDetailData.surveyorId == null
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                                        child: Container(
                                          decoration: BoxDecoration(color: ColorConstants.primaryColor, borderRadius: BorderRadius.circular(5)),
                                          width: size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Table(
                                                  children: [
                                                    TableRow(children: [
                                                      Text(
                                                        "Branch Id",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300, color: Colors.black),
                                                      ),
                                                      Text(
                                                        customerDetailData.policy?.insuranceCompany?.name ?? '',
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w500, color: Colors.white),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Claim Id",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300, color: Colors.black),
                                                      ),
                                                      Text(
                                                        customerDetailData.intimationNo ?? notAvailable,
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w500, color: Colors.white),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Assigned On",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300, color: Colors.black),
                                                      ),
                                                      Text(
                                                        customerDetailData.assignedAt ?? "",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w500, color: Colors.white),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Assigned By",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300, color: Colors.black),
                                                      ),
                                                      Text(
                                                        customerDetailData.assignedBy ?? "",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w500, color: Colors.white),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "Registration",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300, color: Colors.black),
                                                      ),
                                                      Text(
                                                        customerDetailData.regNo ?? "",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w500, color: Colors.white),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        "WorkShop Name",
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300, color: Colors.black),
                                                      ),
                                                      Text(
                                                        customerDetailData.workshop?.workshop?.name?.toString() ?? '',
                                                        style: TextStyle(
                                                            fontSize: FontSizes.normalText1, fontWeight: FontWeight.w500, color: Colors.white),
                                                      ),
                                                    ]),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomFilledButton(
                                              width: size.width * 0.45,
                                              height: 35.h,
                                              title: "Reject",
                                              fontSize: FontSizes.extraSmallText,
                                              btnColor: Colors.red.withValues(alpha: 0.1),
                                              textColor: Colors.black,
                                              onPressed: () {
                                                widget.controller!.reverse().then((value) {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            ),
                                            CustomFilledButton(
                                              width: size.width * 0.45,
                                              height: 35.h,
                                              title: "Accept",
                                              fontSize: FontSizes.extraSmallText,
                                              btnColor: ColorConstants.primaryColor,
                                              textColor: Colors.white,
                                              onPressed: () {
                                                if (userableId != null) {
                                                  var body = {
                                                    "data": {"surveyor_id": userableId}
                                                  };
                                                  UpdateSingleCustomer().updateCustomerDetail(context, customerDetailData.id, body).then((value) {
                                                    if (!context.mounted) return;
                                                    if (value.responseData?.data == "success") {
                                                      // dialogProvider.setLoading = false;
                                                      Navigator.of(context).pop(true);
                                                      showSnackBar(context, 'Claim Accepted');
                                                    } else {
                                                      // dialogProvider.setLoading = false;
                                                      showSnackBar(context, 'Something went wrong!!!');
                                                    }
                                                  });
                                                } else {
                                                  showSnackBar(context, 'Something went wrong!!!');
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.exclamationmark_triangle_fill,
                                            size: 30,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              "Claim is already assigned to someone else.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: FontSizes.normalText1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 60,
                                          ),
                                          CustomFilledButton(
                                            width: size.width * 0.9,
                                            height: 35.h,
                                            title: "Back",
                                            fontSize: FontSizes.extraSmallText,
                                            btnColor: ColorConstants.primaryColor.withValues(alpha: 0.5),
                                            textColor: Colors.white,
                                            onPressed: () {
                                              widget.controller!.reverse().then((value) {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                            : Center(
                                child: Text(
                                  "Invalid Claim Id",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.playfairDisplay(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: FontSizes.bigText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      ),
                    );
                  });
                }
              })
              : SizedBox(),
        ],
      ),
    );
  }
}
