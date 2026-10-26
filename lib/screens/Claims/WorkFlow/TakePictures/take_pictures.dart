import 'package:flutter/material.dart';
import 'package:icms_app/screens/Claims/WorkFlow/TakePictures/take_pictures_ui.dart';
import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../components/workflow/workflow_async_body.dart';
import '../../../../constants/globals.dart';

class TakePicturesScreen extends StatefulWidget {
  final int? id;

  const TakePicturesScreen({super.key, this.id});

  @override
  State<TakePicturesScreen> createState() => _TakePicturesScreenState();
}

class _TakePicturesScreenState extends State<TakePicturesScreen> {
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;

  @override
  void initState() {
    super.initState();
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    debugPrint(" ClaimType:: $claimsType");
  }

  Future _handleRefresh() async {
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    await Future.delayed(const Duration(milliseconds: 1500));
    return _getCustomerDetails;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        body: FutureBuilder<ApiResponse<dynamic>?>(
            future: _getCustomerDetails,
            builder: (context, AsyncSnapshot<ApiResponse<dynamic>?> snapshot) {
              return workflowAsyncBody(
                snapshot: snapshot,
                fallback: 'Failed to load pictures.',
                ready: () => const PicturesUI(),
              );
            }),
      ),
    );
  }
}
