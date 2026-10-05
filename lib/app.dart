import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icms_app/Providers/DialogProvider/dialog_provider.dart';
import 'package:icms_app/Providers/DownloadImagesProvider/download_images_provider.dart';
import 'package:icms_app/Providers/VehicleItemsProvider/vehicle_items_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'Providers/VehicleMakeProvider/vehicle_make_provider.dart';
import 'Services/AuthServices/auth_session_service.dart';
import 'Services/SharedPreferenceService/shared_preferences_service.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/LabourPartsProvider/labour_parts_provider.dart';
import 'package:icms_app/Providers/MediaProvider/media_provider.dart';
import 'package:icms_app/Providers/PartsInvolveProvider/parts_involve_provider.dart';
import 'package:icms_app/Providers/PendingClaimProvider/pending_claim_provider.dart';
import 'package:icms_app/Providers/UserData/user_data_provider.dart';
import 'package:icms_app/Providers/WorkshopsProvider/workshops_provider.dart';
import 'package:icms_app/constants/keys_constants.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/screens/PermissionsGate/permissions_gate_screen.dart';
import 'package:provider/provider.dart';
import 'Providers/DashboardProvider/dashboard_provider.dart';
import 'Providers/DocumentsProvider/documents_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool alreadyLogin = false;

  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  checkUserLogin() async {
    await SharedPreferencesService().getString(KeysConstants.isUserLogin).then((value) async {
      debugPrint("Value:: $value");
      if (value == "true") {
        await SharedPreferencesService().getString(KeysConstants.userId).then((value) {
          userId = value;
        });
        setState(() {
          alreadyLogin = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
            child: ScreenUtilInit(
                designSize: const Size(360, 690),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider<DashboardProvider>(create: (context) => DashboardProvider()),
                      ChangeNotifierProvider<UserDataProvider>(create: (context) => UserDataProvider()),
                      ChangeNotifierProvider<PendingClaimProvider>(create: (context) => PendingClaimProvider()),
                      ChangeNotifierProvider<CustomerDetailProvider>(create: (context) => CustomerDetailProvider()),
                      ChangeNotifierProvider<WorkshopsProvider>(create: (context) => WorkshopsProvider()),
                      ChangeNotifierProvider<LabourPartsProvider>(create: (context) => LabourPartsProvider()),
                      ChangeNotifierProvider<MediaProvider>(create: (context) => MediaProvider()),
                      ChangeNotifierProvider<PartsInvolveProvider>(create: (context) => PartsInvolveProvider()),
                      ChangeNotifierProvider<DocumentsProvider>(create: (context) => DocumentsProvider()),
                      ChangeNotifierProvider<WorkflowProvider>(create: (context) => WorkflowProvider()),
                      ChangeNotifierProvider<DialogProvider>(create: (context) => DialogProvider()),
                      ChangeNotifierProvider<VehicleMakeProvider>(create: (context) => VehicleMakeProvider()),
                      ChangeNotifierProvider<DownloadImagesProvider>(create: (context) => DownloadImagesProvider()),
                      ChangeNotifierProvider<VehicleItemsProvider>(create: (context) => VehicleItemsProvider()),
                    ],
                    child: MaterialApp(
                      navigatorKey: rootNavigatorKey,
                      title: 'Survey Snap',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        primaryColor: ColorConstants.primaryColor,
                        scaffoldBackgroundColor: ColorConstants.baseColor,
                        pageTransitionsTheme: const PageTransitionsTheme(
                          builders: {
                            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                            TargetPlatform.android: ZoomPageTransitionsBuilder(),
                          },
                        ),
                      ),
                      home: const PermissionsGateScreen(),
                    ),
                  );
                }),
          );
        });
  }
}
