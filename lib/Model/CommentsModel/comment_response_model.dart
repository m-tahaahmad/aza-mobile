import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';

class CommentResponseModel {
  bool? success;
  Comments? data;
  Error? error;

  CommentResponseModel({this.success, this.data, this.error});

  CommentResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Comments.fromJson(json['data']) : null;
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
