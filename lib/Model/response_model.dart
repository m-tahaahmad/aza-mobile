import 'error_model.dart';

class ResponseModel {
  bool? success;
  String? data;
  ErrorModel? error;

  ResponseModel({this.success, this.data, this.error});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    error = json['error'] != null ? ErrorModel.fromJson(json['error']) : null;
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
