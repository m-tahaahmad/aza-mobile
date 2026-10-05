import 'package:flutter/material.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Services/API/api_response.dart';
import 'package:provider/provider.dart';

import '../API/api.dart';

class CustomerDetailService {
  Future<ApiResponse<CustomerDetailResponseModel>?> getCustomerDetail(BuildContext context, int? id) async {
    try {
      var response = await Api.getRequestData("claim/$id/mobile", context);

      if (response == null || response is! Map<String, dynamic>) {
        debugPrint('[Claim API] claim/$id/mobile response null or not Map: $response');
        return null;
      }

      // Debug: log API response to verify bill data from backend
      final data = response['data'];
      final bill = data != null && data is Map ? data['bill'] : null;
      debugPrint('[Claim API] claim/$id/mobile full response keys: ${response.keys.toList()}');
      debugPrint('[Claim API] claim/$id/mobile data.bill present: ${bill != null}, value: $bill');

      CustomerDetailResponseModel customerDetailResponse = CustomerDetailResponseModel.fromJson(response);
      if (!context.mounted) return ApiResponse.completed(customerDetailResponse);
      Provider.of<CustomerDetailProvider>(context, listen: false).setCustomerDetailResponseModel = customerDetailResponse;
      return ApiResponse.completed(customerDetailResponse);
    } catch (e) {
      return null;
    }
  }
}
