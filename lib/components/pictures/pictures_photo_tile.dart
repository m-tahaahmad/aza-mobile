import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/app_pressable.dart';

class PicturesPhotoTile extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDelete;

  const PicturesPhotoTile({
    super.key,
    required this.imageUrl,
    this.onTap,
    this.onDelete,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppPressable(
            onTap: onTap,
            borderRadius: 16.r,
            child: Image.network(
              imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FB),
                    border: Border.all(color: const Color(0xFFE4E9F2)),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: const Center(
                    child: Icon(Icons.hide_image_outlined, size: 40, color: Color(0xFF98A2B3)),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: const Color(0xFFF4F6FB),
                  child: const Center(child: AppLoader()),
                );
              },
            ),
          ),
          if (showDelete && onDelete != null)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: AppPressable(
                onTap: onDelete,
                borderRadius: 14.r,
                child: CircleAvatar(
                  radius: 14.r,
                  backgroundColor: Colors.black.withValues(alpha: 0.55),
                  child: Icon(Icons.close, size: 16.sp, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
