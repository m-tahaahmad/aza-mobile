import 'package:flutter/material.dart';
import 'package:icms_app/Providers/DownloadImagesProvider/download_images_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/workflow/workflow_bottom_bar.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/components/workflow/workflow_stage_model.dart';
import 'package:icms_app/components/workflow/workflow_stepper.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/customer_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/TakePictures/take_pictures.dart';
import 'package:icms_app/screens/Claims/WorkFlow/WorkFlow/third_party_work_flow.dart';
import 'package:provider/provider.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../components/withdraw_dialog.dart';
import '../../../../constants/globals.dart';
import '../VehicleScreen/vehicle_screen.dart';

class PreInspectionWorkflow extends StatefulWidget {
  final int? id;
  final int? claimTypeId;
  final bool isFromNotification;

  const PreInspectionWorkflow({super.key, this.id, this.claimTypeId, this.isFromNotification = false});

  @override
  State<PreInspectionWorkflow> createState() => _PreInspectionWorkflowState();
}

class _PreInspectionWorkflowState extends State<PreInspectionWorkflow> {
  bool isLoading = false;

  void _handleBack() {
    Provider.of<DownloadImagesProvider>(context, listen: false).resetProvider();
    Navigator.of(context).pop(true);
  }

  void _openTakePictures() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return TakePicturesScreen(id: widget.id);
    }));
  }

  List<WorkflowStageConfig> _buildStages(dynamic data) {
    return [
      WorkflowStageConfig(
        title: 'CUSTOMER DETAIL',
        subtitle: WorkflowStageSubtitles.customerDetail,
        isCompleted: data?.isCustomer == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CustomerDetailsScreen(id: widget.id);
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'VEHICLE',
        subtitle: WorkflowStageSubtitles.vehicle,
        isCompleted: data?.isLabor == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return VehicleScreen(id: widget.id);
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'ITEMS CHECKED',
        subtitle: WorkflowStageSubtitles.itemsChecked,
        isCompleted: data?.isParts == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return VehicleScreen(id: widget.id, isItemsChecked: true);
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'TAKE PICTURES',
        subtitle: WorkflowStageSubtitles.takePictures,
        isCompleted: data?.isFirstInspPics == 1,
        onTap: _openTakePictures,
      ),
    ];
  }

  bool get _showBottomBar =>
      claimsType != 'Waiting for approval' && claimsType != 'Reports Pending';

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
        body: Consumer<WorkflowProvider>(
          builder: (context, workflowProvider, child) {
            final data = workflowProvider.workflowResponseModel?.data;
            final stages = _buildStages(data);

            return SafeArea(
              child: Column(
                children: [
                  WorkflowPageHeader(
                    title: 'PreInspection WorkFlow',
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
                      onThirdParty: widget.claimTypeId == 8
                          ? () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return ThirdPartWorkFlowScreen(
                                  id: widget.id,
                                  claimTypeId: widget.claimTypeId,
                                  isFromNotification: widget.isFromNotification,
                                );
                              }));
                            }
                          : null,
                      onSubmit: () {
                        if (!workflowProvider.checkAllData()) {
                          showSnackBar(context, 'Details are missing');
                          return;
                        }
                        setState(() => isLoading = true);
                        final body = {
                          'data': {
                            'is_submitted': 1,
                            'is_settled': 1,
                            'is_reinspection': 1,
                            'is_reinspection_submitted': 1,
                            'is_final': 1,
                          }
                        };
                        onSubmit(body);
                      },
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
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() => isLoading = false);
        showSnackBar(context, 'Something went wrong');
      }
    });
  }
}
