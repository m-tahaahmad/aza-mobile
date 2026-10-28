import 'package:icms_app/utils/json_values.dart';

class VehicleMakeResponseModel {
  bool? success;
  List<VehicleMakeData>? data;
  Error? error;

  VehicleMakeResponseModel({this.success, this.data, this.error});

  VehicleMakeResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = readJsonList(json['data'], VehicleMakeData.fromJson, field: 'data');
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

class VehicleMakeData {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  VehicleMakeData({this.id, this.name, this.createdAt, this.updatedAt});

  VehicleMakeData.fromJson(Map<String, dynamic> json) {
    id = readInt(json['id'], field: 'id');
    name = readString(json['name']);
    createdAt = readString(json['created_at']);
    updatedAt = readString(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
