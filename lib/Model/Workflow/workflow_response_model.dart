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
    isCustomer = json['is_customer'];
    isDriver = json['is_driver'];
    isFirstInspPics = json['is_first_insp_pics'];
    isReInspPics = json['is_re_insp_pics'];
    isLabor = json['is_labor'];
    isParts = json['is_parts'];
    isFirstInspDocs = json['is_first_insp_docs'];
    isReInspDocs = json['is_re_insp_docs'];
    isComments = json['is_comments'];
    isReInspComment = json['is_re_insp_comment'];
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
