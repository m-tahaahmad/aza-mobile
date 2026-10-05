import 'package:flutter/material.dart';
import 'package:icms_app/Model/CommentsModel/comment_response_model.dart';
import 'package:icms_app/Model/CommentsModel/comments_request_model.dart';
import 'package:icms_app/constants/globals.dart';

import '../API/api.dart';
import '../API/api_response.dart';
import '../API/app_exceptions.dart';

class CommentsService {
  Future<ApiResponse<CommentResponseModel>> addComment(BuildContext context, String message) async {
    try {
      CommentRequestModel requestModel =
          CommentRequestModel(data: CommentsRequestData(claimId: claimId, userId: int.parse(userId!), message: message, sender: "mobile"));
      var response = await Api.postRequestData("comment", requestModel.toJson(), context, sendToken: true);
      CommentResponseModel responseModel = CommentResponseModel.fromJson(response);
      debugPrint("Media Upload Response: $response");
      return ApiResponse.completed(responseModel);
    } on AppException catch (e) {
      return ApiResponse.error(e.message);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
