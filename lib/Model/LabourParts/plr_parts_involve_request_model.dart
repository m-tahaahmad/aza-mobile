import 'package:icms_app/utils/json_values.dart';

class PLRPartInvolveRequestModel {
  Data? data;

  PLRPartInvolveRequestModel({this.data});

  PLRPartInvolveRequestModel.fromJson(Map<String, dynamic> json) {
    data = readJsonObject(json['data'], Data.fromJson, field: 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? plrTotalParts;
  int? plrTotalGst;
  int? plrTotalDep;
  int? plrTotalSalvage;
  int? plrNetTotal;
  List<PlrPartRequestDetails>? plrPartDetails;

  Data({this.plrTotalParts, this.plrTotalGst, this.plrTotalDep, this.plrTotalSalvage, this.plrNetTotal, this.plrPartDetails});

  Data.fromJson(Map<String, dynamic> json) {
    plrTotalParts = json['plr_total_parts'];
    plrTotalGst = json['plr_total_gst'];
    plrTotalDep = json['plr_total_dep'];
    plrTotalSalvage = json['plr_total_salvage'];
    plrNetTotal = json['plr_net_total'];
    if (json['plr_part_details'] != null) {
      plrPartDetails = readJsonList(json['plr_part_details'], PlrPartRequestDetails.fromJson, field: 'plr_part_details');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plr_total_parts'] = plrTotalParts;
    data['plr_total_gst'] = plrTotalGst;
    data['plr_total_dep'] = plrTotalDep;
    data['plr_total_salvage'] = plrTotalSalvage;
    data['plr_net_total'] = plrNetTotal;
    if (plrPartDetails != null) {
      data['plr_part_details'] = plrPartDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlrPartRequestDetails {
  int? claimId;
  int? partId;
  String? rate;
  String? provider;
  String? gstPercentage;
  String? gst;
  String? salvagePercentage;
  String? salvage;
  String? depPercentage;
  String? dep;
  String? partNetAmount;
  String? partType;
  int? isSd;
  String? status;
  String? type;

  PlrPartRequestDetails(
      {this.claimId,
      this.partId,
      this.rate,
      this.provider,
      this.gstPercentage,
      this.gst,
      this.salvagePercentage,
      this.salvage,
      this.depPercentage,
      this.dep,
      this.partNetAmount,
      this.partType,
      this.isSd,
      this.status,
      this.type});

  PlrPartRequestDetails.fromJson(Map<String, dynamic> json) {
    claimId = json['claim_id'];
    partId = json['part_id'];
    rate = json['rate'];
    provider = json['provider'];
    gstPercentage = json['gst_percentage'];
    gst = json['gst'];
    salvagePercentage = json['salvage_percentage'];
    salvage = json['salvage'];
    depPercentage = json['dep_percentage'];
    dep = json['dep'];
    partNetAmount = json['part_net_amount'];
    partType = json['part_type'];
    isSd = json['is_sd'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claim_id'] = claimId;
    data['part_id'] = partId;
    data['rate'] = rate;
    data['provider'] = provider;
    data['gst_percentage'] = gstPercentage;
    data['gst'] = gst;
    data['salvage_percentage'] = salvagePercentage;
    data['salvage'] = salvage;
    data['dep_percentage'] = depPercentage;
    data['dep'] = dep;
    data['part_net_amount'] = partNetAmount;
    data['part_type'] = partType;
    data['is_sd'] = isSd;
    data['status'] = status;
    data['type'] = type;
    return data;
  }
}
