import 'package:flutter/material.dart';
import 'package:icms_app/Model/Dashboard/dashboard_response_model.dart';

import '../../Model/Dashboard/pre_inspection_dashboard_response_model.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardResponseModel? _dashboardResponseModel;
  PreInspectionDashboardResponseModel? _preInspectDashboardResponse;

  DashboardResponseModel? get dashboardResponseModel => _dashboardResponseModel;

  PreInspectionDashboardResponseModel? get preInspectDashboardResponse => _preInspectDashboardResponse;

  set setDashboardResponse(DashboardResponseModel responseModel) {
    _dashboardResponseModel = responseModel;
    notifyListeners();
  }

  set setPreInspectDashboardResponse(PreInspectionDashboardResponseModel responseModel) {
    _preInspectDashboardResponse = responseModel;
    notifyListeners();
  }
}
