import 'plr_parts_involve_request_model.dart';
import 'package:icms_app/utils/json_values.dart';

class PartsInvolveRequestModel {
  DataPartsInvolve? data;

  PartsInvolveRequestModel({this.data});

  PartsInvolveRequestModel.fromJson(Map<String, dynamic> json) {
    data = readJsonObject(json['data'], DataPartsInvolve.fromJson, field: 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataPartsInvolve {
  int? totalParts;
  int? totalGst;
  int? totalDep;
  int? totalSalvage;
  int? netTotal;
  List<PlrPartRequestDetails>? partDetails;

  DataPartsInvolve({this.totalParts, this.totalGst, this.totalDep, this.totalSalvage, this.netTotal, this.partDetails});

  DataPartsInvolve.fromJson(Map<String, dynamic> json) {
    totalParts = json['total_parts'];
    totalGst = json['total_gst'];
    totalDep = json['total_dep'];
    totalSalvage = json['total_salvage'];
    netTotal = json['net_total'];
    if (json['part_details'] != null) {
      partDetails = readJsonList(json['part_details'], PlrPartRequestDetails.fromJson, field: 'part_details');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_parts'] = totalParts;
    data['total_gst'] = totalGst;
    data['total_dep'] = totalDep;
    data['total_salvage'] = totalSalvage;
    data['net_total'] = netTotal;
    if (partDetails != null) {
      data['part_details'] = partDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
