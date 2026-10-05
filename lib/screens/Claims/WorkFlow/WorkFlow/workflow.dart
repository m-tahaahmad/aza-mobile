import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/HelperFunctions/helper_functions.dart';
import 'package:icms_app/Providers/DownloadImagesProvider/download_images_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/components/comments/comments_helpers.dart';
import 'package:icms_app/components/custom_filled_button.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/workflow/workflow_bottom_bar.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/components/workflow/workflow_stage_model.dart';
import 'package:icms_app/components/workflow/workflow_stepper.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/screens/Claims/WorkFlow/BillAndReport/bill_and_report_screen.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CheckList/check_list.dart';
import 'package:icms_app/screens/Claims/WorkFlow/Comments/comments.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/customer_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/DriverDetails/driver_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/Labour/labour.dart';
import 'package:icms_app/screens/Claims/WorkFlow/MarkImportant/mark_important_dialog.dart';
import 'package:icms_app/screens/Claims/WorkFlow/PartsInvolves/parts_involves.dart';
import 'package:icms_app/screens/Claims/WorkFlow/TakePictures/take_pictures.dart';
import 'package:icms_app/screens/Claims/WorkFlow/WorkFlow/third_party_work_flow.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../components/withdraw_dialog.dart';
import 'package:icms_app/components/workflow/mark_important_confirm_dialog.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/globals.dart';

class WorkFlowScreen extends StatefulWidget {
  final int? id;
  final int? claimTypeId;
  final bool isFromNotification;

  const WorkFlowScreen({super.key, this.id, this.claimTypeId, this.isFromNotification = false});

  @override
  State<WorkFlowScreen> createState() => _WorkFlowScreenState();
}

class _WorkFlowScreenState extends State<WorkFlowScreen> {
  bool isLoading = false;
  int claimTypeId = -1;

  @override
  void initState() {
    super.initState();
    claimTypeId = widget.claimTypeId ?? -1;
  }

  void _handleBack() {
    Provider.of<DownloadImagesProvider>(context, listen: false).resetProvider();
    Navigator.of(context).pop(true);
  }

