import 'package:flutter/material.dart';
import 'package:icms_app/utils/json_values.dart';

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

  int _controllerGst() => readIntOrZero(gstController.text, field: 'gst');

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
    final safePrice = price ?? 0;
    final safeDepPercent = depPercent ?? 0;
    final safeDepPrice = depPrice ?? 0;
    final safeSalPercent = salPercent ?? 0;
    final safeSalPrice = salPrice ?? 0;
    if (calculate) {
      subTotal = calculateSubtotal(
          dep: safeDepPercent,
          depPrice: safeDepPrice,
          sal: safeSalPercent.toInt(),
          salPrice: safeSalPrice.toInt(),
          gst: _controllerGst(),
          price: safePrice,
          subtotal: 0);
    }
    final amounts = _depAndSalAmounts(
      price: safePrice,
      depPercent: safeDepPercent,
      depPrice: safeDepPrice,
      salPercent: safeSalPercent,
      salPrice: safeSalPrice,
    );
    partDetails.add(PartTableDetails(
      part,
      condition,
      safeDepPercent,
      amounts.$1,
      safeSalPercent,
      amounts.$2,
      gstPrice ?? 0,
      safePrice,
      subTotal ?? 0,
      sd,
    ));
    resetProvider();

    notifyListeners();
  }

  updateTableIndex(int index,
      {Part? part, condition, num? depPercent, num? depPrice, num? salPercent, num? salPrice, num? gstPrice, num? price, subTotal, int sd = 0}) {
    final safePrice = price ?? 0;
    final safeDepPercent = depPercent ?? 0;
    final safeDepPrice = depPrice ?? 0;
    final safeSalPercent = salPercent ?? 0;
    final safeSalPrice = salPrice ?? 0;
    final amounts = _depAndSalAmounts(
      price: safePrice,
      depPercent: safeDepPercent,
      depPrice: safeDepPrice,
      salPercent: safeSalPercent,
      salPrice: safeSalPrice,
    );
    partDetails[index] = PartTableDetails(
      part,
      condition,
      safeDepPercent,
      amounts.$1,
      safeSalPercent,
      amounts.$2,
      gstPrice ?? 0,
      safePrice,
      subTotal ?? 0,
      sd,
    );
    resetProvider();
    notifyListeners();
  }

  (int, int) _depAndSalAmounts({
    required num price,
    required num depPercent,
    required num depPrice,
    required num salPercent,
    required num salPrice,
  }) {
    final depAmount = depPercent != 0 ? (price * (depPercent / 100)).round() : depPrice;
    final salAmount = salPercent != 0 ? (price * (salPercent / 100)).round() : salPrice;
    return (depAmount.toInt(), salAmount.toInt());
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
    final safeDep = dep ?? 0;
    final depAmount = safeDep != 0 ? (partPrice * (safeDep / 100)).round() : depPrice;
    final partGst = ((partPrice - depAmount) * (gst / 100)).round().toInt();
    debugPrint("part GST:: $partGst");
    return partGst;
  }

  bool applyDep(String depValue) {
    final parsed = _requiredAmount(depValue, 'dep');
    if (parsed == null) return false;
    for (var element in partDetails) {
      final price = element.price ?? 0;
      element.dep = parsed;
      element.depPrice = (price * (parsed / 100)).round().toInt();
      element.subTotal = calculateSubtotal(
          dep: parsed,
          depPrice: element.depPrice,
          sal: element.sal,
          salPrice: element.salPrice,
          gst: _controllerGst(),
          price: price,
          subtotal: 0);
    }
    calculateAmount();
    calculateSDAmount();
    resetProvider();
    notifyListeners();
    return true;
  }

  bool applySalvage(String salValue) {
    final parsed = _requiredAmount(salValue, 'salvage');
    if (parsed == null) return false;
    for (var element in partDetails) {
      final price = element.price ?? 0;
      element.sal = parsed;
      element.salPrice = (price * (parsed / 100)).round().toInt();
      element.subTotal = calculateSubtotal(
          dep: element.dep,
          depPrice: element.depPrice,
          sal: parsed,
          salPrice: element.salPrice,
          gst: _controllerGst(),
          price: price,
          subtotal: 0);
    }
    calculateAmount();
    calculateSDAmount();
    resetProvider();
    notifyListeners();
    return true;
  }

  bool applyGst(String gstValue) {
    final parsed = _requiredAmount(gstValue, 'gst');
    if (parsed == null) return false;
    for (var element in partDetails) {
      final price = element.price ?? 0;
      element.gstPrice = calculatePartGst(price, element.dep, element.depPrice, parsed);
      element.subTotal = calculateSubtotal(
          dep: element.dep,
          depPrice: element.depPrice,
          sal: element.sal,
          salPrice: element.salPrice,
          gst: parsed,
          price: price,
          subtotal: 0);
    }
    calculateAmount();
    calculateSDAmount();
    notifyListeners();
    return true;
  }

  int? _requiredAmount(String value, String field) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    return readInt(trimmed, field: field);
  }

  int calculateSubtotal({num? dep, num? depPrice, num? sal, num? salPrice, required num gst, required num price, num? subtotal}) {
    debugPrint("dep = $dep, depPrice = $depPrice, sal = $sal, salPrice = $salPrice, gst = $gst, Price = $price, Subtotal = $subtotal");
    final safeDep = dep ?? 0;
    final safeSal = sal ?? 0;
    final depAmount = safeDep != 0 ? (price * (safeDep / 100)).round() : (depPrice ?? 0);
    final salAmount = safeSal != 0 ? (price * (safeSal / 100)).round() : (salPrice ?? 0);
    final gstAmount = ((price - depAmount) * (gst / 100)).round();
    subtotal = (price - depAmount) + gstAmount - salAmount;
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
      grossTotal = grossTotal + (element.price ?? 0);
      depreciationAmount = (depreciationAmount + element.depPrice).round().toInt();
      plrSalvage = plrSalvage + element.salPrice;
      debugPrint("EG:: ${element.gstPrice}");
      plrGst = plrGst + (element.gstPrice ?? 0);
      overallTotal = overallTotal + (element.subTotal ?? 0);
    }
    debugPrint("Gross:: $grossTotal");
    debugPrint("DEP:: $depreciationAmount");
    debugPrint("Sal:: $plrSalvage");
    debugPrint("plrGst:: $plrGst");
    partsTotal = grossTotal - depreciationAmount;
    debugPrint("GST:: ${gstController.text.trim()}");
    gstAmount = (partsTotal * (_controllerGst() / 100)).round().toInt();
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
      sdGrossTotal = sdGrossTotal + (element.price ?? 0);
      sdDepreciationAmount = (sdDepreciationAmount + element.depPrice).toInt();
      sdPlrSalvage = sdPlrSalvage + element.salPrice;
      debugPrint("EG:: ${element.gstPrice}");
      sdPlrGst = sdPlrGst + (element.gstPrice ?? 0);
      sdOverallTotal = sdOverallTotal + (element.subTotal ?? 0);
    }
    sdPartsLength = partDetails.where((element) => element.sd == 1).length;
    debugPrint("SD Length:: $sdPartsLength");
    debugPrint("SD Gross:: $sdGrossTotal");
    debugPrint("SD DEP:: $sdDepreciationAmount");
    debugPrint("SD Sal:: $sdPlrSalvage");
    debugPrint("SD plrGst:: $sdPlrGst");
    sdPartsTotal = sdGrossTotal - sdDepreciationAmount;
    debugPrint("SD GST:: ${gstController.text.trim()}");
    sdGstAmount = (sdPartsTotal * (_controllerGst() / 100)).round().toInt();
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
