import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/Dashboard/pre_inspection_dashboard_response_model.dart';
import 'package:provider/provider.dart';

import '../../Providers/DashboardProvider/dashboard_provider.dart';
import '../../Services/API/api_response.dart';
import '../../Services/DashboardService/dashboard_service.dart';
import '../../components/app_loader.dart';
import '../../components/dashboard/dashboard_stage_colors.dart';
import '../../components/dashboard/dashboard_stat_card.dart';
import '../../constants/globals.dart';
import '../Claims/pending_claims.dart';

class PreInspectionDashboard extends StatefulWidget {
  const PreInspectionDashboard({super.key});

  @override
  State<PreInspectionDashboard> createState() => _PreInspectionDashboardState();
}

class _PreInspectionDashboardState extends State<PreInspectionDashboard> with AutomaticKeepAliveClientMixin {
  Future<ApiResponse<PreInspectionDashboardResponseModel>>? _getDashboard;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDashboard = DashBoardService().getPreInspectDashboard(context, int.parse(userId!));
  }

  Future _handleRefresh() async {
    _getDashboard = DashBoardService().getPreInspectDashboard(context, int.parse(userId!));
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
          isPre: true,
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
      child: FutureBuilder<ApiResponse<PreInspectionDashboardResponseModel>>(
        future: _getDashboard,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: AppLoader());
          }

          if (isLoading) {
            return const Center(child: AppLoader());
          }

          return Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, _) {
              final dashboardData = dashboardProvider.preInspectDashboardResponse?.data;

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
                          count: dashboardData?.ack,
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
                          title: 'Inspection',
                          count: dashboardData?.insp,
                          icon: CupertinoIcons.doc_text_search,
                          iconColor: DashboardStageColors.styleForStage(DashboardStageKeys.surveys).iconColor,
                          iconBackgroundColor:
                              DashboardStageColors.styleForStage(DashboardStageKeys.surveys).iconBackgroundColor,
                          onTap: () => _openClaims(
                            apiType: 'attended',
                            headerText: 'Inspection',
                            claimType: 'pre',
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
                            claimType: 'pre',
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
