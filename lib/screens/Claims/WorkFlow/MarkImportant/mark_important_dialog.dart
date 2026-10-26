import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/screens/Claims/WorkFlow/MarkImportant/mark_important_dialog_ui.dart';
import 'package:provider/provider.dart';

import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../Providers/WorkflowProvider/workflow_provider.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../components/workflow/workflow_async_body.dart';

class MarkImportantDialog extends StatefulWidget {
  final int? id;

  const MarkImportantDialog({super.key, this.id});

  @override
  State<MarkImportantDialog> createState() => _MarkImportantDialogState();
}

class _MarkImportantDialogState extends State<MarkImportantDialog> {
  static const _notAvailable = '';
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;

  @override
  void initState() {
    super.initState();
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height * 0.82),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mark as important',
                          style: TextStyle(
                            fontSize: FontSizes.largeText,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Complete the details below to flag this claim.',
                          style: TextStyle(
                            fontSize: FontSizes.normalText1,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF667085),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, size: 22.sp, color: const Color(0xFF667085)),
                  ),
                ],
              ),
            ),
            Flexible(
              child: FutureBuilder<ApiResponse<CustomerDetailResponseModel>?>(
                future: _getCustomerDetails,
                builder: (context, snapshot) {
                  final gate = workflowAsyncGate(
                    snapshot: snapshot,
                    fallback: 'Failed to load claim details.',
                  );
                  if (gate != null) return gate;

                  return Consumer2<CustomerDetailProvider, WorkflowProvider>(
                    builder: (context, customerDetailProvider, workflowProvider, child) {
                      final customerDetailData = customerDetailProvider.customerDetailResponseModel?.data;
                      if (customerDetailData == null) {
                        return workflowLoadMessage('Failed to load claim details.');
                      }
                      return MarkImportantDialogUI(
                        id: widget.id,
                        lossDate: customerDetailData.dateOfLoss ?? _notAvailable,
                        totalMileage: customerDetailData.vehicle?.millage ?? _notAvailable,
                        insuredSince: customerDetailData.insuredSince ?? _notAvailable,
                        previousClaims: customerDetailData.previousClaims ?? _notAvailable,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
