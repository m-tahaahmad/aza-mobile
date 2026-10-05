import 'package:flutter/material.dart';
import 'package:icms_app/Model/Dashboard/dashboard_response_model.dart';
import 'package:icms_app/Providers/DashboardProvider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../Model/Dashboard/pre_inspection_dashboard_response_model.dart';
import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class DashBoardService {
  Future<ApiResponse<DashboardResponseModel>> getDashboard(BuildContext context, int userId) async {
    try {
      var response = await Api.getRequestData("dashboard/mobile/$userId", context);
      debugPrint("Customer Detail Response:: $response");

      DashboardResponseModel responseModel = DashboardResponseModel.fromJson(response);
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<DashboardProvider>(context, listen: false).setDashboardResponse = responseModel;

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

  Future<ApiResponse<PreInspectionDashboardResponseModel>> getPreInspectDashboard(BuildContext context, int userId) async {
    try {
      var response = await Api.getRequestData("dashboard/mobile/pre/$userId", context);
      debugPrint("Customer Detail Response:: $response");

      PreInspectionDashboardResponseModel responseModel = PreInspectionDashboardResponseModel.fromJson(response);
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<DashboardProvider>(context, listen: false).setPreInspectDashboardResponse = responseModel;

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
