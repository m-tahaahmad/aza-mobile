import 'package:flutter/material.dart';

import '../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../Model/LabourParts/labour_parts_response_model.dart';
import '../../screens/Claims/WorkFlow/PartsInvolves/parts_involves_ui.dart';

class PartsInvolveProvider extends ChangeNotifier {
  LabourPartsResponseModel? _partsResponseModel;

  LabourPartsResponseModel? get partsResponseModel => _partsResponseModel;

  set setAllParts(LabourPartsResponseModel responseModel) {
    _partsResponseModel = responseModel;
    notifyListeners();
  }

  void appendCatalogPart(Part part) {
    _partsResponseModel ??= LabourPartsResponseModel(success: true, data: []);
    final items = _partsResponseModel!.data ??= [];
    if (part.id != null && items.any((existing) => existing.id == part.id)) {
      return;
    }
    items.add(part);
    notifyListeners();
  }

  TextEditingController partNameController = TextEditingController();
  TextEditingController partPriceController = TextEditingController();
  TextEditingController partDepController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController salvageController = TextEditingController();
  List<PartTableDetails> partDetails = [];
  num grossTotal = 0;
  num sdGrossTotal = 0;
  num depreciationAmount = 0;
  num sdDepreciationAmount = 0;
  num plrSalvage = 0;
  num sdPlrSalvage = 0;
  num plrGst = 0;
  num sdPlrGst = 0;
  num partsTotal = 0;
  num sdPartsTotal = 0;
  num overallTotal = 0;
  num sdOverallTotal = 0;
  Part? selectedItem;
  num gstAmount = 0;
  num sdGstAmount = 0;
  int sdPartsLength = 0;

  addIntoTable(
      {Part? part,
      condition,
      num? depPercent,
      num? depPrice,
      num? salPercent,
      num? salPrice,
      num? gstPrice,
      num? price,
      subTotal,
      int sd = 0,
      bool calculate = false}) {
    if (calculate) {
      subTotal = calculateSubtotal(
          dep: depPercent,
          depPrice: depPrice,
          sal: salPercent!.toInt(),
          salPrice: salPrice!.toInt(),
          gst: gstController.text != "" ? int.parse(gstController.text.trim()) : 0,
          price: price!,
          subtotal: 0);
    }
    num? depAmount = 0;
    num? salAmount = 0;
    if (depPercent != 0) {
      depAmount = (price! * (depPercent! / 100)).round().toInt();
    } else {
      depAmount = depPrice;
    }
    if (salPercent != 0) {
      salAmount = (price! * (salPercent! / 100)).round().toInt();
      debugPrint("SAL AMOUNT:: $salAmount");
    } else {
      salAmount = salPrice;
    }
    partDetails.add(PartTableDetails(part, condition, depPercent, depAmount!.toInt(), salPercent, salAmount!.toInt(), gstPrice, price, subTotal, sd));
    resetProvider();

    notifyListeners();
  }

  updateTableIndex(int index,
      {Part? part, condition, num? depPercent, num? depPrice, num? salPercent, num? salPrice, num? gstPrice, num? price, subTotal, int sd = 0}) {
    num? depAmount = 0;
    num? salAmount = 0;
    if (depPercent != 0) {
      depAmount = (price! * (depPercent! / 100)).round().toInt();
    } else {
      depAmount = depPrice;
    }
    if (salPercent != 0) {
      salAmount = (price! * (salPercent! / 100)).round();
    } else {
      salAmount = salPrice;
    }
    partDetails[index] =
        PartTableDetails(part, condition, depPercent, depAmount!.toInt(), salPercent, salAmount!.toInt(), gstPrice, price, subTotal, sd);
    resetProvider();
    notifyListeners();
  }

  bool checkPartID(String partName) {
    String isIDExist = partDetails.where((element) => element.part!.name!.trim().toLowerCase() == partName.toLowerCase()).toString();
    return isIDExist.length != 2 ? true : false;
  }

  onCarPartTap(List<Part>? parts, String partName) {
    if (partDetails.indexWhere((element) => element.part!.name!.trim().toLowerCase() == partName.toLowerCase()) == -1) {
      addIntoTable(
          part: parts!.where((element) => element.name!.trim().toLowerCase() == partName.toLowerCase()).first,
          condition: null,
          depPercent: 0,
          depPrice: 0,
          salPercent: 0,
          salPrice: 0,
          gstPrice: 0,
          price: 0,
          subTotal: 0);
    } else {
      partDetails.removeWhere((element) => element.part!.name!.trim().toLowerCase() == partName.toLowerCase());
    }
    notifyListeners();
  }

  int calculatePartGst(num partPrice, num? dep, num depPrice, num gst) {
    num depAmount = 0;
    if (dep != 0) {
      depAmount = (partPrice * (dep! / 100)).round();
    } else {
      depAmount = depPrice;
    }
    int partGst = ((partPrice - depAmount) * (gst / 100)).round().toInt();
    debugPrint("part GST:: $partGst");
    return partGst;
  }

  applyDep(String depValue) {
    for (var element in partDetails) {
      element.dep = int.parse(depValue);
      var depAmount = (element.price! * (int.parse(depValue) / 100)).round();
      element.depPrice = depAmount.toInt();
      element.subTotal = calculateSubtotal(
          dep: int.parse(depValue),
          depPrice: element.depPrice,
          sal: element.sal,
          salPrice: element.salPrice,
          gst: gstController.text != "" ? int.parse(gstController.text.trim()) : 0,
          price: element.price!,
          subtotal: 0);
      // element.subTotal = element.price - depAmount.toInt();
    }
    calculateAmount();
    calculateSDAmount();
    resetProvider();
    notifyListeners();
  }

