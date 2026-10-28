import 'package:icms_app/utils/json_values.dart';

class CommentRequestModel {
  CommentsRequestData? data;

  CommentRequestModel({this.data});

  CommentRequestModel.fromJson(Map<String, dynamic> json) {
    data = readJsonObject(json['data'], CommentsRequestData.fromJson, field: 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CommentsRequestData {
  int? claimId;
  int? userId;
  String? message;
  String? sender;

  CommentsRequestData({this.claimId, this.userId, this.message, this.sender});

  CommentsRequestData.fromJson(Map<String, dynamic> json) {
    claimId = json['claimId'];
    userId = json['userId'];
    message = json['message'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claimId'] = claimId;
    data['userId'] = userId;
    data['message'] = message;
    data['sender'] = sender;
    return data;
  }
}
