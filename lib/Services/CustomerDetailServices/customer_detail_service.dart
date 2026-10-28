import 'package:flutter/material.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Services/API/api_response.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/utils/json_values.dart';
import 'package:provider/provider.dart';

import '../API/api.dart';

class CustomerDetailService {
  Future<ApiResponse<CustomerDetailResponseModel>?> getCustomerDetail(BuildContext context, int? id) async {
    try {
      var response = await Api.getRequestData("claim/$id/mobile", context);

      if (response == null || response is! Map<String, dynamic>) {
        debugPrint('[Claim API] claim/$id/mobile response null or not Map: $response');
        ClientErrorReporter.report(
          kind: ClientErrorKind.client,
          userVisibleMessage: 'Failed to load claim details.',
          originalMessage: 'Response was null or not a map',
          exceptionClass: 'Mobile.EmptyResponse',
        );
        return ApiResponse.error('Failed to load claim details.');
      }

      // Debug: log API response to verify bill data from backend
      final data = response['data'];
      final bill = data != null && data is Map ? data['bill'] : null;
      debugPrint('[Claim API] claim/$id/mobile full response keys: ${response.keys.toList()}');
      debugPrint('[Claim API] claim/$id/mobile data.bill present: ${bill != null}, value: $bill');

      CustomerDetailResponseModel customerDetailResponse = CustomerDetailResponseModel.fromJson(response);
      final unparsed = takeUnparsedNumberMessage();
      if (unparsed != null && context.mounted) {
        showSnackBar(context, unparsed);
      }
      if (!context.mounted) return ApiResponse.completed(customerDetailResponse);
      Provider.of<CustomerDetailProvider>(context, listen: false).setCustomerDetailResponseModel = customerDetailResponse;
      return ApiResponse.completed(customerDetailResponse);
    } catch (error, stack) {
      debugPrint('[Claim API] claim/$id/mobile failed: $error\n$stack');
      ClientErrorReporter.report(
        kind: ClientErrorKind.client,
        userVisibleMessage: 'Failed to load claim details.',
        originalMessage: error.toString(),
        exceptionClass: error.runtimeType.toString(),
        stackTrace: stack.toString(),
      );
      return ApiResponse.error('Failed to load claim details.');
    }
  }
}
