import 'package:flutter/material.dart';
import 'package:icms_app/Model/VehicleMakeModel/vehicle_make_response_model.dart';
import 'package:icms_app/Providers/VehicleMakeProvider/vehicle_make_provider.dart';
import 'package:provider/provider.dart';

import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class VehicleMakeService {
  Future<ApiResponse<VehicleMakeResponseModel>> getAllVehicleMake(BuildContext context) async {
    try {
      var response = await Api.getRequestData("vehicle-make", context);
      VehicleMakeResponseModel responseModel = VehicleMakeResponseModel.fromJson(response);
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<VehicleMakeProvider>(context, listen: false).setVehicleMake = responseModel;
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