class DownloadImagesListModel {
  List<DownloadImagesDataModel>? imagesList;

  DownloadImagesListModel({this.imagesList});

  DownloadImagesListModel.fromJsonList(List<dynamic> jsonList) {
    List<DownloadImagesDataModel> list = <DownloadImagesDataModel>[];
    for (var element in jsonList) {
      list.add(DownloadImagesDataModel.fromJson(element));
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
    id = json['id'];
    tenantId = json['tenant_id'];
    filename = json['filename'];
    path = json['path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
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
