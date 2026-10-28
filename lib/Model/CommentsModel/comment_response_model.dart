import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/utils/json_values.dart';

class CommentResponseModel {
  bool? success;
  Comments? data;
  Error? error;

  CommentResponseModel({this.success, this.data, this.error});

  CommentResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = readJsonObject(json['data'], Comments.fromJson, field: 'data');
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = error;
    return data;
  }
}
