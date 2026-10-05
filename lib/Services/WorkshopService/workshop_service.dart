import 'package:flutter/material.dart';
import 'package:icms_app/Model/WorkshopsModel/all_workshops_model.dart';
import 'package:provider/provider.dart';
import '../../Providers/WorkshopsProvider/workshops_provider.dart';
import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class WorkshopService {
  Future<ApiResponse<AllWorkshopsModel>> getAllWorkshops(BuildContext context) async {
    return _fetchWorkshops(context, 'workshop');
  }

  Future<ApiResponse<AllWorkshopsModel>> getWorkshopsByZone(BuildContext context, String zoneId) async {
    final trimmedZoneId = zoneId.trim();
    if (trimmedZoneId.isEmpty) {
      final emptyModel = AllWorkshopsModel(success: true, data: []);
      Provider.of<WorkshopsProvider>(context, listen: false).setAllWorkshops = emptyModel;
      return ApiResponse.completed(emptyModel);
    }

    return _fetchWorkshops(context, 'mobile/workshop/$trimmedZoneId');
  }

  Future<ApiResponse<AllWorkshopsModel>> _fetchWorkshops(BuildContext context, String endpoint) async {
    try {
      var response = await Api.getRequestData(endpoint, context);
      AllWorkshopsModel responseModel = AllWorkshopsModel.fromJson(response);
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<WorkshopsProvider>(context, listen: false).setAllWorkshops = responseModel;
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
