import 'package:icms_app/utils/json_values.dart';

class ErrorModel {
  String? message;
  String? code;
  String? reason;

  ErrorModel({this.message, this.code, this.reason});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    message = readString(json['message']);
    code = readString(json['code']);
    reason = readString(json['reason']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    data['reason'] = reason;
    return data;
  }
}
