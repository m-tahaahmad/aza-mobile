import 'package:flutter/material.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/components/workflow/workflow_stage_model.dart';
import 'package:icms_app/components/workflow/workflow_stepper.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CustomerDetails/customer_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/DriverDetails/driver_details.dart';
import 'package:icms_app/screens/Claims/WorkFlow/Labour/labour.dart';
import 'package:icms_app/screens/Claims/WorkFlow/PartsInvolves/parts_involves.dart';
import 'package:provider/provider.dart';

class ThirdPartWorkFlowScreen extends StatefulWidget {
  final int? id;
  final int? claimTypeId;
  final bool isFromNotification;

  const ThirdPartWorkFlowScreen({
    super.key,
    this.id,
    this.claimTypeId,
    this.isFromNotification = false,
  });

  @override
  State<ThirdPartWorkFlowScreen> createState() => _ThirdPartWorkFlowScreenState();
}

class _ThirdPartWorkFlowScreenState extends State<ThirdPartWorkFlowScreen> {
  List<WorkflowStageConfig> _buildStages(dynamic data) {
    return [
      WorkflowStageConfig(
        title: 'CUSTOMER DETAIL',
        subtitle: WorkflowStageSubtitles.customerDetail,
        isCompleted: data?.isCustomer == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CustomerDetailsScreen(
              id: widget.id,
              comeFromThirdParty: true,
            );
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'DRIVER DETAILS',
        subtitle: WorkflowStageSubtitles.driverDetails,
        isCompleted: data?.isDriver == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return DriverDetailsScreen(
              id: widget.id,
              comeFromThirdParty: true,
            );
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'LABOUR',
        subtitle: WorkflowStageSubtitles.labour,
        isCompleted: data?.isLabor == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LabourScreen(
              id: widget.id,
              comeFromThirdParty: true,
            );
          }));
        },
      ),
      WorkflowStageConfig(
        title: 'PARTS INVOLVED',
        subtitle: WorkflowStageSubtitles.partsInvolved,
        isCompleted: data?.isParts == 1,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PartsInvolvesScreen(
              id: widget.id,
              comeFromThirdParty: true,
            );
          }));
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Consumer<WorkflowProvider>(
        builder: (context, workflowProvider, child) {
          final data = workflowProvider.workflowResponseModel?.data;
          final stages = _buildStages(data);

          return SafeArea(
            child: Column(
              children: [
                WorkflowPageHeader(
                  title: 'WorkFlow',
                  subtitle: 'Third party',
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: WorkflowStepper(stages: stages),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
