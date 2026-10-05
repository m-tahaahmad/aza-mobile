import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

enum ChecklistUploadSource { camera, gallery }

class ChecklistUploadSourceSheet extends StatelessWidget {
  const ChecklistUploadSourceSheet({super.key});

  static Future<ChecklistUploadSource?> show(BuildContext context) {
    return showModalBottomSheet<ChecklistUploadSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChecklistUploadSourceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Upload document photo',
                  style: TextStyle(
                    fontSize: FontSizes.largeText,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close, size: 22.sp, color: const Color(0xFF667085)),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _SourceButton(
            icon: Icons.photo_camera_outlined,
            label: 'Camera',
            onTap: () => Navigator.of(context).pop(ChecklistUploadSource.camera),
          ),
          SizedBox(height: 10.h),
          _SourceButton(
            icon: Icons.photo_library_outlined,
            label: 'Gallery',
            onTap: () => Navigator.of(context).pop(ChecklistUploadSource.gallery),
          ),
        ],
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20.sp, color: ColorConstants.primaryColor),
        label: Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.normalText2,
            fontWeight: FontWeight.w700,
            color: ColorConstants.primaryColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: ColorConstants.secondaryColor.withValues(alpha: 0.5)),
          backgroundColor: ColorConstants.secondaryColor.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
      ),
    );
  }
}
