import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Services/CommentService/comment_service.dart';
import 'package:icms_app/components/claims/customer_detail_bottom_bar.dart';
import 'package:icms_app/components/comments/comments_compose_card.dart';
import 'package:icms_app/components/comments/comments_helpers.dart';
import 'package:icms_app/components/comments/comments_thread_section.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:provider/provider.dart';

import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Model/Workflow/workflow_response_model.dart';
import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../Providers/WorkflowProvider/workflow_provider.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../components/workflow/workflow_async_body.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/globals.dart';

class CommentScreen extends StatefulWidget {
  final int? id;

  const CommentScreen({super.key, this.id});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;
  bool isLoading = false;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future _handleRefresh() async {
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() {});
    return _getCustomerDetails;
  }

  bool get _showBottomBar => !commentsFieldsReadOnly();

  void _handleSend() {
    if (commentController.text.trim().isEmpty) {
      showSnackBar(context, 'Write Comment!!!');
      return;
    }

    setState(() => isSending = true);
    CommentsService().addComment(context, commentController.text.trim()).then((value) {
      if (!mounted) return;
      if (value.responseData?.success == true) {
        commentController.clear();
        showSnackBar(context, 'Comment Uploaded');
        _handleRefresh();
        setState(() => isSending = false);
      } else {
        setState(() => isSending = false);
        showSnackBar(context, apiResponseErrorMessage(value));
      }
    });
  }

  void _handleDone(CustomerDetailData customerDetailData, WorkflowProvider workflowProvider) {
    final commentsList = customerDetailData.comments ?? [];
    if (!hasRequiredMobileComment(commentsList)) {
      showSnackBar(context, 'Add a comment before submitting');
      return;
    }

    setState(() => isLoading = true);

    final body = claimsType == 'Re-Inspections Pending'
        ? {
            'data': {
              'is_re_insp_comment': 1,
            }
          }
        : {
            'data': {
              'is_comments': 1,
            }
          };

    UpdateSingleCustomer().updateCustomerDetail(context, customerDetailData.id, body).then((updateValue) {
      if (!mounted) return;
      if (updateValue.responseData?.data == 'success') {
        final data = workflowProvider.workflowResponseModel?.data;
        workflowProvider.setWorkflow = WorkflowResponseModel(
          data: WorkflowData(
            isCustomer: data?.isCustomer,
            isDriver: data?.isDriver,
            isFirstInspPics: data?.isFirstInspPics,
            isReInspPics: data?.isReInspPics,
            isLabor: data?.isLabor,
            isParts: data?.isParts,
            isFirstInspDocs: data?.isFirstInspDocs,
            isReInspDocs: data?.isReInspDocs,
            isComments: claimsType == '1st Inspection' || claimsType == 'Rejected' ? 1 : data?.isComments,
            isReInspComment: claimsType == 'Re-Inspections Pending' ? 1 : data?.isReInspComment,
          ),
        );
        setState(() => isLoading = false);
        Navigator.of(context).pop();
      } else {
        setState(() => isLoading = false);
        showSnackBar(context, apiResponseErrorMessage(updateValue));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              fallback: 'Failed to load comments.',
            );
            if (gate != null) return gate;

            return Consumer2<CustomerDetailProvider, WorkflowProvider>(
              builder: (context, customerDetailProvider, workflowProvider, child) {
                final customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
                if (customerDetailData == null) {
                  return workflowLoadMessage('Failed to load comments.');
                }

                final commentsList = customerDetailData.comments ?? [];

                return SafeArea(
                  child: Column(
                    children: [
                      WorkflowPageHeader(
                        title: 'Comments',
                        subtitle: 'Add any additional notes',
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                          children: [
                            CommentsThreadSection(comments: commentsList),
                          ],
                        ),
                      ),
                      if (_showBottomBar) ...[
                        CommentsComposeCard(
                          controller: commentController,
                          isSending: isSending,
                          onSend: _handleSend,
                        ),
                        CustomerDetailBottomBar(
                          isFinalizing: isLoading,
                          onSave: () => Navigator.of(context).pop(),
                          onDone: () => _handleDone(customerDetailData, workflowProvider),
                        ),
                      ],
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
