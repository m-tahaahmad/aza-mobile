import 'package:flutter/cupertino.dart';
import 'package:icms_app/Model/error_model.dart';
import 'package:icms_app/Model/Users/user_data_response_model.dart';
import 'package:icms_app/Providers/UserData/user_data_provider.dart';
import 'package:icms_app/Services/API/api.dart';
import 'package:icms_app/Services/API/app_exceptions.dart';
import 'package:provider/provider.dart';

import '../../Model/Auth/login_request_model.dart';

class LoginServices {
  Future<UserDataResponseModel?> login(BuildContext context, {String? username, String? password}) async {
    LoginRequestModel loginRequest = LoginRequestModel(username: username, password: password);

    try {
      var response = await Api.postRequestData("login?type=surveyor", loginRequest.toJson(), context);
      debugPrint("Login Response:: $response");

      UserDataResponseModel userDataResponse = UserDataResponseModel.fromJson(response);
      if (!context.mounted) return userDataResponse;
      Provider.of<UserDataProvider>(context, listen: false).setUserDataResponseModel = userDataResponse;

      return userDataResponse;
    } on UnautorizationException catch (e) {
      return UserDataResponseModel(
        success: false,
        error: ErrorModel(message: e.message, code: e.code),
      );
    } on AppException catch (e) {
      return UserDataResponseModel(
        success: false,
        error: ErrorModel(message: e.message),
      );
    } catch (e) {
      return UserDataResponseModel(
        success: false,
        error: ErrorModel(message: 'Something went wrong'),
      );
    }
  }
}
