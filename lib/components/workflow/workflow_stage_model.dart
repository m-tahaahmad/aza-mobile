import 'package:flutter/material.dart';

enum WorkflowStageKind { normal, download }

class WorkflowStageSubtitles {
  static const customerDetail = 'Information verified and saved';
  static const driverDetails = 'License and ID confirmed';
  static const takePictures = 'Capture current condition';
  static const labour = 'Time and hours logged';
  static const partsInvolved = 'Inventory updated';
  static const checkList = 'Final quality check';
  static const comments = 'Add any additional notes';
  static const downloadImages = 'Generate report assets';
  static const billAndReport = 'Review and issue report';
  static const vehicle = 'Vehicle details captured';
  static const itemsChecked = 'Inspection items confirmed';
}

class WorkflowStageConfig {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onTap;
  final WorkflowStageKind kind;
  final Widget? downloadTrailing;

  const WorkflowStageConfig({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.onTap,
    this.kind = WorkflowStageKind.normal,
    this.downloadTrailing,
  });
}

enum WorkflowStepVisualState { completed, active, pending, download }
