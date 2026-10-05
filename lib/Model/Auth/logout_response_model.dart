class LogoutResponseModel {
  bool? success;
  String? data;
  Error? error;

  LogoutResponseModel({this.success, this.data, this.error});

  LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['data'] = this.data;
    data['error'] = error;
    return data;
  }
}
