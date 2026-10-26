import 'package:icms_app/utils/json_values.dart';

class DocumentResponseModel {
  bool? success;
  List<DocumentData>? data;
  Error? error;

  DocumentResponseModel({this.success, this.data, this.error});

  DocumentResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DocumentData>[];
      json['data'].forEach((v) {
        data!.add(DocumentData.fromJson(v));
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

class DocumentData {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  DocumentData({this.id, this.name, this.createdAt, this.updatedAt});

  DocumentData.fromJson(Map<String, dynamic> json) {
    id = _parseIntId(json['id']);
    name = readString(json['name']);
    createdAt = readString(json['created_at']);
    updatedAt = readString(json['updated_at']);
  }

  static int? _parseIntId(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
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
