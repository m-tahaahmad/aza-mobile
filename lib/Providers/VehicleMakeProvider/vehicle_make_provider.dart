import 'package:flutter/material.dart';

import '../../Model/VehicleMakeModel/vehicle_make_response_model.dart';

class VehicleMakeProvider extends ChangeNotifier {
  VehicleMakeResponseModel? _vehicleMakeResponseModel;

  VehicleMakeResponseModel? get vehicleMakeResponseModel => _vehicleMakeResponseModel;

  set setVehicleMake(VehicleMakeResponseModel responseModel) {
    _vehicleMakeResponseModel = responseModel;
    notifyListeners();
  }
}