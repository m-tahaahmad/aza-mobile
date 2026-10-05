class VehicleMakeResponseModel {
  bool? success;
  List<VehicleMakeData>? data;
  Error? error;

  VehicleMakeResponseModel({this.success, this.data, this.error});

  VehicleMakeResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <VehicleMakeData>[];
      json['data'].forEach((v) {
        data!.add(VehicleMakeData.fromJson(v));
      });
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
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