  applySalvage(String salValue) {
    for (var element in partDetails) {
      element.sal = int.parse(salValue);
      num salAmount = (element.price! * (int.parse(salValue) / 100)).round();
      element.salPrice = salAmount.toInt();
      element.subTotal = calculateSubtotal(
          dep: element.dep,
          depPrice: element.depPrice,
          sal: int.parse(salValue),
          salPrice: element.salPrice,
          gst: gstController.text != "" ? int.parse(gstController.text.trim()) : 0,
          price: element.price!,
          subtotal: 0);
      // element.subTotal = element.price - depAmount.toInt();
    }
    calculateAmount();
    calculateSDAmount();
    resetProvider();
    notifyListeners();
  }

  applyGst(String gstValue) {
    for (var element in partDetails) {
      element.gstPrice = calculatePartGst(element.price!, element.dep, element.depPrice, int.parse(gstValue));
      element.subTotal = calculateSubtotal(
          dep: element.dep,
          depPrice: element.depPrice,
          sal: element.sal,
          salPrice: element.salPrice,
          gst: int.parse(gstValue),
          price: element.price!,
          subtotal: 0);
      // element.subTotal = element.price - depAmount.toInt();
    }
    calculateAmount();
    calculateSDAmount();
    notifyListeners();
  }

  int calculateSubtotal({num? dep, num? depPrice, num? sal, num? salPrice, required num gst, required num price, num? subtotal}) {
    debugPrint("dep = $dep, depPrice = $depPrice, sal = $sal, salPrice = $salPrice, gst = $gst, Price = $price, Subtotal = $subtotal");
    num? depAmount;
    num? salAmount;
    num gstAmount;
    if (dep != 0) {
      depAmount = (price * (dep! / 100)).round();
    } else {
      depAmount = depPrice;
    }
    if (sal != 0) {
      salAmount = (price * (sal! / 100)).round();
    } else {
      salAmount = salPrice;
    }
    gstAmount = ((price - depAmount!) * (gst / 100)).round();

    subtotal = (price - depAmount) + gstAmount - salAmount!;
    debugPrint("SubTotal:: $subtotal");
    return subtotal.round().toInt();
  }

  calculateAmount() {
    grossTotal = 0;
    depreciationAmount = 0;
    plrSalvage = 0;
    plrGst = 0;
    partsTotal = 0;
    overallTotal = 0;
    debugPrint("Length:: ${partDetails.length}");
    for (var element in partDetails) {
      grossTotal = grossTotal + element.price!;
      depreciationAmount = (depreciationAmount + element.depPrice).round().toInt();
      plrSalvage = plrSalvage + element.salPrice;
      debugPrint("EG:: ${element.gstPrice}");
      plrGst = plrGst + element.gstPrice!;
      overallTotal = overallTotal + element.subTotal!;
    }
    debugPrint("Gross:: $grossTotal");
    debugPrint("DEP:: $depreciationAmount");
    debugPrint("Sal:: $plrSalvage");
    debugPrint("plrGst:: $plrGst");
    partsTotal = grossTotal - depreciationAmount;
    debugPrint("GST:: ${gstController.text.trim()}");
    gstAmount =
        gstController.text != "" ? (partsTotal * (int.parse(gstController.text.trim()) / 100)).round().toInt() : 0;
    debugPrint("GST Amount:: $gstAmount");
    calculateSDAmount();
    notifyListeners();
  }

  calculateSDAmount() {
    sdGrossTotal = 0;
    sdDepreciationAmount = 0;
    sdPlrSalvage = 0;
    sdPlrGst = 0;
    sdPartsTotal = 0;
    sdOverallTotal = 0;
    sdPartsLength = 0;
    debugPrint("Length:: ${partDetails.length}");
    for (var element in partDetails.where((element) => element.sd == 1)) {
      sdGrossTotal = sdGrossTotal + element.price!;
      sdDepreciationAmount = (sdDepreciationAmount + element.depPrice).toInt();
      sdPlrSalvage = sdPlrSalvage + element.salPrice;
      debugPrint("EG:: ${element.gstPrice}");
      sdPlrGst = sdPlrGst + element.gstPrice!;
      sdOverallTotal = sdOverallTotal + element.subTotal!;
    }
    sdPartsLength = partDetails.where((element) => element.sd == 1).length;
    debugPrint("SD Length:: $sdPartsLength");
    debugPrint("SD Gross:: $sdGrossTotal");
    debugPrint("SD DEP:: $sdDepreciationAmount");
    debugPrint("SD Sal:: $sdPlrSalvage");
    debugPrint("SD plrGst:: $sdPlrGst");
    sdPartsTotal = sdGrossTotal - sdDepreciationAmount;
    debugPrint("SD GST:: ${gstController.text.trim()}");
    sdGstAmount =
        gstController.text != "" ? (sdPartsTotal * (int.parse(gstController.text.trim()) / 100)).round().toInt() : 0;
    debugPrint("SD GST Amount:: $sdGstAmount");

    notifyListeners();
  }

  resetProvider({bool alsoGst = false, bool clearList = false}) {
    if (clearList) {
      partDetails.clear();
    }
    partDepController.text = "";
    partPriceController.text = "";
    salvageController.text = "";
    selectedItem = null;
    if (alsoGst) {
      gstController.text = "";
    }
    notifyListeners();
  }
}
