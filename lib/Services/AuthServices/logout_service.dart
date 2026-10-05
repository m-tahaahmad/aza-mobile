import 'package:flutter/material.dart';
import 'package:icms_app/Model/Auth/logout_response_model.dart';
import 'package:icms_app/Providers/UserData/user_data_provider.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:provider/provider.dart';

import '../../components/custom_snack_bar.dart';
import '../API/api.dart';
import '../AuthServices/auth_session_service.dart';

class LogoutService {
  Future<LogoutResponseModel?> logout(BuildContext context) async {
    final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    try {
      userDataProvider.setLoggingOut = true;
      final body = {"userId": userId};
      final response = await Api.postRequestData("logout", body, context, sendToken: true);
      final responseModel = LogoutResponseModel.fromJson(response);
      if (responseModel.success!) {
        userDataProvider.setLoggingOut = false;
        await AuthSessionService.forceLogout(message: 'Logged Out');
      } else {
        userDataProvider.setLoggingOut = false;
        if (!context.mounted) return responseModel;
        showSnackBar(context, 'Error Logging Out.');
      }
      return responseModel;
    } catch (e) {
      userDataProvider.setLoggingOut = false;
      if (!context.mounted) return null;
      showSnackBar(context, 'Error Logging Out.');
      return null;
    }
  }
}
