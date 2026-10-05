import 'package:flutter/material.dart';
import 'package:icms_app/components/custom_app_bar.dart';
import 'package:icms_app/screens/Claims/WorkFlow/BillAndReport/bill_tab.dart';
import 'package:icms_app/screens/Claims/WorkFlow/BillAndReport/issue_report_tab.dart';
import 'package:icms_app/constants/theme_constants.dart';

class BillAndReportScreen extends StatefulWidget {
  final int? id;

  const BillAndReportScreen({super.key, this.id});

  @override
  State<BillAndReportScreen> createState() => _BillAndReportScreenState();
}

class _BillAndReportScreenState extends State<BillAndReportScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: "Bill & Issue Report",
          showBackButton: true,
          onTap: () => Navigator.of(context).pop(),
          bottom: TabBar(
            labelColor: ColorConstants.white,
            unselectedLabelColor: ColorConstants.white.withValues(alpha: 0.7),
            indicatorColor: ColorConstants.white,
            tabs: const [
              Tab(text: "Bill"),
              Tab(text: "Issue Report"),
            ],
          ),
        ) as PreferredSizeWidget?,
        body: TabBarView(
          children: [
            BillTab(claimId: widget.id),
            IssueReportTab(claimId: widget.id),
          ],
        ),
      ),
    );
  }
}
