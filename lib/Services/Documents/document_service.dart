import 'package:flutter/material.dart';
import 'package:icms_app/Model/DocumentsModel/document_response_model.dart';
import 'package:icms_app/Providers/DocumentsProvider/documents_provider.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';
import 'package:provider/provider.dart';

import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class DocumentService {
  Future<ApiResponse<DocumentResponseModel>> getAllDocument(BuildContext context) async {
    try {
      var response = await Api.getRequestData("mobile/document", context);
      DocumentResponseModel responseModel = DocumentResponseModel.fromJson(response);
      debugPrint("Documents: ${responseModel.toJson()}");
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<DocumentsProvider>(context, listen: false).setAllDocument = responseModel;
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
    } catch (e, stack) {
      debugPrint('Documents failed: $e\n$stack');
      ClientErrorReporter.report(
        kind: ClientErrorKind.client,
        userVisibleMessage: 'Failed to load documents.',
        originalMessage: e.toString(),
        exceptionClass: e.runtimeType.toString(),
        stackTrace: stack.toString(),
      );
      return ApiResponse.error('Failed to load documents.');
    }
  }
}
