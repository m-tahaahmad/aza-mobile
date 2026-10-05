// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:icms_app/components/app_loader.dart';
// import 'package:icms_app/components/custom_app_bar.dart';
// import 'package:icms_app/screens/Claims/WorkFlow/WorkFlow/workflow.dart';
// import '../../Services/CustomerDetailServices/update_single_customer.dart';
// import '../../components/custom_filled_button.dart';
// import '../../components/custom_snack_bar.dart';
// import '../../constants/theme_constants.dart';
// import 'package:icms_app/constants/globals.dart' as globals;
//
// class ClaimsTypesScreen extends StatefulWidget {
//   final int? id;
//   final String? claimType;
//   final int? claimTypeId;
//   final bool isFromNotification;
//
//   const ClaimsTypesScreen(
//       {Key? key,
//       this.claimType,
//       this.claimTypeId,
//       this.id,
//       this.isFromNotification = false})
//       : super(key: key);
//
//   @override
//   State<ClaimsTypesScreen> createState() => _ClaimsTypesScreenState();
// }
//
// class _ClaimsTypesScreenState extends State<ClaimsTypesScreen> {
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     print("Claim Type:: ${widget.claimType}");
//     print("Claim Type Id:: ${widget.claimTypeId}");
//     if(globals.claimTypeId ==null){
//       setState(() {
//         globals.claimTypeId=widget.claimTypeId;
//       });
//     }
//     print("is From Notification:: ${widget.isFromNotification}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () {
//         Navigator.of(context).pop(true);
//         return Future.value(true);
//       },
//       child: Scaffold(
//         appBar: customAppBar(context,
//             title: "Claims Types",
//             showBackButton: true,
//             returnValue: true) as PreferredSizeWidget?,
//         body: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               isLoading
//                   ? AppLoader()
//                   : Column(
//                       children: [
//                         CustomFilledButton(
//                           width: size.width,
//                           height: 50.h,
//                           title: "Own Damage",
//                           btnColor:  globals.claimTypeId== 8
//                               ? ColorConstants.searchbarBackground
//                               : ColorConstants.primaryColor,
//                           onPressed: () {
//                             setState(() {
//                               isLoading = true;
//                             });
//                             dynamic body = {
//                               "data": {
//                                 "claim_type_id": 1,
//                               }
//                             };
//                             UpdateSingleCustomer()
//                                 .updateCustomerDetail(context, widget.id, body)
//                                 .then((value) {
//                               if (value.responseData?.data == "success") {
//                                 setState(() {
//                                   isLoading = false;
//                                   globals.claimTypeId=1;
//                                 });
//                                 Navigator.of(context)
//                                     .push(MaterialPageRoute(builder: (context) {
//                                   return WorkFlowScreen(
//                                       id: widget.id,
//                                       claimTypeId: 1,
//                                       isFromNotification:
//                                           widget.isFromNotification);
//                                 }));
//                               } else {
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                                 showSnackBar(context, 'Something went wrong');
//                               }
//                             });
//                           },
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         CustomFilledButton(
//                           width: size.width,
//                           height: 50.h,
//                           title: "Own Damage/Third Party",
//                           btnColor:  globals.claimTypeId== 8
//                               ? ColorConstants.primaryColor
//                               : ColorConstants.searchbarBackground,
//                           onPressed: () {
//                             setState(() {
//                               isLoading = true;
//                             });
//                             dynamic body = {
//                               "data": {
//                                 "claim_type_id": 8,
//                               }
//                             };
//                             UpdateSingleCustomer()
//                                 .updateCustomerDetail(context, widget.id, body)
//                                 .then((value) {
//                               if (value.responseData?.data == "success") {
//                                 setState(() {
//                                   isLoading = false;
//                                   globals.claimTypeId=8;
//                                 });
//                                 Navigator.of(context)
//                                     .push(MaterialPageRoute(builder: (context) {
//                                   return WorkFlowScreen(
//                                       id: widget.id,
//                                       claimTypeId: 8,
//                                       isFromNotification:
//                                           widget.isFromNotification);
//                                 }));
//                               } else {
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                                 showSnackBar(context, 'Something went wrong');
//                               }
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//               SizedBox(
//                 height: 12,
//               ),
//               CustomFilledButton(
//                 width: size.width,
//                 height: 50.h,
//                 title: "Theft of Accessories",
//                 btnColor: ColorConstants.disableButtonColor,
//                 onPressed: () {
//                   // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                   //   return DashboardScreen();
//                   // }));
//                 },
//               ),
//               SizedBox(
//                 height: 12,
//               ),
//               CustomFilledButton(
//                 width: size.width,
//                 height: 50.h,
//                 title: "Constructive Total Loss",
//                 btnColor: ColorConstants.disableButtonColor,
//                 onPressed: () {
//                   // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                   //   return DashboardScreen();
//                   // }));
//                 },
//               ),
//               SizedBox(
//                 height: 12,
//               ),
//               CustomFilledButton(
//                 width: size.width,
//                 height: 50.h,
//                 title: "Own Damage/ Rain Damage",
//                 btnColor: ColorConstants.disableButtonColor,
//                 onPressed: () {
//                   // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                   //   return DashboardScreen();
//                   // }));
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
