import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/components/pictures/pictures_photo_tile.dart';
import 'package:icms_app/components/pictures/pictures_take_image_tile.dart';

class PicturesPhotoGrid extends StatelessWidget {
  final List<ClaimImage> images;
  final String takeLabel;
  final VoidCallback? onTakeImage;
  final void Function(ClaimImage image)? onDelete;
  final void Function(ClaimImage image)? onZoom;
  final bool showTakeImage;
  final bool canDelete;
  final bool isUploading;

  const PicturesPhotoGrid({
    super.key,
    required this.images,
    required this.takeLabel,
    this.onTakeImage,
    this.onDelete,
    this.onZoom,
    this.showTakeImage = true,
    this.canDelete = true,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = (showTakeImage ? 1 : 0) + images.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          mainAxisExtent: 150.h,
        ),
        itemBuilder: (context, index) {
          if (showTakeImage && index == 0) {
            return PicturesTakeImageTile(
              label: takeLabel,
              onTap: onTakeImage,
              isLoading: isUploading,
            );
          }

          final imageIndex = showTakeImage ? index - 1 : index;
          if (imageIndex < 0 || imageIndex >= images.length) {
            return const SizedBox.shrink();
          }
          final image = images[imageIndex];

          return PicturesPhotoTile(
            imageUrl: image.imageUrl,
            onTap: onZoom != null ? () => onZoom!(image) : null,
            onDelete: canDelete && onDelete != null ? () => onDelete!(image) : null,
            showDelete: canDelete,
          );
        },
      ),
    );
  }
}
