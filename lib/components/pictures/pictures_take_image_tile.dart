import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class PicturesTakeImageTile extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const PicturesTakeImageTile({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: isLoading ? null : onTap,
      borderRadius: 16.r,
      child: CustomPaint(
        painter: _DashedRoundedRectPainter(
          color: ColorConstants.primaryColor,
          radius: 16.r,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorConstants.secondaryColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: isLoading
              ? const Center(child: AppLoader())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: ColorConstants.primaryColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.photo_camera_outlined, color: Colors.white, size: 22.sp),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: FontSizes.smallText,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedRoundedRectPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        Radius.circular(radius),
      ));

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
