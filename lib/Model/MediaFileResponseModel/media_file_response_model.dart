import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';

class MediaFileResponseModel {
  bool? success;
  ClaimImage? data;
  Error? error;

  MediaFileResponseModel({this.success, this.data, this.error});

  MediaFileResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    final rawData = json['data'];
    if (rawData is List && rawData.isNotEmpty) {
      data = ClaimImage.fromJson(rawData.first as Map<String, dynamic>);
    } else if (rawData is Map<String, dynamic>) {
      data = ClaimImage.fromJson(rawData);
    } else {
      data = null;
    }
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
