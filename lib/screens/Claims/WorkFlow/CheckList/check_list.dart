import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/DocumentsModel/document_response_model.dart';
import 'package:icms_app/Providers/DocumentsProvider/documents_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/components/checklist/checklist_documents_card.dart';
import 'package:icms_app/components/checklist/checklist_helpers.dart';
import 'package:icms_app/components/claims/customer_detail_bottom_bar.dart';
import 'package:icms_app/components/claims/customer_detail_summary_banner.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CheckList/take_document_pictures.dart';
import 'package:provider/provider.dart';

import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Model/Workflow/workflow_response_model.dart';
import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../Services/Documents/document_service.dart';
import '../../../../components/app_loader.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/font_sizes.dart';
import '../../../../constants/globals.dart';

class CheckListScreen extends StatefulWidget {
  final int? id;

  const CheckListScreen({super.key, this.id});

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;
  Future<ApiResponse<DocumentResponseModel>>? _getDocuments;
  Future<List<ApiResponse<dynamic>?>>? apisList;
  bool isRefreshing = false;
  bool isFinalizing = false;

  @override
  void initState() {
    super.initState();
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    _getDocuments = DocumentService().getAllDocument(context);
    apisList = Future.wait([_getCustomerDetails!, _getDocuments!]);
  }

  Future _handleRefresh() async {
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    _getDocuments = DocumentService().getAllDocument(context);
    apisList = Future.wait([_getCustomerDetails!, _getDocuments!]);
    await Future.delayed(const Duration(milliseconds: 1500));
    return apisList;
  }

  bool get _showBottomBar => !checklistFieldsReadOnly();

  Future<void> _openDocument(DocumentData document) async {
    final refreshed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => TakeDocumentPicturesScreen(
          id: widget.id,
          documentId: document.id,
          documentName: document.name,
        ),
      ),
    );

    if (refreshed == true && mounted) {
      setState(() => isRefreshing = true);
      await _handleRefresh();
      if (mounted) setState(() => isRefreshing = false);
    }
  }

  void _handleDone(
    CustomerDetailData customerDetailData,
    List<Documents> documentsData,
    WorkflowProvider workflowProvider,
    WorkflowData? data,
  ) {
    if ((claimsType == '1st Inspection' || claimsType == 'Rejected') &&
        documentsData.isNotEmpty &&
        documentsData.where((element) => element.documentId == 9).first.documentValue == 2) {
      setState(() => isFinalizing = true);
      final body = {
        'data': {
          'is_first_insp_docs': 1,
        }
      };
      UpdateSingleCustomer().updateCustomerDetail(context, customerDetailData.id, body).then((value) {
        if (!mounted) return;
        if (value.responseData?.data == 'success') {
          setState(() => isFinalizing = false);
          workflowProvider.setWorkflow = WorkflowResponseModel(
            data: WorkflowData(
              isCustomer: data!.isCustomer,
              isDriver: data.isDriver,
              isFirstInspPics: data.isFirstInspPics,
              isReInspPics: data.isReInspPics,
              isLabor: data.isLabor,
              isParts: data.isParts,
              isFirstInspDocs: 1,
              isReInspDocs: data.isReInspDocs,
              isComments: data.isComments,
              isReInspComment: data.isReInspComment,
            ),
          );
          Navigator.of(context).pop();
        } else {
          setState(() => isFinalizing = false);
          showSnackBar(context, 'Something went wrong');
        }
      });
    } else if ((claimsType == 'Re-Inspections Pending' || claimsType == 'Docs Pending') &&
        documentsData.isNotEmpty &&
        reInspectionDocumentCheck(documentsData)) {
      setState(() => isFinalizing = true);
      final body = {
        'data': {
          'is_re_insp_docs': 1,
        }
      };
      UpdateSingleCustomer().updateCustomerDetail(context, customerDetailData.id, body).then((value) {
        if (!mounted) return;
        if (value.responseData?.data == 'success') {
          setState(() => isFinalizing = false);
          workflowProvider.setWorkflow = WorkflowResponseModel(
            data: WorkflowData(
              isCustomer: data!.isCustomer,
              isDriver: data.isDriver,
              isFirstInspPics: data.isFirstInspPics,
              isReInspPics: data.isReInspPics,
              isLabor: data.isLabor,
              isParts: data.isParts,
              isFirstInspDocs: data.isFirstInspDocs,
              isReInspDocs: 1,
              isComments: data.isComments,
              isReInspComment: data.isReInspComment,
            ),
          );
          Navigator.of(context).pop();
        } else {
          setState(() => isFinalizing = false);
          showSnackBar(context, 'Something went wrong');
        }
      });
    } else {
      setState(() => isFinalizing = false);
      showSnackBar(context, 'Documents with * sign are compulsory.');
    }
  }

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
            if (!snapshot.hasData) {
              return const Center(child: AppLoader());
            }

            final results = snapshot.data!;
            final allCompleted = results.every((response) => response?.status == Status.completed);
            if (!allCompleted) {
              final message = results
                  .where((response) => response?.status == Status.error)
                  .map((response) => response?.message)
                  .whereType<String>()
                  .firstOrNull;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    message ?? 'Failed to load checklist details.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FontSizes.normalText1,
                      color: const Color(0xFF667085),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }

            if (isRefreshing) {
              return const Center(child: AppLoader());
            }

            return Consumer3<CustomerDetailProvider, DocumentsProvider, WorkflowProvider>(
              builder: (context, customerDetailProvider, documentsProvider, workflowProvider, child) {
                final customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
                if (customerDetailData == null) {
                  return const SafeArea(
                    child: Center(child: Text('Failed to load checklist details.')),
                  );
                }

                final documentsData = customerDetailData.documents ?? [];
                final docs = (documentsProvider.documentResponseModel?.data ?? [])
                    .where((element) => (element.id ?? 0) < 13)
                    .toList();
                final data = workflowProvider.workflowResponseModel?.data;

                return SafeArea(
                  child: Column(
                    children: [
                      WorkflowPageHeader(
                        title: 'Check List',
                        subtitle: 'Final quality check',
                        onBack: () => Navigator.of(context).pop(true),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                          children: [
                            CustomerDetailSummaryBanner(
                              claimNo: customerDetailData.intimationNo,
                              regNo: customerDetailData.regNo,
                              branchName: customerDetailData.policy?.insuranceCompany?.name,
                            ),
                            ChecklistDocumentsCard(
                              documents: docs,
                              claimDocuments: documentsData,
                              onDocumentTap: _openDocument,
                            ),
                          ],
                        ),
                      ),
                      if (_showBottomBar)
                        CustomerDetailBottomBar(
                          isFinalizing: isFinalizing,
                          onSave: () => Navigator.of(context).pop(),
                          onDone: () => _handleDone(customerDetailData, documentsData, workflowProvider, data),
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
}
