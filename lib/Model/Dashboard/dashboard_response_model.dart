import 'package:icms_app/utils/json_values.dart';

class DashboardResponseModel {
  bool? success;
  DashboardData? data;
  Error? error;

  DashboardResponseModel({this.success, this.data, this.error});

  DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? DashboardData.fromJson(json['data']) : null;
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

class DashboardData {
  String? user;
  int? acknwldge;
  int? fInsp;
  int? approval;
  int? rejected;
  int? reInsp;
  int? finalStage;
  int? docs;
  int? reports;
  int? monthlyReports;

  DashboardData(
      {this.user,
      this.acknwldge,
      this.fInsp,
      this.approval,
      this.rejected,
      this.reInsp,
      this.finalStage,
      this.docs,
      this.reports,
      this.monthlyReports});

  DashboardData.fromJson(Map<String, dynamic> json) {
    user = readString(json['user']);
    acknwldge = readInt(json['new'], field: 'new');
    fInsp = readInt(json['f_insp'], field: 'f_insp');
    approval = readInt(json['approval'], field: 'approval');
    rejected = readInt(json['rejected'], field: 'rejected');
    reInsp = readInt(json['re_insp'], field: 're_insp');
    finalStage = readInt(json['final'], field: 'final');
    docs = readInt(json['docs'], field: 'docs');
    reports = readInt(json['reports'], field: 'reports');
    monthlyReports = readInt(json['monthly_reports'], field: 'monthly_reports');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['new'] = acknwldge;
    data['f_insp'] = fInsp;
    data['approval'] = approval;
    data['rejected'] = rejected;
    data['re_insp'] = reInsp;
    data['final'] = finalStage;
    data['docs'] = docs;
    data['reports'] = reports;
    data['monthly_reports'] = monthlyReports;
    return data;
  }
}

class Error {
  String? message;

  Error({this.message});

  Error.fromJson(Map<String, dynamic> json) {
    message = readString(json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}
