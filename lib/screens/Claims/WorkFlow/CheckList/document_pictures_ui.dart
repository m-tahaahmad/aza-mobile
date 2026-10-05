import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/MediaProvider/media_provider.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';
import 'package:icms_app/Services/MediaServices/media_services.dart';
import 'package:icms_app/components/checklist/checklist_helpers.dart';
import 'package:icms_app/components/checklist/checklist_upload_source_sheet.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/pictures/pictures_bottom_bar.dart';
import 'package:icms_app/components/pictures/pictures_photo_grid.dart';
import 'package:icms_app/components/pictures/pictures_section_header.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../HelperFunctions/helper_functions.dart';
import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Providers/DialogProvider/dialog_provider.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../components/withdraw_dialog.dart';
import '../../../../constants/font_sizes.dart';
import '../../../../constants/globals.dart';

class DocumentPicturesUI extends StatefulWidget {
  final int? documentId;
  final String? documentName;

  const DocumentPicturesUI({
    super.key,
    this.documentId,
    this.documentName,
  });

  @override
  State<DocumentPicturesUI> createState() => _DocumentPicturesUIState();
}

class _DocumentPicturesUIState extends State<DocumentPicturesUI> {
  List<DocumentImage>? docsImages;
  final ImagePicker picker = ImagePicker();
  bool isFinalizing = false;
  late CustomerDetailProvider customerDetailProvider;
  late MediaProvider mediaProvider;

  @override
  void initState() {
    super.initState();
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    docsImages = customerDetailProvider.customerDetailResponseModel?.data?.docImages
        ?.where((element) => element.documentId == widget.documentId)
        .toList();

    mediaProvider.documentImages.clear();
    for (final e in docsImages ?? []) {
      if (e.image != null) {
        mediaProvider.documentImages.add(e.image as ClaimImage);
      }
    }
  }

  bool get _canEdit => !checklistUploadReadOnly();

  void _handleBack(MediaProvider mediaProvider) {
    if (mediaProvider.isUploading) {
      ClientErrorReporter.report(
        kind: ClientErrorKind.client,
        userVisibleMessage: 'Tried to leave while uploading',
        exceptionClass: 'Mobile.UploadAbandonBlocked',
      );
      showSnackBar(context, 'Please wait — uploads in progress');
      return;
    }
    mediaProvider.resetProvider();
    Navigator.of(context).pop(true);
  }

  Future<void> _openUploadSource(MediaProvider mediaProvider) async {
    final source = await ChecklistUploadSourceSheet.show(context);
    if (!mounted || source == null) return;

    final claimId = customerDetailProvider.customerDetailResponseModel?.data?.id;
    if (source == ChecklistUploadSource.camera) {
      await _imgFromCamera(claimId, mediaProvider, documentId: widget.documentId);
    } else {
      await _imgFromGallery(claimId, mediaProvider, documentId: widget.documentId);
    }
  }

