import '../error_model.dart';
import 'package:icms_app/utils/json_values.dart';

class UserDataResponseModel {
  bool? success;
  UserData? data;
  ErrorModel? error;

  UserDataResponseModel({this.success, this.data, this.error});

  UserDataResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = readJsonObject(json['data'], UserData.fromJson, field: 'data');
    error = readJsonObject(json['error'], ErrorModel.fromJson, field: 'error');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class UserData {
  User? user;
  String? accessToken;
  String? refreshToken;
  int? expiresIn;
  String? tokenType;

  UserData({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
  });

  String? get token => accessToken;

  UserData.fromJson(Map<String, dynamic> json) {
    user = readJsonObject(json['user'], User.fromJson, field: 'user');
    accessToken = json['access_token'] ?? json['token'];
    refreshToken = readString(json['refresh_token']);
    expiresIn = readInt(json['expires_in'], field: 'expires_in');
    tokenType = readString(json['token_type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['expires_in'] = expiresIn;
    data['token_type'] = tokenType;
    data['token'] = accessToken;
    return data;
  }
}

class User {
  int? id;
  String? userableType;
  int? userableId;
  int? roleId;
  dynamic zoneId;
  String? username;
  int? isLoggedIn;
  String? createdAt;
  String? updatedAt;

  User({this.id, this.userableType, this.userableId, this.roleId, this.zoneId, this.username, this.isLoggedIn, this.createdAt, this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = readInt(json['id'], field: 'id');
    userableType = readString(json['userable_type']);
    userableId = readInt(json['userable_id'], field: 'userable_id');
    roleId = readInt(json['role_id'], field: 'role_id');
    zoneId = json['zone_id'];
    username = readString(json['username']);
    isLoggedIn = readInt(json['is_logged_in'], field: 'is_logged_in');
    createdAt = readString(json['created_at']);
    updatedAt = readString(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userable_type'] = userableType;
    data['userable_id'] = userableId;
    data['role_id'] = roleId;
    data['zone_id'] = zoneId;
    data['username'] = username;
    data['is_logged_in'] = isLoggedIn;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
