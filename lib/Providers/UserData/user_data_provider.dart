import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icms_app/Model/Users/user_data_response_model.dart';
import 'package:icms_app/Services/AuthServices/auth_session_service.dart';

class UserDataProvider extends ChangeNotifier {
  UserDataResponseModel? _userDataResponseModel;

  UserDataResponseModel? get userDataResponseModel => _userDataResponseModel;

  set setUserDataResponseModel(UserDataResponseModel responseModel) {
    _userDataResponseModel = responseModel;
    notifyListeners();
  }

  bool isLoggingOut = false;

  set setLoggingOut(value) {
    isLoggingOut = value;
    notifyListeners();
  }

  Future<void> clearSession(BuildContext context) async {
    await AuthSessionService.forceLogout();
  }
}
