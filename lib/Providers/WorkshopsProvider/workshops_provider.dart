import 'package:flutter/material.dart';
import 'package:icms_app/Model/WorkshopsModel/all_workshops_model.dart';

class WorkshopsProvider extends ChangeNotifier {
  AllWorkshopsModel? _allWorkshopsModel;

  AllWorkshopsModel? get allWorkshopsModel => _allWorkshopsModel;

  set setAllWorkshops(AllWorkshopsModel responseModel) {
    _allWorkshopsModel = responseModel;
    notifyListeners();
  }
}