  void _deleteImage(MediaProvider mediaProvider, DialogProvider dialogProvider, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return WithdrawDialog(
          fromMedia: true,
          onTap: () {
            dialogProvider.setLoading = true;
            MediaServices()
                .deleteMedia(context, mediaProvider.documentImages[index].id)
                .then((value) {
              if (!context.mounted) return;
              if (value.responseData?.success == true) {
                mediaProvider.removeImage('doc', mediaProvider.documentImages[index].id);
                dialogProvider.setLoading = false;
                Navigator.of(context).pop();
                onDone(mediaProvider: mediaProvider);
              } else {
                showSnackBar(context, 'Something went Wrong!!!');
                dialogProvider.setLoading = false;
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CustomerDetailProvider, DialogProvider, MediaProvider>(
      builder: (context, customerDetailProvider, dialogProvider, mediaProvider, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (mediaProvider.isUploading) {
              ClientErrorReporter.report(
                kind: ClientErrorKind.client,
                userVisibleMessage: 'Tried to leave while uploading',
                exceptionClass: 'Mobile.UploadAbandonBlocked',
              );
              showSnackBar(context, 'Please wait — uploads in progress');
              return;
            }
            mediaProvider.resetProvider();
            Navigator.of(context).pop(true);
          },
          child: SafeArea(
            child: Column(
              children: [
                WorkflowPageHeader(
                  title: widget.documentName ?? 'Document',
                  subtitle: 'Upload document photos',
                  onBack: () => _handleBack(mediaProvider),
                ),
                Expanded(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      PicturesSectionHeader(
                        title: 'Document photos',
                        count: mediaProvider.documentImages.length,
                      ),
                      if (widget.documentId != null)
                        PicturesPhotoGrid(
                          images: mediaProvider.documentImages,
                          takeLabel: 'Take photo',
                          showTakeImage: _canEdit,
                          canDelete: _canEdit && !mediaProvider.isUploading,
                          isUploading: mediaProvider.isAtUploadCapacity,
                          onTakeImage: () => _openUploadSource(mediaProvider),
                          onZoom: (image) => HelperFunctions().zoomPicture(context, image.imageUrl),
                          onDelete: (image) {
                            final index = mediaProvider.documentImages.indexWhere((e) => e.id == image.id);
                            if (index != -1) {
                              _deleteImage(mediaProvider, dialogProvider, index);
                            }
                          },
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 8.h),
                        child: Text(
                          'Capture clear photos of this document. Tap a tile to add or view it.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontSizes.smallText,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF98A2B3),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_canEdit)
                  PicturesBottomBar(
                    isUploading: mediaProvider.isUploading,
                    isFinalizing: isFinalizing,
                    onCancelUpload: () => mediaProvider.cancelUploads(),
                    onDone: () => onDone(mediaProvider: mediaProvider, goBack: true),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onDone({required MediaProvider mediaProvider, bool goBack = false}) {
    setState(() => isFinalizing = true);
    final requestBody = mediaProvider.documentImages.isNotEmpty
        ? {
            'data': {
              'documents': [
                {'claim_id': claimId, 'document_id': widget.documentId, 'document_value': 2}
              ]
            }
          }
        : {
            'data': {
              'documents': [
                {'claim_id': claimId, 'document_id': widget.documentId, 'document_value': 0}
              ]
            }
          };
    UpdateSingleCustomer().updateCustomerDetail(context, claimId, requestBody).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() => isFinalizing = false);
        if (goBack) {
          mediaProvider.resetProvider();
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() => isFinalizing = false);
        showSnackBar(context, 'Something went wrong!!!');
      }
    });
  }

  Future<void> _imgFromCamera(int? claimId, MediaProvider mediaProvider, {int? documentId}) async {
    if (mediaProvider.documentImages.length > 4) {
      showSnackBar(context, 'Limit Exceeded');
      return;
    }

    if (!mediaProvider.canStartUpload) {
      showSnackBar(context, 'Please wait — uploads in progress');
      return;
    }

    final image = await picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    if (image == null || !mounted) return;

    await _uploadPickedFile(File(image.path), claimId, mediaProvider, documentId: documentId);
  }

  Future<void> _imgFromGallery(int? claimId, MediaProvider mediaProvider, {int? documentId}) async {
    if (mediaProvider.documentImages.length > 4) {
      showSnackBar(context, 'Limit Exceeded');
      return;
    }

    if (!mediaProvider.canStartUpload) {
      showSnackBar(context, 'Please wait — uploads in progress');
      return;
    }

    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;

    await _uploadPickedFile(File(image.path), claimId, mediaProvider, documentId: documentId);
  }

  Future<void> _uploadPickedFile(
    File source,
    int? claimId,
    MediaProvider mediaProvider, {
    int? documentId,
  }) async {
    showSnackBar(context, 'Uploading . . .');
    final result = await mediaProvider.enqueueUpload(
      source: source,
      claimId: claimId,
      uploadType: 'doc',
      listType: 'doc',
      documentId: documentId,
      isDocument: true,
    );

    if (!mounted) return;
    if (result.success) {
      onDone(mediaProvider: mediaProvider);
      return;
    }
    if (result.message != null && !result.cancelled) {
      showSnackBar(context, result.message!);
    }
  }
}
