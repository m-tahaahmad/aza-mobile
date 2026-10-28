import 'package:icms_app/utils/json_values.dart';

class AllWorkshopsModel {
  bool? success;
  List<WorkshopsData>? data;
  Error? error;

  AllWorkshopsModel({this.success, this.data, this.error});

  AllWorkshopsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = readJsonList(json['data'], WorkshopsData.fromJson, field: 'data');
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

class WorkshopsData {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  WorkshopsData({this.id, this.name, this.createdAt, this.updatedAt});

  WorkshopsData.fromJson(Map<String, dynamic> json) {
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
