import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/DashboardProvider/dashboard_provider.dart';
import 'package:icms_app/Providers/UserData/user_data_provider.dart';
import 'package:icms_app/Services/AuthServices/logout_service.dart';
import 'package:icms_app/Services/NotificationHandler/one_signal_service.dart';
import 'package:icms_app/Services/SettingService/public_settings_storage.dart';
import 'package:icms_app/Services/SettingService/setting_service.dart';
import 'package:icms_app/Services/SharedPreferenceService/shared_preferences_service.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/dashboard/dashboard_app_bar.dart';
import 'package:icms_app/components/dashboard/dashboard_tab_switcher.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:icms_app/screens/DashBoard/claim_dashboard.dart';
import 'package:icms_app/screens/DashBoard/global_search.dart';
import 'package:icms_app/screens/DashBoard/pre_inspection_dashboard.dart';
import 'package:provider/provider.dart';

import '../../constants/keys_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  AnimationController? controller;
  PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  String? _organizationName;

  @override
  void initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = const Duration(seconds: 1, milliseconds: 500);
    _loadOrganizationName();
    if (userId == null || zoneId == null) {
      Future.microtask(getLocalData);
    } else {
      OneSignalServices().initOneSignal(zoneId);
    }
  }

  Future<void> _loadOrganizationName() async {
    var cached = await PublicSettingsStorage.get();
    var orgName = cached?.organizationName?.trim();

    if (orgName == null || orgName.isEmpty) {
      final settings = await SettingService().fetchPublicSettings();
      if (settings != null) {
        await PublicSettingsStorage.save(settings);
        orgName = settings.organizationName?.trim();
      }
    }

    if (!mounted) return;
    setState(() {
      _organizationName = orgName?.isNotEmpty == true ? orgName : null;
    });
  }

  Future<void> getLocalData() async {
    userId = await SharedPreferencesService().getString(KeysConstants.userId);
    userableId = await SharedPreferencesService().getString(KeysConstants.userableId);
    zoneId = await SharedPreferencesService().getString(KeysConstants.zoneId);
    OneSignalServices().initOneSignal(zoneId);
    if (mounted) setState(() {});
  }

  void _onTabChanged(int index) {
    setState(() => currentPage = index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Consumer<DashboardProvider>(
                  builder: (context, dashboardProvider, _) {
                    final userName = dashboardProvider.dashboardResponseModel?.data?.user ?? '';
                    return DashboardAppBar(
                      userName: userName,
                      organizationName: _organizationName,
                      onSearchTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GlobalSearchScreen()),
                        );
                      },
                      onLogoutTap: () => LogoutService().logout(context),
                    );
                  },
                ),
                DashboardTabSwitcher(
                  currentIndex: currentPage,
                  onChanged: _onTabChanged,
                ),
                SizedBox(height: 4.h),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (page) => setState(() => currentPage = page),
                    children: const [
                      ClaimDashboard(),
                      PreInspectionDashboard(),
                    ],
                  ),
                ),
              ],
            ),
            Consumer<UserDataProvider>(
              builder: (context, userDataProvider, _) {
                return userDataProvider.isLoggingOut
                    ? Container(
                        color: Colors.black.withValues(alpha: 0.35),
                        width: size.width,
                        height: size.height,
                        child: Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const AppLoader(),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
