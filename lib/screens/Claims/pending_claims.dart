import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/PendingClaims/pending_claim_response_model.dart';
import 'package:icms_app/Model/Workflow/workflow_response_model.dart';
import 'package:icms_app/Providers/PendingClaimProvider/pending_claim_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/Services/PendingClaimServices/pending_claim_services.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/claims/pending_claim_card.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/NotificationCustomerDetails/notification_customer_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/Letter&Forms/letter_forms_screen.dart';
import 'package:icms_app/screens/Claims/WorkFlow/WorkFlow/workflow.dart';
import 'package:provider/provider.dart';

import '../../Services/API/api_response.dart';
import '../../constants/theme_constants.dart';
import 'WorkFlow/WorkFlow/pre_inspection_workflow.dart';

class PendingClaimsScreen extends StatefulWidget {
  final String? apiType;
  final String? headerText;
  final bool isPre;

  const PendingClaimsScreen({super.key, this.apiType, this.headerText, this.isPre = false});

  @override
  State<PendingClaimsScreen> createState() => _PendingClaimsScreenState();
}

class _PendingClaimsScreenState extends State<PendingClaimsScreen> {
  TextEditingController searchController = TextEditingController();
  Future<ApiResponse<PendingClaimResponseModel>>? getPendingClaims;
  PendingClaimProvider? pendingClaimProvider;
  List<PendingClaimData>? pendingClaimsList = [];
  List<PendingClaimData>? searchedClaims = [];
  String search = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getPendingClaims = PendingClaimServices().getPendingClaims(context, claimsType: widget.apiType, isPre: widget.isPre);
    pendingClaimProvider = Provider.of<PendingClaimProvider>(context, listen: false);
  }

  Future _handleRefresh() async {
    getPendingClaims = PendingClaimServices().getPendingClaims(context, claimsType: widget.apiType, isPre: widget.isPre);
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(true);
        }
      },
      child: RefreshIndicator(
        color: ColorConstants.primaryColor,
        onRefresh: _handleRefresh,
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F5F9),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: const Color(0xFFF6F8FC),
                  padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                  child: Column(
                    children: [
                      Row(
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
                                CupertinoIcons.back,
                                size: 18.sp,
                                color: const Color(0xFF475467),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Consumer<PendingClaimProvider>(
                              builder: (context, provider, _) {
                                final source = provider.pendingClaimResponseModel?.data ?? [];
                                final query = search.toLowerCase().trim();
                                final filteredCount = query.isEmpty
                                    ? source.length
                                    : source
                                        .where(
                                          (element) =>
                                              (element.intimationNo ?? '').toLowerCase().contains(query) ||
                                              (element.regNo ?? '').toLowerCase().contains(query) ||
                                              (element.policy?.insuranceCompany?.name ?? '')
                                                  .toLowerCase()
                                                  .contains(query),
                                        )
                                        .length;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.headerText ?? '',
                                      style: TextStyle(
                                        fontSize: FontSizes.bigText,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '$filteredCount claims to review',
                                      style: TextStyle(
                                        fontSize: FontSizes.normalText1,
                                        color: const Color(0xFF98A2B3),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EDF8),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) => setState(() => search = value),
                          textInputAction: TextInputAction.search,
                          style: TextStyle(
                            fontSize: FontSizes.normalText2,
                            color: const Color(0xFF344054),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search claim, branch or plate',
                            hintStyle: TextStyle(
                              fontSize: FontSizes.normalText2,
                              color: const Color(0xFF98A2B3),
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              size: 18.sp,
                              color: const Color(0xFF98A2B3),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<ApiResponse<dynamic>>(
                    future: getPendingClaims,
                    builder: (context, AsyncSnapshot<ApiResponse<dynamic>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: AppLoader());
                      }

                      if (isLoading) {
                        return const Center(child: AppLoader());
                      }

                      return Consumer2<PendingClaimProvider, WorkflowProvider>(
                        builder: (context, pendingClaimProvider, workflowProvider, child) {
                          pendingClaimsList = pendingClaimProvider.pendingClaimResponseModel?.data ?? [];
                          if (search.isEmpty) {
                            searchedClaims = pendingClaimsList;
                          } else {
                            final query = search.toLowerCase().trim();
                            searchedClaims = pendingClaimsList!
                                .where(
                                  (element) =>
                                      (element.intimationNo ?? '').toLowerCase().contains(query) ||
                                      (element.regNo ?? '').toLowerCase().contains(query) ||
                                      (element.policy?.insuranceCompany?.name ?? '').toLowerCase().contains(query),
                                )
                                .toList();
                          }

                          if (searchedClaims == null || searchedClaims!.isEmpty) {
                            return Center(
                              child: Text(
                                'No claims yet.',
                                style: TextStyle(
                                  color: const Color(0xFF64748B),
                                  fontSize: FontSizes.largeText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: searchedClaims!.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 90.h),
                            itemBuilder: (context, index) {
                              final item = searchedClaims![index];
                              return PendingClaimCard(
                                claim: item,
                                onTap: claimsType == 'Monthly Reports'
                                    ? null
                                    : () {
                                  claimId = item.id;
                                  workflowProvider.setWorkflow = WorkflowResponseModel(
                                    data: WorkflowData(
                                      isCustomer: item.isCustomer,
                                      isDriver: item.isDriver,
                                      isFirstInspPics: item.isFirstInspPics,
                                      isFirstInspDocs: item.isFirstInspDocs,
                                      isReInspPics: item.isReInspPics,
                                      isReInspDocs: item.isReInspDocs,
                                      isLabor: item.isLabor,
                                      isParts: item.isParts,
                                      isComments: item.isComments,
                                      isReInspComment: item.isReInspComment,
                                    ),
                                  );
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return widget.apiType == 'unattended' && widget.isPre
                                        ? NotificationCustomerDetails(
                                            id: item.id,
                                            isPre: widget.isPre,
                                          )
                                        : widget.apiType == 'unattended'
                                            ? NotificationCustomerDetails(
                                                id: item.id,
                                              )
                                            : claimsType == 'Letter & Forms'
                                                ? LetternForms(
                                                    id: item.id,
                                                  )
                                                : claimsType == 'pre'
                                                    ? PreInspectionWorkflow(
                                                        id: item.id,
                                                        claimTypeId: item.claimTypeId,
                                                        isFromNotification: widget.apiType == 'unattended' ? true : false,
                                                      )
                                                    : WorkFlowScreen(
                                                        id: item.id,
                                                        claimTypeId: item.claimTypeId,
                                                        isFromNotification: widget.apiType == 'unattended' ? true : false,
                                                      );
                                  })).then((value) {
                                    if (value != null && value) {
                                      _handleRefresh();
                                    }
                                  });
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorConstants.primaryColor,
            elevation: 4,
            onPressed: () {
              setState(() => isLoading = true);
              _handleRefresh().then((value) {
                if (mounted) {
                  setState(() => isLoading = false);
                }
              });
            },
            child: Icon(
              CupertinoIcons.refresh,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
        ),
      ),
    );
  }
}
