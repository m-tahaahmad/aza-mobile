import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:icms_app/Model/response_model.dart';
import '../../Model/MediaFileResponseModel/media_file_response_model.dart';
import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class MediaServices {
  Future<ApiResponse<MediaFileResponseModel>> uploadMedia(
    File mediaFile,
    int? claimId,
    String claimType, {
    int? documentId,
    CancelToken? cancelToken,
  }) async {
    try {
      debugPrint('Document Id:: $documentId, claimType:: $claimType');

      final route = _resolveUploadRoute(claimId, claimType, documentId: documentId);

      final response = await Api.uploadFile(
        route.endpoint,
        buildFields: () => _buildUploadFields(route.fieldName, mediaFile),
        sendToken: true,
        cancelToken: cancelToken,
      );

      debugPrint('Media Upload Response: $response');
      final responseModel = MediaFileResponseModel.fromJson(response.data as Map<String, dynamic>);
      return ApiResponse.completed(responseModel);
    } on BadRequestException {
      return ApiResponse.error('Bad Request Exception');
    } on UnauthorisedException {
      return ApiResponse.error('The User is Un-authorized');
    } on RequestNotFoundException {
      return ApiResponse.error('Request Not Found');
    } on UnautorizationException {
      return ApiResponse.error('The User is Un-authorized');
    } on InternalServerException {
      return ApiResponse.error('Internal Server Error');
    } on ServerNotFoundException {
      return ApiResponse.error('Server Not Available');
    } on FetchDataException {
      return ApiResponse.error('An Error occurred while Fetching the Data');
    } on RequestTimeOutException {
      return ApiResponse.error('Request timed out');
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        rethrow;
      }
      return ApiResponse.error(e.toString());
    }
  }

  Future<Map<String, dynamic>> _buildUploadFields(String fieldName, File mediaFile) async {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final suffix = Random().nextInt(1 << 32);
    return {
      fieldName: await MultipartFile.fromFile(
        mediaFile.path,
        filename: 'photo_${stamp}_$suffix.jpg',
      ),
    };
  }

  _UploadRoute _resolveUploadRoute(int? claimId, String claimType, {int? documentId}) {
    switch (claimType) {
      case 'insp':
        return _UploadRoute('media-file/$claimId/insp', 'inspImages[0]');
      case 're-insp':
        return _UploadRoute('media-file/$claimId/reinsp', 'reInspImages[0]');
      case 'sd':
        return _UploadRoute('media-file/$claimId/sd', 'sdImages[0]');
      case 'pre':
        return _UploadRoute('media-file/$claimId/pre', 'preInspImages[0]');
      case 'doc':
        if (documentId == null) {
          throw ArgumentError('documentId is required for document uploads');
        }
        return _UploadRoute('media-file/$claimId/docs/$documentId', 'docImages[0]');
      default:
        throw ArgumentError('Unsupported media upload type: $claimType');
    }
  }

  Future<ApiResponse<ResponseModel>> deleteMedia(BuildContext context, int? imageId) async {
    try {
      var response = await Api.deleteRequestData("media-file/$imageId", context, sendToken: true);
      debugPrint("Delete Response: $response");
      ResponseModel responseModel = ResponseModel.fromJson(response);
      return ApiResponse.completed(responseModel);
    } on BadRequestException {
      return ApiResponse.error('Bad Request Exception');
    } on UnauthorisedException {
      return ApiResponse.error('The User is Un-authorized');
    } on RequestNotFoundException {
      return ApiResponse.error('Request Not Found');
    } on UnautorizationException {
      return ApiResponse.error('The User is Un-authorized');
    } on InternalServerException {
      return ApiResponse.error('Internal Server Error');
    } on ServerNotFoundException {
      return ApiResponse.error('Server Not Available');
    } on FetchDataException {
      return ApiResponse.error('An Error occurred while Fetching the Data');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}

class _UploadRoute {
  final String endpoint;
  final String fieldName;

  const _UploadRoute(this.endpoint, this.fieldName);
}
