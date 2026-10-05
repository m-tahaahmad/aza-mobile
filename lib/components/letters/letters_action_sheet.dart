import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

enum LettersAction { preview, download }

class LettersActionSheet extends StatelessWidget {
  final String title;
  final bool showPreview;
  final bool showDownload;

  const LettersActionSheet({
    super.key,
    required this.title,
    this.showPreview = true,
    this.showDownload = true,
  });

  static Future<LettersAction?> show(
    BuildContext context, {
    required String title,
    bool showPreview = true,
    bool showDownload = true,
  }) {
    return showModalBottomSheet<LettersAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => LettersActionSheet(
        title: title,
        showPreview: showPreview,
        showDownload: showDownload,
      ),
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
                  title,
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
          if (showPreview) ...[
            _ActionButton(
              icon: CupertinoIcons.doc_text,
              label: 'Preview',
              onTap: () => Navigator.of(context).pop(LettersAction.preview),
            ),
            SizedBox(height: 10.h),
          ],
          if (showDownload)
            _ActionButton(
              icon: CupertinoIcons.arrow_down_doc,
              label: 'Download',
              onTap: () => Navigator.of(context).pop(LettersAction.download),
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
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
