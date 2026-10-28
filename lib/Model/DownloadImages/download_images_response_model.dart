import 'package:icms_app/utils/json_values.dart';

class DownloadImagesListModel {
  List<DownloadImagesDataModel>? imagesList;

  DownloadImagesListModel({this.imagesList});

  DownloadImagesListModel.fromJsonList(List<dynamic> jsonList) {
    List<DownloadImagesDataModel> list = <DownloadImagesDataModel>[];
    for (var element in jsonList) {
      final map = readJsonMap(element, field: 'images');
      if (map == null) continue;
      list.add(DownloadImagesDataModel.fromJson(map));
    }
    imagesList = list;
  }

  List<Map<String, dynamic>> toJsonList() {
    final List<Map<String, dynamic>> data = <Map<String, dynamic>>[];
    for (var element in imagesList!) {
      data.add(element.toJson());
    }
    return data;
  }
}

class DownloadImagesDataModel {
  int? id;
  int? tenantId;
  String? filename;
  String? path;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  DownloadImagesDataModel({this.id, this.tenantId, this.filename, this.path, this.createdAt, this.updatedAt, this.imageUrl});

  DownloadImagesDataModel.fromJson(Map<String, dynamic> json) {
    id = readInt(json['id'], field: 'id');
    tenantId = readInt(json['tenant_id'], field: 'tenant_id');
    filename = readString(json['filename']);
    path = readString(json['path']);
    createdAt = readString(json['created_at']);
    updatedAt = readString(json['updated_at']);
    imageUrl = readString(json['image_url']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenant_id'] = tenantId;
    data['filename'] = filename;
    data['path'] = path;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}
