import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Model/Dashboard/dashboard_response_model.dart';
import '../../Providers/DashboardProvider/dashboard_provider.dart';
import '../../Services/API/api_response.dart';
import '../../Services/DashboardService/dashboard_service.dart';
import '../../components/app_loader.dart';
import '../../components/dashboard/dashboard_card_styles.dart';
import '../../components/dashboard/dashboard_stage_colors.dart';
import '../../components/dashboard/dashboard_stat_card.dart';
import 'package:icms_app/utils/json_values.dart';

import '../../constants/globals.dart';
import '../Claims/pending_claims.dart';

class ClaimDashboard extends StatefulWidget {
  const ClaimDashboard({super.key});

  @override
  State<ClaimDashboard> createState() => _ClaimDashboardState();
}

class _ClaimDashboardState extends State<ClaimDashboard> with AutomaticKeepAliveClientMixin {
  Future<ApiResponse<DashboardResponseModel>>? _getDashboard;
  bool isLoading = false;
  String? _idError;

  void _loadDashboard() {
    final id = readId(userId, field: 'user_id');
    if (id == null) {
      _idError = takeUnparsedNumberMessage() ?? 'Could not read user id.';
      _getDashboard = null;
      return;
    }
    _idError = null;
    _getDashboard = DashBoardService().getDashboard(context, id);
  }

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future _handleRefresh() async {
    _loadDashboard();
    await Future.delayed(const Duration(milliseconds: 1500));
    return _getDashboard;
  }

  Future<void> _openClaims({
    required String apiType,
    required String headerText,
    required String claimType,
    bool isReinspection = false,
  }) async {
    claimsType = claimType;
    isReinspectionsPending = isReinspection;
    final value = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PendingClaimsScreen(
          apiType: apiType,
          headerText: headerText,
        ),
      ),
    );
    refreshPageAfterComingBack(value == true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: FutureBuilder<ApiResponse<DashboardResponseModel>>(
        future: _getDashboard,
        builder: (context, snapshot) {
          if (_idError != null) {
            return Center(child: Text(_idError!));
          }
          if (!snapshot.hasData) {
            return const Center(child: AppLoader());
          }

          if (isLoading) {
            return const Center(child: AppLoader());
          }

          return Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, _) {
              final dashboardData = dashboardProvider.dashboardResponseModel?.data;

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(0, 12.h, 0, 24.h),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 1.15,
                      children: [
                        DashboardStatCard(
                          title: 'Acknowledge',
                          count: dashboardData?.acknwldge,
                          icon: CupertinoIcons.bell,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.unassigned).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.unassigned).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'unattended',
                            headerText: 'Acknowledge',
                            claimType: 'Acknowledge',
                          ),
                        ),
                        DashboardStatCard(
                          title: '1st Inspection',
                          count: dashboardData?.fInsp,
                          icon: CupertinoIcons.doc_text_search,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.surveys).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.surveys).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'attended',
                            headerText: '1st Inspection',
                            claimType: '1st Inspection',
                          ),
                        ),
                        DashboardStatCard(
                          title: 'Approval for PLR',
                          count: dashboardData?.approval,
                          icon: CupertinoIcons.signature,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.waiting).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.waiting).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'submitted',
                            headerText: 'Approval for PLR',
                            claimType: 'Waiting for approval',
                          ),
                        ),
                        DashboardStatCard(
                          title: 'Rejected',
                          count: dashboardData?.rejected,
                          icon: CupertinoIcons.exclamationmark_octagon,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.rejected).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.rejected).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'rejected',
                            headerText: 'Rejected',
                            claimType: 'Rejected',
                          ),
                        ),
                        DashboardStatCard(
                          title: 'Re-Inspections Pending',
                          count: dashboardData?.reInsp,
                          icon: CupertinoIcons.clock,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.reinspections).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.reinspections).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'settled',
                            headerText: 'Re-Inspections Pending',
                            claimType: 'Re-Inspections Pending',
                            isReinspection: true,
                          ),
                        ),
                        DashboardStatCard(
                          title: 'Re-Inspection Done',
                          count: dashboardData?.docs,
                          icon: CupertinoIcons.checkmark_alt_circle,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.docs).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.docs).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'final',
                            headerText: 'Final Stage',
                            claimType: 'Re-Inspections Pending',
                          ),
                        ),
                        DashboardStatCard(
                          title: 'Approval for FSR',
                          count: dashboardData?.finalStage,
                          icon: CupertinoIcons.doc,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.waitingFsr).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.waitingFsr).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'reinspection',
                            headerText: 'Approval for FSR',
                            claimType: 'Docs Pending',
                          ),
                        ),
                        DashboardStatCard(
                          title: 'Reports Pending',
                          count: dashboardData?.reports,
                          icon: CupertinoIcons.chart_bar,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.reports).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.reports).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'reports',
                            headerText: 'Reports Pending',
                            claimType: 'Reports Pending',
                          ),
                        ),
                        DashboardStatCard(
                          title: 'Letter & Forms',
                          count: null,
                          showCount: false,
                          icon: CupertinoIcons.doc_append,
                          iconColor: DashboardStageColors.styleForStage(
                            'letter_forms',
                            fallback: DashboardCardStyle.grey,
                          ).iconColor,
                          iconBackgroundColor: DashboardStageColors.styleForStage(
                            'letter_forms',
                            fallback: DashboardCardStyle.grey,
                          ).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'letters',
                            headerText: 'Letter & Forms',
                            claimType: 'Letter & Forms',
                          ),
                        ),
                        DashboardStatCard(
                          title: 'Monthly Reports',
                          count: dashboardData?.monthlyReports,
                          icon: CupertinoIcons.calendar,
                          iconColor: DashboardStageColors.styleForStage(
                            'monthly_reports',
                            fallback: DashboardCardStyle.teal,
                          ).iconColor,
                          iconBackgroundColor: DashboardStageColors.styleForStage(
                            'monthly_reports',
                            fallback: DashboardCardStyle.teal,
                          ).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'monthly',
                            headerText: 'Monthly Reports',
                            claimType: 'Monthly Reports',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void refreshPageAfterComingBack(bool value) {
    if (!value) return;
    setState(() => isLoading = true);
    _handleRefresh().then((_) {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
