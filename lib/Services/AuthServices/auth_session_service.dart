import 'package:flutter/material.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:icms_app/screens/Auth/login.dart';

import '../NotificationHandler/one_signal_service.dart';
import 'token_storage.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AuthSessionService {
  static bool _isLoggingOut = false;

  static Future<void> forceLogout({String message = 'Session Expired'}) async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await TokenStorage.clearAuthSession();
      await OneSignalServices().unSubscribeOneSignal();

      userId = null;
      userableId = null;
      zoneId = null;
      claimsType = '';

      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        showSnackBar(context, message);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    } finally {
      _isLoggingOut = false;
    }
  }
}
