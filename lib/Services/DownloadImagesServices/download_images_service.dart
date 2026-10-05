import 'package:flutter/material.dart';
import 'package:icms_app/Model/DownloadImages/download_images_response_model.dart';
import 'package:icms_app/Providers/DownloadImagesProvider/download_images_provider.dart';
import 'package:provider/provider.dart';
import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class DownloadImageService {
  Future<ApiResponse<DownloadImagesListModel>> getAllImages(BuildContext context, int id, {String? type}) async {
    try {
      var response = await Api.getRequestData("mobile/claim/$id/download?type=$type", context);

      final List<dynamic> imagesJson;
      if (response is Map<String, dynamic>) {
        if (response['success'] != true) {
          final message = response['error']?['message'] ?? 'Failed to load images';
          return ApiResponse.error(message);
        }
        final data = response['data'];
        if (data is! List) {
          return ApiResponse.error('Invalid response format');
        }
        imagesJson = data;
      } else if (response is List) {
        imagesJson = response;
      } else {
        return ApiResponse.error('Invalid response format');
      }

      DownloadImagesListModel responseModel = DownloadImagesListModel.fromJsonList(imagesJson);
      // print("All Workshops: ${responseModel.toJsonList()}");
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<DownloadImagesProvider>(context, listen: false).setAllImages = responseModel;
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
