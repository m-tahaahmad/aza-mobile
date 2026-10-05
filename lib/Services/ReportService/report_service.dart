import 'package:flutter/material.dart';

import '../../Model/response_model.dart';
import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class ReportService {
  Future<ApiResponse<ResponseModel>> getRefNo(BuildContext context, int claimId) async {
    try {
      var response = await Api.getRequestData("claim/ref/no/$claimId", context);
      if (response.toString() == "Request Timeout") {
        response = {
          "success": false,
          "data": null,
          "error": {"message": "Request Timeout"}
        };
      }
      ResponseModel responseModel = ResponseModel.fromJson(response as Map<String, dynamic>);
      return ApiResponse.completed(responseModel);
    } on BadRequestException {
      return ApiResponse.error('Bad Request Exception');
    } on UnauthorisedException {
      return ApiResponse.error('The User is Un-authorized');
    } on RequestNotFoundException {
      return ApiResponse.error('Request Not Found');
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
