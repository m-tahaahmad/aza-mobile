import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Services/CustomerDetailServices/customer_detail_service.dart';
import 'package:icms_app/Services/ReportService/report_service.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/custom_filled_button.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:provider/provider.dart';

class IssueReportTab extends StatefulWidget {
  final int? claimId;

  const IssueReportTab({super.key, this.claimId});

  @override
  State<IssueReportTab> createState() => _IssueReportTabState();
}

class _IssueReportTabState extends State<IssueReportTab> {
  bool _isLoading = false;
  bool _isIssuing = false;

  @override
  void initState() {
    super.initState();
    _loadClaim();
  }

  Future<void> _loadClaim() async {
    if (widget.claimId == null) return;
    setState(() => _isLoading = true);
    await CustomerDetailService().getCustomerDetail(context, widget.claimId);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _issueReport() async {
    if (widget.claimId == null) return;

    final provider = Provider.of<CustomerDetailProvider>(context, listen: false);
    final data = provider.customerDetailResponseModel?.data;
    final bill = data?.bill;
    final refNo = data?.refNo;

    if (refNo != null && refNo.toString().trim().isNotEmpty) {
      showSnackBar(context, 'Report has already been issued.');
      return;
    }

    final netTotal = bill?.netTotal;
    if (netTotal == null ||
        (netTotal is int && netTotal == 0) ||
        (netTotal is String && (netTotal.isEmpty || netTotal == '0'))) {
      showSnackBar(context, 'Report cannot issue without bill.', color: Colors.red);
      return;
    }

    setState(() => _isIssuing = true);
    final result = await ReportService().getRefNo(context, widget.claimId!);

    if (mounted) {
      setState(() => _isIssuing = false);
      if (result.responseData?.success == true) {
        showSnackBar(context, 'Report issued successfully');
        _loadClaim();
      } else {
        showSnackBar(context, result.message ?? 'Failed to issue report', color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: AppLoader());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(12.sp),
      child: Consumer<CustomerDetailProvider>(
        builder: (context, provider, _) {
          final data = provider.customerDetailResponseModel?.data;
          final refNo = data?.refNo;
          final isIssued = refNo != null && refNo.toString().trim().isNotEmpty;
          final bill = data?.bill;
          final hasBill = bill?.netTotal != null &&
              !(bill!.netTotal is int && bill.netTotal == 0) &&
              !(bill.netTotal is String && (bill.netTotal.toString().isEmpty || bill.netTotal == '0'));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isIssued) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Report issued',
                            style: TextStyle(
                              fontSize: FontSizes.normalText2,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Ref No: ${refNo ?? "-"}',
                            style: TextStyle(fontSize: FontSizes.normalText1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    'Issue the survey report for this claim after the bill has been created and saved.',
                    style: TextStyle(fontSize: FontSizes.normalText1, color: Colors.black87),
                  ),
                ),
                if (!hasBill)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      'Save a bill with a net total first. Report cannot be issued without a bill.',
                      style: TextStyle(fontSize: FontSizes.smallText, color: Colors.red.shade700),
                    ),
                  ),
                _isIssuing
                    ? const Center(child: AppLoader())
                    : CustomFilledButton(
                        width: MediaQuery.of(context).size.width,
                        height: 48.h,
                        title: "Issue Report",
                        btnColor: hasBill ? ColorConstants.primaryColor : ColorConstants.disableButtonColor,
                        onPressed: _issueReport,
                      ),
              ],
            ],
          );
        },
      ),
    );
  }
}
