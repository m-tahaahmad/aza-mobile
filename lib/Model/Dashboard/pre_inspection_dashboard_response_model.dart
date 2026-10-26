import 'package:icms_app/utils/json_values.dart';

class PreInspectionDashboardResponseModel {
  bool? success;
  PreInspectionData? data;
  Error? error;

  PreInspectionDashboardResponseModel({this.success, this.data, this.error});

  PreInspectionDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? PreInspectionData.fromJson(json['data']) : null;
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

class PreInspectionData {
  int? ack;
  int? insp;
  int? reports;

  PreInspectionData({this.ack, this.insp, this.reports});

  PreInspectionData.fromJson(Map<String, dynamic> json) {
    ack = readInt(json['new'], field: 'new');
    insp = readInt(json['insp'], field: 'insp');
    reports = readInt(json['reports'], field: 'reports');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new'] = ack;
    data['insp'] = insp;
    data['reports'] = reports;
    return data;
  }
}
