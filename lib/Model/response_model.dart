import 'error_model.dart';
import 'package:icms_app/utils/json_values.dart';

class ResponseModel {
  bool? success;
  String? data;
  ErrorModel? error;

  ResponseModel({this.success, this.data, this.error});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = readString(json['data']);
    error = readJsonObject(json['error'], ErrorModel.fromJson, field: 'error');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['data'] = this.data;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}
