import 'package:flutter/material.dart';
import 'package:icms_app/HelperFunctions/helper_functions.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/DialogProvider/dialog_provider.dart';
import 'package:icms_app/Providers/MediaProvider/media_provider.dart';
import 'package:icms_app/Services/MediaServices/media_services.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/pictures/pictures_instruction_caption.dart';
import 'package:icms_app/components/pictures/pictures_photo_grid.dart';
import 'package:icms_app/components/pictures/pictures_section_header.dart';
import 'package:icms_app/components/withdraw_dialog.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SDTab extends StatelessWidget {
  SDTab({super.key});

  final ImagePicker picker = ImagePicker();

  bool get _canEdit => claimsType != 'Reports Pending' && claimsType != 'Waiting for approval';

  @override
  Widget build(BuildContext context) {
    return Consumer3<MediaProvider, CustomerDetailProvider, DialogProvider>(
      builder: (context, mediaProvider, customerDetailProvider, dialogProvider, child) {
        final claimId = customerDetailProvider.customerDetailResponseModel!.data!.id;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PicturesSectionHeader(
                title: 'SD photos',
                count: mediaProvider.sdImages.length,
              ),
              PicturesPhotoGrid(
                images: mediaProvider.sdImages,
                takeLabel: 'Take Image',
                showTakeImage: _canEdit,
                canDelete: _canEdit && !mediaProvider.isUploading,
                isUploading: mediaProvider.isAtUploadCapacity,
                onTakeImage: () {
                  HelperFunctions().imgFromCamera(
                    context,
                    picker,
                    claimId,
                    mediaProvider,
                    uploadType: 'sd',
                    listType: 'sd',
                  );
                },
                onZoom: (image) {
                  HelperFunctions().zoomPicture(context, image.imageUrl);
                },
                onDelete: (image) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return WithdrawDialog(
                        fromMedia: true,
                        onTap: () {
                          dialogProvider.setLoading = true;
                          MediaServices().deleteMedia(context, image.id).then((value) {
                            if (!context.mounted) return;
                            if (value.responseData?.success == true) {
                              mediaProvider.removeImage('sd', image.id);
                              dialogProvider.setLoading = false;
                              Navigator.of(context).pop();
                            } else {
                              showSnackBar(context, 'Something went Wrong!!!');
                              dialogProvider.setLoading = false;
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
              picturesInstructionCaption(),
            ],
          ),
        );
      },
    );
  }
}
