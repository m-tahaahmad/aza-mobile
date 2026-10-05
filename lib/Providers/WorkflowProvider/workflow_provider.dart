import 'package:flutter/material.dart';
import 'package:icms_app/Model/Workflow/workflow_response_model.dart';
import 'package:icms_app/constants/globals.dart';

class WorkflowProvider extends ChangeNotifier {
  WorkflowResponseModel? _workflowResponseModel;

  WorkflowResponseModel? get workflowResponseModel => _workflowResponseModel;

  set setWorkflow(WorkflowResponseModel responseModel) {
    _workflowResponseModel = responseModel;
    notifyListeners();
  }

  // bool customerDetails = false;
  // bool driverDetails = false;
  // bool fInspPictures = false;
  // bool labour = false;
  // bool partsInvolved = false;
  // bool checkList = false;
  // bool comments = false;
  bool isAllDataSaved = false;

  // set setCustomerDetailsDone(bool value) {
  //   var data = workflowResponseModel?.data;
  //   customerDetails = value;
  //   if(data.isCustomer == 1){
  //     customerDetails = true;
  //   }
  //   notifyListeners();
  // }
  //
  // set setDriverDetailsDone(bool value) {
  //   driverDetails = value;
  //   notifyListeners();
  // }
  //
  // set setPicturesDone(bool value) {
  //   fInspPictures = value;
  //   notifyListeners();
  // }
  //
  // set setLabourDone(bool value) {
  //   labour = value;
  //   notifyListeners();
  // }
  //
  // set setPartsInvolvedDone(bool value) {
  //   partsInvolved = value;
  //   notifyListeners();
  // }

  bool checkAllData() {
    var data = workflowResponseModel?.data;
    if (claimsType == "Re-Inspections Pending" &&
        data!.isCustomer == 1 &&
        data.isDriver == 1 &&
        data.isReInspPics == 1 &&
        data.isLabor == 1 &&
        data.isParts == 1 &&
        data.isReInspDocs == 1 &&
        data.isReInspComment == 1) {
      isAllDataSaved = true;
      return isAllDataSaved;
    } else if ((claimsType == "1st Inspection" || claimsType == "Rejected") &&
        data!.isCustomer == 1 &&
        data.isDriver == 1 &&
        data.isFirstInspPics == 1 &&
        data.isLabor == 1 &&
        data.isParts == 1 &&
        data.isComments == 1) {
      isAllDataSaved = true;
      return isAllDataSaved;
    } else if (claimsType == "Docs Pending" &&
        data!.isCustomer == 1 &&
        data.isDriver == 1 &&
        data.isReInspPics == 1 &&
        data.isLabor == 1 &&
        data.isParts == 1 &&
        data.isReInspDocs == 1 &&
        data.isComments == 1) {
      isAllDataSaved = true;
      return isAllDataSaved;
    } else if (claimsType == "pre" &&
        data!.isCustomer == 1 &&
        data.isLabor == 1 &&
        data.isParts == 1 &&
        data.isFirstInspPics == 1) {
      isAllDataSaved = true;
      return isAllDataSaved;
    } else {
      return false;
    }
  }
}
