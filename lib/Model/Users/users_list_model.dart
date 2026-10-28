import '../Auth/login_request_model.dart';
import 'package:icms_app/utils/json_values.dart';

class UsersListModel {
  List<LoginRequestModel>? data;

  UsersListModel({this.data});

  UsersListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = readJsonList(json['data'], LoginRequestModel.fromJson, field: 'data');
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
