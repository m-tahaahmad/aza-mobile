import 'package:flutter/material.dart';
import 'package:icms_app/screens/Claims/WorkFlow/PartsInvolves/parts_involves_ui.dart';

import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Model/LabourParts/labour_parts_response_model.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../Services/PartsService/parts_service.dart';
import '../../../../components/app_loader.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/font_sizes.dart';

class PartsInvolvesScreen extends StatefulWidget {
  final int? id;
  final bool comeFromThirdParty;

  const PartsInvolvesScreen({super.key, this.id, this.comeFromThirdParty = false});

  @override
  State<PartsInvolvesScreen> createState() => _PartsInvolvesScreenState();
}

class _PartsInvolvesScreenState extends State<PartsInvolvesScreen> {
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;
  Future<ApiResponse<LabourPartsResponseModel>>? getAllParts;
  Future<List<ApiResponse<dynamic>?>>? apisList;

  @override
  void initState() {
    super.initState();
    getAllParts = PartsService().getAllParts(context);
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    apisList = Future.wait([_getCustomerDetails!, getAllParts!]);
  }

  Future _handleRefresh() async {
    getAllParts = PartsService().getAllParts(context);
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    apisList = Future.wait([_getCustomerDetails!, getAllParts!]);
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
                    message ?? 'Failed to load parts details.',
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

            return PartsInvolvesUI(
              id: widget.id,
              comeFromThirdParty: widget.comeFromThirdParty,
            );
          },
        ),
      ),
    );
  }
}