  void _openTakePictures() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return TakePicturesScreen(id: widget.id);
    }));
  }

  Future<void> _handleDownloadImages(DownloadImagesProvider downloadProvider) async {
    if (claimsType == "Re-Inspections Pending") {
      final type = await showDialog<String>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Select One to download images.',
              style: TextStyle(fontSize: FontSizes.normalText2),
            ),
            content: Container(
              width: 300.w,
              height: 100.sp,
              color: ColorConstants.baseColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomFilledButton(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 35.h,
                    title: '1st Inspection',
                    fontSize: FontSizes.extraSmallText,
                    isSecondary: true,
                    textColor: Colors.white,
                    onPressed: () => Navigator.of(context).pop('f_insp'),
                  ),
                  CustomFilledButton(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 35.h,
                    title: 'Re-Inspections',
                    fontSize: FontSizes.extraSmallText,
                    btnColor: ColorConstants.primaryColor,
                    textColor: Colors.white,
                    onPressed: () => Navigator.of(context).pop('re_insp'),
                  ),
                ],
              ),
            ),
          );
        },
      );
      if (type != null && mounted) {
        downloadProvider.downloadImages(context, widget.id!, type);
      }
    } else if (mounted) {
      downloadProvider.downloadImages(context, widget.id!, 'f_insp');
    }
  }

  List<WorkflowStageConfig> _buildStages(
    dynamic data,
    DownloadImagesProvider downloadProvider,
  ) {
    final usePlr = HelperFunctions().usePlrAttributes();
    final stages = <WorkflowStageConfig>[
      WorkflowStageConfig(
        title: 'CUSTOMER DETAIL',
        subtitle: WorkflowStageSubtitles.customerDetail,
        isCompleted: data?.isCustomer == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CustomerDetailsScreen(id: widget.id);
          })).then((value) {
            if (!mounted) return;
            setState(() {
              claimTypeId = value == true ? 8 : 1;
            });
          });
        },
      ),
      WorkflowStageConfig(
        title: 'DRIVER DETAILS',
        subtitle: WorkflowStageSubtitles.driverDetails,
        isCompleted: data?.isDriver == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return DriverDetailsScreen(id: widget.id);
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'TAKE PICTURES',
        subtitle: WorkflowStageSubtitles.takePictures,
        isCompleted: (usePlr && data?.isFirstInspPics == 1) || data?.isReInspPics == 1,
        onTap: _openTakePictures,
      ),
      WorkflowStageConfig(
        title: 'LABOUR',
        subtitle: WorkflowStageSubtitles.labour,
        isCompleted: data?.isLabor == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LabourScreen(id: widget.id);
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'PARTS INVOLVED',
        subtitle: WorkflowStageSubtitles.partsInvolved,
        isCompleted: data?.isParts == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PartsInvolvesScreen(id: widget.id);
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'CHECK LIST',
        subtitle: WorkflowStageSubtitles.checkList,
        isCompleted: (usePlr && data?.isFirstInspDocs == 1) || data?.isReInspDocs == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CheckListScreen(id: widget.id);
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'COMMENTS',
        subtitle: WorkflowStageSubtitles.comments,
        isCompleted: (usePlr && data?.isComments == 1) || data?.isReInspComment == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CommentScreen(id: widget.id);
          }));
        },
      ),
    ];

    if (claimsType == 'Reports Pending') {
      stages.add(
        WorkflowStageConfig(
          title: 'BILL & ISSUE REPORT',
          subtitle: WorkflowStageSubtitles.billAndReport,
          isCompleted: false,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BillAndReportScreen(id: widget.id);
            }));
          },
        ),
      );
    }

    if (claimsType == '1st Inspection' ||
        claimsType == 'Rejected' ||
        claimsType == 'Re-Inspections Pending') {
      stages.add(
        WorkflowStageConfig(
          title: 'DOWNLOAD IMAGES',
          subtitle: WorkflowStageSubtitles.downloadImages,
          isCompleted: downloadProvider.isCompleted,
          kind: WorkflowStageKind.download,
          onTap: () => _handleDownloadImages(downloadProvider),
          downloadTrailing: downloadProvider.isDownloading
              ? CircularPercentIndicator(
                  radius: 12.r,
                  lineWidth: 1.5.w,
                  percent: downloadProvider.progressValue,
                  backgroundColor: ColorConstants.baseColor,
                  progressColor: Colors.green,
                  center: Icon(CupertinoIcons.down_arrow, size: 12.sp),
                )
              : downloadProvider.isCompleted
                  ? Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: Colors.green[300],
                      size: 16.sp,
                    )
                  : null,
        ),
      );
    }

    return stages;
  }

  bool get _showBottomBar =>
      claimsType != 'Waiting for approval' && claimsType != 'Reports Pending';

  String? _submitValidationMessage(dynamic data) {
    if (claimsType == '1st Inspection' || claimsType == 'Rejected') {
      if (data?.isComments != 1) {
        return 'Add a comment before submitting';
      }
    } else if (claimsType == 'Re-Inspections Pending' && !isReinspectionsPending) {
      if (data?.isReInspComment != 1) {
        return 'Add a comment before submitting';
      }
    }

    return null;
  }

  bool _requiresApprovalCommentCheck() {
    return claimsType == '1st Inspection' ||
        claimsType == 'Rejected' ||
        (claimsType == 'Re-Inspections Pending' && !isReinspectionsPending);
  }

  Future<String?> _fetchCommentValidationMessage() async {
    final response = await CustomerDetailService().getCustomerDetail(context, widget.id);
    if (response?.status != Status.completed) {
      return 'Add a comment before submitting';
    }

    final comments = response?.responseData?.data?.comments ?? [];
    if (!hasRequiredMobileComment(comments)) {
      return 'Add a comment before submitting';
    }

    return null;
  }

  Future<void> _handleWorkflowSubmit(WorkflowProvider workflowProvider) async {
    final workflowData = workflowProvider.workflowResponseModel?.data;
    final commentMessage = _submitValidationMessage(workflowData);
    if (commentMessage != null) {
      showSnackBar(context, commentMessage);
      return;
    }

    if (!workflowProvider.checkAllData()) {
      showSnackBar(context, 'Details are missing');
      return;
    }

    if (_requiresApprovalCommentCheck()) {
      final mobileCommentMessage = await _fetchCommentValidationMessage();
      if (!mounted) return;
      if (mobileCommentMessage != null) {
        showSnackBar(context, mobileCommentMessage);
        return;
      }
    }

    setState(() => isLoading = true);
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    late final Map<String, dynamic> body;

    if (claimsType == 'Re-Inspections Pending') {
      body = {
        'data': {
          'is_reinspection': 1,
          'is_final': isReinspectionsPending ? 0 : 1,
          'workshop': {'re_insp_date': formattedDate},
        }
      };
    } else if (claimsType == 'Docs Pending') {
      body = {
        'data': {
          'doc_received': 1,
          'workshop': {'doc_receive_date': formattedDate},
        }
      };
    } else if (claimsType == '1st Inspection' || claimsType == 'Rejected') {
      body = {
        'data': {
          'is_submitted': 1,
          'is_referred_back': 0,
          'is_important': 0,
        }
      };
    } else {
      body = {
        'data': {'is_submitted': 1}
      };
    }

    if (HelperFunctions().usePlrAttributes()) {
      MarkImportantConfirmDialog.show(
        context,
        onNo: () => onSubmit(body, comesFromDialogue: true),
        onYes: () {
          Navigator.of(context).pop();
          final workflowData = workflowProvider.workflowResponseModel?.data;
          final commentMessage = _submitValidationMessage(workflowData);
          if (commentMessage != null) {
            showSnackBar(context, commentMessage);
            return;
          }
          if (!workflowProvider.checkAllData()) {
            showSnackBar(context, 'Details are missing');
            return;
          }
          showDialog(
            context: context,
            builder: (_) => MarkImportantDialog(id: widget.id),
          );
        },
      ).then((_) {
        if (mounted) {
          setState(() => isLoading = false);
        }
      });
    } else {
      onSubmit(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        Provider.of<DownloadImagesProvider>(context, listen: false).resetProvider();
        Navigator.of(context).pop(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        body: Consumer2<WorkflowProvider, DownloadImagesProvider>(
          builder: (context, workflowProvider, downloadProvider, child) {
            final data = workflowProvider.workflowResponseModel?.data;
            final stages = _buildStages(data, downloadProvider);

            return SafeArea(
              child: Column(
                children: [
                  WorkflowPageHeader(
                    title: 'WorkFlow',
                    onBack: _handleBack,
                  ),
                  Expanded(
                    child: WorkflowStepper(stages: stages),
                  ),
                  if (_showBottomBar)
                    WorkflowBottomBar(
                      isLoading: isLoading,
                      onWithdraw: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return WithdrawDialog(
                              claimId: widget.id,
                              fromWorkflow: true,
                            );
                          },
                        );
                      },
                      onThirdParty: claimTypeId == 8
                          ? () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return ThirdPartWorkFlowScreen(
                                  id: widget.id,
                                  claimTypeId: claimTypeId,
                                  isFromNotification: widget.isFromNotification,
                                );
                              }));
                            }
                          : null,
                      onSubmit: () => _handleWorkflowSubmit(workflowProvider),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void onSubmit(Map<String, dynamic> body, {bool comesFromDialogue = false}) {
    UpdateSingleCustomer().updateCustomerDetail(context, widget.id, body).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() => isLoading = false);
        showSnackBar(context, 'Submitted Successfully');
        if (comesFromDialogue) {
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pop(true);
        } else {
          Navigator.of(context)
            ..pop()
            ..pop(true);
        }
      } else {
        setState(() => isLoading = false);
        showSnackBar(context, apiResponseErrorMessage(value));
      }
    });
  }
}
