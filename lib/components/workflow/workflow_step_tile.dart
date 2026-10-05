import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/components/workflow/workflow_stage_model.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class WorkflowStepTile extends StatelessWidget {
  final WorkflowStageConfig stage;
  final WorkflowStepVisualState visualState;
  final bool showConnectorBelow;

  const WorkflowStepTile({
    super.key,
    required this.stage,
    required this.visualState,
    this.showConnectorBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = visualState == WorkflowStepVisualState.active
        ? ColorConstants.primaryColor
        : const Color(0xFF1F2937);
    final subtitleColor = const Color(0xFF98A2B3);

    return AppPressable(
      onTap: stage.onTap,
      borderRadius: 12.r,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36.w,
                child: Column(
                  children: [
                    _buildIndicator(),
                    if (showConnectorBelow)
                      Expanded(
                        child: Container(
                          width: 2.w,
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          color: const Color(0xFFE4E9F2),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: showConnectorBelow ? 18.h : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.title,
                        style: TextStyle(
                          fontSize: FontSizes.normalText2,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        stage.subtitle,
                        style: TextStyle(
                          fontSize: FontSizes.smallText,
                          fontWeight: FontWeight.w500,
                          color: subtitleColor,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    if (visualState == WorkflowStepVisualState.completed) {
      return Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.primaryColor,
        ),
        child: Icon(
          CupertinoIcons.check_mark,
          size: 14.sp,
          color: Colors.white,
        ),
      );
    }

    if (visualState == WorkflowStepVisualState.active) {
      return Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: ColorConstants.primaryColor, width: 2),
        ),
        child: Center(
          child: Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstants.primaryColor,
            ),
          ),
        ),
      );
    }

    if (visualState == WorkflowStepVisualState.download) {
      return SizedBox(
        width: 28.w,
        height: 28.w,
        child: CustomPaint(
          painter: _DashedCirclePainter(color: const Color(0xFFD0D5DD)),
          child: Center(
            child: stage.downloadTrailing ??
                Icon(
                  CupertinoIcons.arrow_down_circle,
                  size: 14.sp,
                  color: const Color(0xFFB8C0CE),
                ),
          ),
        ),
      );
    }

    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE4E9F2), width: 2),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const dashCount = 12;
    final radius = size.width / 2 - 1;
    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < dashCount; i++) {
      if (i.isOdd) continue;
      final startAngle = (i / dashCount) * 2 * 3.1415926535;
      final sweepAngle = (1 / dashCount) * 2 * 3.1415926535;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
