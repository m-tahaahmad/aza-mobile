import 'package:flutter/material.dart';
import 'package:icms_app/Model/LabourParts/labour_parts_response_model.dart';
import 'package:icms_app/screens/Claims/WorkFlow/Labour/labour_ui.dart';
import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../Services/PartsService/parts_service.dart';
import '../../../../components/app_loader.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/font_sizes.dart';

class LabourScreen extends StatefulWidget {
  final int? id;
  final bool comeFromThirdParty;

  const LabourScreen({super.key, this.id, this.comeFromThirdParty = false});

  @override
  State<LabourScreen> createState() => _LabourScreenState();
}

class _LabourScreenState extends State<LabourScreen> {
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;
  Future<ApiResponse<LabourPartsResponseModel>>? getLabourParts;
  Future<List<ApiResponse<dynamic>?>>? apisList;

  @override
  void initState() {
    super.initState();
    getLabourParts = PartsService().getLabourParts(context);
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    apisList = Future.wait([_getCustomerDetails!, getLabourParts!]);
  }

  Future _handleRefresh() async {
    getLabourParts = PartsService().getLabourParts(context);
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    apisList = Future.wait([_getCustomerDetails!, getLabourParts!]);
    await Future.delayed(const Duration(milliseconds: 1500));
    return apisList;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorConstants.primaryColor,
      onRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        body: FutureBuilder<List<ApiResponse<dynamic>?>>(
          future: apisList,
          builder: (context, AsyncSnapshot<List<ApiResponse<dynamic>?>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: AppLoader());
            }

            final results = snapshot.data!;
            final allCompleted = results.every((response) => response?.status == Status.completed);
            if (!allCompleted) {
              final message = results
                  .where((response) => response?.status == Status.error)
                  .map((response) => response?.message)
                  .whereType<String>()
                  .firstOrNull;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    message ?? 'Failed to load labour details.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FontSizes.normalText1,
                      color: const Color(0xFF667085),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }

            return LabourUI(
              id: widget.id,
              comeFromThirdParty: widget.comeFromThirdParty,
            );
          },
        ),
      ),
    );
  }
}
