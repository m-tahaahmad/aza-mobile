import '../error_model.dart';

class UserDataResponseModel {
  bool? success;
  UserData? data;
  ErrorModel? error;

  UserDataResponseModel({this.success, this.data, this.error});

  UserDataResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    error = json['error'] != null ? ErrorModel.fromJson(json['error']) : null;
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'] ?? json['token'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
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
    id = json['id'];
    userableType = json['userable_type'];
    userableId = json['userable_id'];
    roleId = json['role_id'];
    zoneId = json['zone_id'];
    username = json['username'];
    isLoggedIn = json['is_logged_in'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
