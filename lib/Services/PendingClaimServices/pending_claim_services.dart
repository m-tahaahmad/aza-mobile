import 'package:flutter/material.dart';
import 'package:icms_app/Model/PendingClaims/pending_claim_response_model.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:provider/provider.dart';

import '../../Providers/PendingClaimProvider/pending_claim_provider.dart';
import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class PendingClaimServices {
  Future<ApiResponse<PendingClaimResponseModel>> getPendingClaims(BuildContext context,
      {String? claimsType, bool isSearch = false, bool isPre = false}) async {
    try {
      var response = await Api.getRequestData(
          "claim/$userId/claims?${isSearch ? "search=" : "type="}$claimsType${isPre ? "&pre=true" : ""}", context);
      PendingClaimResponseModel responseModel = PendingClaimResponseModel.fromJson(response);
      debugPrint("1st Inspection: ${responseModel.toJson()}");
      if (!context.mounted) return ApiResponse.completed(responseModel);
      Provider.of<PendingClaimProvider>(context, listen: false).setPendingClaimResponseModel = responseModel;
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
      debugPrint('Claims failed: $e\n$stack');
      ClientErrorReporter.report(
        kind: ClientErrorKind.client,
        userVisibleMessage: 'Failed to load claims.',
        originalMessage: e.toString(),
        exceptionClass: e.runtimeType.toString(),
        stackTrace: stack.toString(),
      );
      return ApiResponse.error('Failed to load claims.');
    }
  }
}
