import 'package:flutter/material.dart';
import 'package:icms_app/Services/TenantConfig/tenant_config.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:icms_app/constants/keys_constants.dart';
import 'package:icms_app/Services/AuthServices/token_storage.dart';
import 'package:icms_app/screens/Auth/login.dart';
import 'package:icms_app/screens/DashBoard/dashboard.dart';
import 'package:icms_app/Services/API/api.dart';
import 'package:icms_app/Services/API/app_exceptions.dart';
import 'package:icms_app/Services/SharedPreferenceService/shared_preferences_service.dart';
import 'package:permission_handler/permission_handler.dart';

enum _GateState { checking, missingPermissions, allGranted }

class PermissionsGateScreen extends StatefulWidget {
  const PermissionsGateScreen({super.key});

  @override
  State<PermissionsGateScreen> createState() => _PermissionsGateScreenState();
}

class _PermissionsGateScreenState extends State<PermissionsGateScreen>
    with WidgetsBindingObserver {
  _GateState _state = _GateState.checking;
  List<String> _missingPermissionNames = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAllPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAllPermissions();
    }
  }

  Future<void> _checkAllPermissions() async {
    if (!mounted) return;
    setState(() {
      _state = _GateState.checking;
      _missingPermissionNames = [];
    });

    final missing = <String>[];

    // Notification
    var notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      if (notificationStatus.isPermanentlyDenied) {
        missing.add('Notification');
      } else {
        await Permission.notification.request();
        notificationStatus = await Permission.notification.status;
        if (!notificationStatus.isGranted) {
          if (notificationStatus.isPermanentlyDenied) {
            missing.add('Notification');
          } else {
            missing.add('Notification');
          }
        }
      }
    }

    // Camera
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      if (cameraStatus.isPermanentlyDenied) {
        missing.add('Camera');
      } else {
        await Permission.camera.request();
        cameraStatus = await Permission.camera.status;
        if (!cameraStatus.isGranted) {
          missing.add('Camera');
        }
      }
    }

    if (!mounted) return;

    if (missing.isNotEmpty) {
      setState(() {
        _state = _GateState.missingPermissions;
        _missingPermissionNames = missing;
      });
      return;
    }

    setState(() => _state = _GateState.allGranted);
    _navigateToApp();
  }

  Future<void> _navigateToApp() async {
    await TenantConfig.restoreFromStorage();
    bool showDashboard = await TokenStorage.isAuthenticated();
    if (showDashboard) {
      final id = await SharedPreferencesService().getString(KeysConstants.userId);
      if (!mounted) return;
      userId = id;
      if (id == null || id.isEmpty) {
        await SharedPreferencesService().remove(KeysConstants.isUserLogin);
        showDashboard = false;
      } else {
        try {
          await Api.getRequestData("dashboard/mobile/$id", context);
          if (!mounted) return;
        } catch (e) {
          if (e is UnauthorisedException || e is UnautorizationException) {
            showDashboard = false;
          }
          // On network/other errors, fall through and show Dashboard; first real request will trigger 401 if token invalid.
        }
      }
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => showDashboard ? const DashboardScreen() : const LoginScreen(),
      ),
    );
  }

  void _openSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _GateState.allGranted) {
      return Scaffold(
        backgroundColor: ColorConstants.baseColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_state == _GateState.checking) {
      return Scaffold(
        backgroundColor: ColorConstants.baseColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Checking permissions…',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // missingPermissions
    return Scaffold(
      backgroundColor: ColorConstants.baseColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'This app needs notification and camera access to work properly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: ColorConstants.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please allow: ${_missingPermissionNames.join(", ")}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _openSettings,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
