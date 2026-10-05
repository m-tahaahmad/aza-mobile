import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/workflow/workflow_stage_model.dart';
import 'package:icms_app/components/workflow/workflow_step_tile.dart';

class WorkflowStepper extends StatelessWidget {
  final List<WorkflowStageConfig> stages;

  const WorkflowStepper({
    super.key,
    required this.stages,
  });

  int? _activeIndex() {
    for (var i = 0; i < stages.length; i++) {
      if (stages[i].kind == WorkflowStageKind.download) continue;
      if (!stages[i].isCompleted) return i;
    }
    return null;
  }

  WorkflowStepVisualState _visualState(int index) {
    final stage = stages[index];
    if (stage.kind == WorkflowStageKind.download) {
      return WorkflowStepVisualState.download;
    }
    if (stage.isCompleted) {
      return WorkflowStepVisualState.completed;
    }
    final active = _activeIndex();
    if (active == index) {
      return WorkflowStepVisualState.active;
    }
    return WorkflowStepVisualState.pending;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      itemCount: stages.length,
      itemBuilder: (context, index) {
        return WorkflowStepTile(
          stage: stages[index],
          visualState: _visualState(index),
          showConnectorBelow: index != stages.length - 1,
        );
      },
    );
  }
}
