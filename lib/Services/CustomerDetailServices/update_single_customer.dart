import 'package:flutter/material.dart';
import '../../Model/response_model.dart';
import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class UpdateSingleCustomer {
  Future<ApiResponse<ResponseModel>> updateCustomerDetail(BuildContext context, int? id, dynamic body) async {
    try {
      debugPrint("BODY:: $body");
      var response = await Api.putRequestData("claim/$id/mobile", body, context, sendToken: true);
      debugPrint("Update Response:: $response");
      if (response.toString() == "Request Timeout") {
        response = {
          "success": false,
          "data": null,
          "error": {"message": "Request Timeout"}
        };
      }
      ResponseModel requestModel = ResponseModel.fromJson(response);
      debugPrint("Update Response $response");
      return ApiResponse.completed(requestModel);
    } on AppException catch (e) {
      return ApiResponse.error(e.message);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
