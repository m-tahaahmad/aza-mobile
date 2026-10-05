import '../../Model/response_model.dart';

class ApiResponse<T> {
  Status status;
  T? responseData;
  String? message;

  ApiResponse.loading(this.message) : status = Status.loading;

  ApiResponse.completed(this.responseData) : status = Status.completed;

  ApiResponse.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $responseData";
  }
}

enum Status { loading, completed, error }

String apiResponseErrorMessage(
  ApiResponse<dynamic> value, {
  String fallback = 'Something went wrong',
}) {
  final responseData = value.responseData;
  if (responseData != null && responseData is ResponseModel) {
    return value.message ?? responseData.error?.message ?? fallback;
  }

  return value.message ?? fallback;
}
