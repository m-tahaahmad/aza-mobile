import '../CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/utils/json_values.dart';

class LabourPartsResponseModel {
  bool? success;
  List<Part>? data;
  Error? error;

  LabourPartsResponseModel({this.success, this.data, this.error});

  LabourPartsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = readJsonList(json['data'], Part.fromJson, field: 'data');
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    return data;
  }
}
