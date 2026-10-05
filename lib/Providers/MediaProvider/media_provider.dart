import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Services/API/api_response.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';
import 'package:icms_app/Services/MediaServices/image_compress_service.dart';
import 'package:icms_app/Services/MediaServices/media_services.dart';
import 'package:icms_app/Services/MediaServices/media_upload_stager.dart';
import 'package:icms_app/constants/globals.dart';

enum MediaUploadStatus { pending, uploading, failed }

class MediaUploadJob {
  MediaUploadJob({
    required this.id,
    required this.listType,
    required this.status,
  });

  final String id;
  final String listType;
  MediaUploadStatus status;
}

class MediaUploadResult {
  const MediaUploadResult({
    required this.success,
    this.message,
    this.image,
    this.cancelled = false,
  });

  final bool success;
  final String? message;
  final ClaimImage? image;
  final bool cancelled;
}

class MediaProvider extends ChangeNotifier {
  static const int maxConcurrentUploads = 3;

  List<ClaimImage> images = [];
  List<ClaimImage> reInspectImages = [];
  List<ClaimImage> sdImages = [];
  List<ClaimImage> preInspectImages = [];
  List<ClaimImage> documentImages = [];
  bool showHide = claimsType == "1st Inspection" ||
          claimsType == "Reports Pending" ||
          claimsType == "Rejected" ||
          claimsType == "Waiting for approval"
      ? true
      : false;
  int _uploadInFlightCount = 0;
  final List<MediaUploadJob> _jobs = [];
  final List<CancelToken> _activeTokens = [];
  final ImageCompressService _compressService = ImageCompressService();
  final MediaServices _mediaServices = MediaServices();

  bool get isUploading => _uploadInFlightCount > 0;

  bool get isAtUploadCapacity => _uploadInFlightCount >= maxConcurrentUploads;

  bool get canStartUpload => _uploadInFlightCount < maxConcurrentUploads;

  List<MediaUploadJob> get jobs => List.unmodifiable(_jobs);

  addImage(String type, ClaimImage? image) {
    if (image == null) return;
    _listFor(type)?.add(image);
    notifyListeners();
  }

  void addExistingImages(String type, Iterable<ClaimImage?> imagesToAdd) {
    final list = _listFor(type);
    if (list == null) return;
    for (final image in imagesToAdd) {
      if (image != null) {
        list.add(image);
      }
    }
    notifyListeners();
  }

  removeImage(String type, int? imageId) {
    _listFor(type)?.removeWhere((element) => element.id == imageId);
    notifyListeners();
  }

  List<ClaimImage>? _listFor(String type) {
    switch (type) {
      case 'insp':
        return images;
      case 'reinsp':
        return reInspectImages;
      case 'doc':
        return documentImages;
      case 'sd':
        return sdImages;
      case 'pre':
        return preInspectImages;
      default:
        return null;
    }
  }

  set setShowHide(bool value) {
    showHide = value;
    notifyListeners();
  }

  void beginUpload() {
    _uploadInFlightCount++;
    notifyListeners();
  }

  void endUpload() {
    if (_uploadInFlightCount > 0) {
      _uploadInFlightCount--;
    }
    notifyListeners();
  }

  void refreshMedia() {
    notifyListeners();
  }

  Future<MediaUploadResult> enqueueUpload({
    required File source,
    required int? claimId,
    required String uploadType,
    required String listType,
    int? documentId,
    bool isDocument = false,
  }) async {
    if (!canStartUpload) {
      return const MediaUploadResult(
        success: false,
        message: 'Please wait — uploads in progress',
      );
    }

    final job = MediaUploadJob(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      listType: listType,
      status: MediaUploadStatus.pending,
    );
    _jobs.add(job);
    beginUpload();

    final token = CancelToken();
    _activeTokens.add(token);
    File? staged;
    File? compressed;

    job.status = MediaUploadStatus.uploading;
    notifyListeners();

    try {
      staged = await MediaUploadStager.stage(source);
      compressed = await _compressService.compress(staged, isDocument: isDocument);

      final response = await _mediaServices.uploadMedia(
        compressed,
        claimId,
        uploadType,
        documentId: documentId,
        cancelToken: token,
      );

      if (response.status == Status.completed &&
          response.responseData != null &&
          response.responseData!.success == true &&
          response.responseData!.data != null) {
        addImage(listType, response.responseData!.data);
        _jobs.remove(job);
        return MediaUploadResult(success: true, image: response.responseData!.data);
      }

      job.status = MediaUploadStatus.failed;
      notifyListeners();
      ClientErrorReporter.report(
        kind: ClientErrorKind.http,
        userVisibleMessage: response.message ?? 'Something went Wrong!!!',
        originalMessage: response.message,
      );
      return MediaUploadResult(
        success: false,
        message: response.message ?? 'Something went Wrong!!!',
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        _jobs.remove(job);
        ClientErrorReporter.report(
          kind: ClientErrorKind.client,
          userVisibleMessage: 'Upload cancelled',
          originalMessage: e.toString(),
          exceptionClass: 'Mobile.UploadCancelled',
        );
        return const MediaUploadResult(
          success: false,
          message: 'Upload cancelled',
          cancelled: true,
        );
      }
      job.status = MediaUploadStatus.failed;
      notifyListeners();
      ClientErrorReporter.report(
        kind: ClientErrorKind.http,
        userVisibleMessage: 'Something went Wrong!!!',
        originalMessage: e.toString(),
      );
      return const MediaUploadResult(success: false, message: 'Something went Wrong!!!');
    } catch (e, stack) {
      job.status = MediaUploadStatus.failed;
      notifyListeners();
      ClientErrorReporter.report(
        kind: ClientErrorKind.client,
        userVisibleMessage: 'Something went Wrong!!!',
        originalMessage: e.toString(),
        stackTrace: stack.toString(),
        exceptionClass: 'Mobile.UploadFailed',
      );
      return const MediaUploadResult(success: false, message: 'Something went Wrong!!!');
    } finally {
      _activeTokens.remove(token);
      endUpload();
      await MediaUploadStager.delete(compressed);
      await MediaUploadStager.delete(staged);
    }
  }

  void cancelUploads() {
    for (final token in List<CancelToken>.from(_activeTokens)) {
      if (!token.isCancelled) {
        token.cancel('Cancelled');
      }
    }
  }

  resetProvider() {
    if (isUploading) {
      debugPrint('Skipping media provider reset while uploads are in flight');
      return;
    }
    debugPrint("Resetting Media Provider");
    images.clear();
    reInspectImages.clear();
    sdImages.clear();
    preInspectImages.clear();
    documentImages.clear();
    _jobs.clear();
    _uploadInFlightCount = 0;
    showHide = false;
    notifyListeners();
  }
}
