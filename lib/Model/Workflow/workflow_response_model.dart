import 'package:icms_app/utils/json_values.dart';

class WorkflowResponseModel {
  WorkflowData? data;

  WorkflowResponseModel({this.data});

  WorkflowResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? WorkflowData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WorkflowData {
  int? isCustomer;
  int? isDriver;
  int? isFirstInspPics;
  int? isReInspPics;
  int? isLabor;
  int? isParts;
  int? isFirstInspDocs;
  int? isReInspDocs;
  int? isComments;
  int? isReInspComment;

  WorkflowData(
      {this.isCustomer,
      this.isDriver,
      this.isFirstInspPics,
      this.isReInspPics,
      this.isLabor,
      this.isParts,
      this.isFirstInspDocs,
      this.isReInspDocs,
      this.isComments,
      this.isReInspComment});

  WorkflowData.fromJson(Map<String, dynamic> json) {
    isCustomer = readInt(json['is_customer'], field: 'is_customer');
    isDriver = readInt(json['is_driver'], field: 'is_driver');
    isFirstInspPics = readInt(json['is_first_insp_pics'], field: 'is_first_insp_pics');
    isReInspPics = readInt(json['is_re_insp_pics'], field: 'is_re_insp_pics');
    isLabor = readInt(json['is_labor'], field: 'is_labor');
    isParts = readInt(json['is_parts'], field: 'is_parts');
    isFirstInspDocs = readInt(json['is_first_insp_docs'], field: 'is_first_insp_docs');
    isReInspDocs = readInt(json['is_re_insp_docs'], field: 'is_re_insp_docs');
    isComments = readInt(json['is_comments'], field: 'is_comments');
    isReInspComment = readInt(json['is_re_insp_comment'], field: 'is_re_insp_comment');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_customer'] = isCustomer;
    data['is_driver'] = isDriver;
    data['is_first_insp_pics'] = isFirstInspPics;
    data['is_re_insp_pics'] = isReInspPics;
    data['is_labor'] = isLabor;
    data['is_parts'] = isParts;
    data['is_first_insp_docs'] = isFirstInspDocs;
    data['is_re_insp_docs'] = isReInspDocs;
    data['is_comments'] = isComments;
    data['is_re_insp_comment'] = isReInspComment;
    return data;
  }
}
