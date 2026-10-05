import 'package:flutter/cupertino.dart';
import 'package:icms_app/Model/LabourParts/labour_parts_response_model.dart';

import '../../Model/CustomersDataModel/customer_detail_response_model.dart';

class LabourPartsProvider extends ChangeNotifier {
  LabourPartsResponseModel? _labourPartsResponseModel;

  TextEditingController demandController = TextEditingController();
  TextEditingController settledController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  List<Part?> selectedParts = [];

  LabourPartsResponseModel? get labourPartsResponseModel => _labourPartsResponseModel;

  set setAllLabourParts(LabourPartsResponseModel responseModel) {
    _labourPartsResponseModel = responseModel;
    notifyListeners();
  }

  void appendCatalogPart(Part part) {
    _labourPartsResponseModel ??= LabourPartsResponseModel(success: true, data: []);
    final items = _labourPartsResponseModel!.data ??= [];
    if (part.id != null && items.any((existing) => existing.id == part.id)) {
      return;
    }
    items.add(part);
    notifyListeners();
  }

  bool checkPartID(String partName) {
    String isIDExist = selectedParts.where((element) => element!.name!.trim().toLowerCase() == partName.toLowerCase()).toString();
    return isIDExist.length != 2 ? true : false;
  }

  onCarPartTap(List<Part>? parts, String partName) {
    if (selectedParts.indexWhere((element) => element!.name!.trim().toLowerCase() == partName.toLowerCase()) == -1) {
      addSelectedPart(parts!.where((element) => element.name!.trim().toLowerCase() == partName.toLowerCase()).first);
    } else {
      selectedParts.removeWhere((element) => element!.name!.trim().toLowerCase() == partName.toLowerCase());
    }
    notifyListeners();
  }

  addSelectedPart(Part? value) {
    selectedParts.add(value);
    notifyListeners();
  }

  removeSelectedPart(Part? value) {
    selectedParts.removeWhere((element) => element!.name!.trim().toLowerCase() == value!.name!.trim().toLowerCase());
    notifyListeners();
  }

  // addPartIntoList(List<Part> partsData, String value) {
  //   if (selectedParts.indexWhere((element) => element!.name!.trim() == value) == -1) {
  //     addSelectedPart(partsData.where((element) => element.name!.trim() == value).first);
  //   } else {
  //     removeSelectedPart(partsData.where((element) => element.name!.trim() == value).first);
  //   }
  //   notifyListeners();
  // }

  resetProvider() {
    debugPrint("Resetting labour parts Provider");
    selectedParts.clear();
    demandController.clear();
    settledController.clear();
    taxController.clear();
    notifyListeners();
  }
}
