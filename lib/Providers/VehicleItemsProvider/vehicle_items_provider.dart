import 'package:flutter/material.dart';

import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';

class VehiclePartDetail {
  final Part part;
  final String status;

  VehiclePartDetail(this.part, this.status);
}

class VehicleItemsProvider extends ChangeNotifier {
  List<VehiclePartDetail> vehicleParts = [];

  onCarPartTap(List<Part>? parts, String partName) {
    if (vehicleParts.indexWhere((element) => element.part.name!.trim().toLowerCase() == partName.toLowerCase()) == -1) {
      addIntoTable(
          part: parts!.where((element) => element.name!.trim().toLowerCase() == partName.toLowerCase()).first, status: "YES");
    } else {
      vehicleParts.removeWhere((element) => element.part.name!.trim().toLowerCase() == partName.toLowerCase());
    }
    notifyListeners();
  }

  addIntoTable({Part? part, String? status}) {
    vehicleParts.add(VehiclePartDetail(part!, status!));

    notifyListeners();
  }

  updateTableIndex(int index, {Part? part, String? status}) {
    vehicleParts[index] = VehiclePartDetail(part!, status!);
    notifyListeners();
  }

  bool checkPartID(String partName) {
    String isIDExist =
        vehicleParts.where((element) => element.part.name!.trim().toLowerCase() == partName.toLowerCase()).toString();
    return isIDExist.length != 2 ? true : false;
  }

  resetProvider() {
    vehicleParts.clear();
    notifyListeners();
  }
}
