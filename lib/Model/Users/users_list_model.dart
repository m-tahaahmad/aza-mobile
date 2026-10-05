import '../Auth/login_request_model.dart';

class UsersListModel {
  List<LoginRequestModel>? data;

  UsersListModel({this.data});

  UsersListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LoginRequestModel>[];
      json['data'].forEach((v) {
        data!.add(LoginRequestModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
