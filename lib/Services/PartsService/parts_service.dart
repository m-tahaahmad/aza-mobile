import 'package:flutter/material.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Model/LabourParts/labour_parts_response_model.dart';
import 'package:icms_app/Providers/LabourPartsProvider/labour_parts_provider.dart';
import 'package:icms_app/Providers/PartsInvolveProvider/parts_involve_provider.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:provider/provider.dart';
import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class PartsService {
  Future<ApiResponse<LabourPartsResponseModel>> getLabourParts(BuildContext context) async {
    try {
      var response = await Api.getRequestData("mobile/labour-part", context);
      LabourPartsResponseModel responseModel = LabourPartsResponseModel.fromJson(response);
      debugPrint("Labour Parts: ${responseModel.toJson()}");
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<LabourPartsProvider>(context, listen: false).setAllLabourParts = responseModel;
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

  Future<ApiResponse<LabourPartsResponseModel>> getAllParts(BuildContext context) async {
    try {
      var response = await Api.getRequestData("mobile/part", context);
      LabourPartsResponseModel responseModel = LabourPartsResponseModel.fromJson(response);
      debugPrint("Parts: ${responseModel.toJson()}");
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<PartsInvolveProvider>(context, listen: false).setAllParts = responseModel;
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

  Future<ApiResponse<Part>> createLabourPart(BuildContext context, String name) {
    final provider = Provider.of<LabourPartsProvider>(context, listen: false);
    return _createNamedPart(
      context: context,
      name: name,
      endpoint: 'labour-part',
      alreadyExistsMessage: 'Labour Part already exists',
      catalog: provider.labourPartsResponseModel?.data,
      onCreated: provider.appendCatalogPart,
    );
  }

  Future<ApiResponse<Part>> createPart(BuildContext context, String name) {
    final provider = Provider.of<PartsInvolveProvider>(context, listen: false);
    return _createNamedPart(
      context: context,
      name: name,
      endpoint: 'part',
      alreadyExistsMessage: 'Part already exists',
      catalog: provider.partsResponseModel?.data,
      onCreated: provider.appendCatalogPart,
    );
  }

  Future<ApiResponse<Part>> _createNamedPart({
    required BuildContext context,
    required String name,
    required String endpoint,
    required String alreadyExistsMessage,
    required List<Part>? catalog,
    required void Function(Part part) onCreated,
  }) async {
    final trimmed = name.trim();
    if (_findByName(catalog, trimmed) != null) {
      if (context.mounted) {
        showSnackBar(context, alreadyExistsMessage, color: Colors.red);
      }
      return ApiResponse.error(alreadyExistsMessage);
    }

    try {
      final response = await Api.postRequestData(
        endpoint,
        {
          'data': {'name': trimmed},
        },
        context,
        sendToken: true,
      );
      final part = _parseCreatedPart(response);
      if (part == null) {
        return ApiResponse.error('Invalid response');
      }
      onCreated(part);
      return ApiResponse.completed(part);
    } on BadRequestException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.message, color: Colors.red);
      }
      return ApiResponse.error(e.message);
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

  static Part? _findByName(List<Part>? items, String name) {
    final query = name.trim().toLowerCase();
    if (query.isEmpty) return null;
    for (final item in items ?? const <Part>[]) {
      if ((item.name ?? '').trim().toLowerCase() == query) {
        return item;
      }
    }
    return null;
  }

  static Part? _parseCreatedPart(dynamic response) {
    if (response is! Map) return null;
    dynamic data = response['data'];
    if (data is Map && data['data'] is Map) {
      data = data['data'];
    }
    if (data is! Map) return null;
    return Part.fromJson(Map<String, dynamic>.from(data));
  }
}
