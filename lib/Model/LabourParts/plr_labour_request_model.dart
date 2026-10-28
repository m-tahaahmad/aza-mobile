import 'package:icms_app/utils/json_values.dart';

class PLRLabourRequestModel {
  PLRLabourRequestData? data;

  PLRLabourRequestModel({this.data});

  PLRLabourRequestModel.fromJson(Map<String, dynamic> json) {
    data = readJsonObject(json['data'], PLRLabourRequestData.fromJson, field: 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PLRLabourRequestData {
  int? plrAgreedLabour;
  int? plrDemandLabour;
  int? plrTaxRate;
  int? plrTaxAmount;
  int? plrGrossAmount;
  List<PlrLabours>? plrLabours;

  PLRLabourRequestData({this.plrAgreedLabour, this.plrDemandLabour, this.plrTaxRate, this.plrTaxAmount, this.plrGrossAmount, this.plrLabours});

  PLRLabourRequestData.fromJson(Map<String, dynamic> json) {
    plrAgreedLabour = json['plr_agreed_labour'];
    plrDemandLabour = json['plr_demand_labour'];
    plrTaxRate = json['plr_tax_rate'];
    plrTaxAmount = json['plr_tax_amount'];
    plrGrossAmount = json['plr_gross_amount'];
    if (json['plr_labours'] != null) {
      plrLabours = readJsonList(json['plr_labours'], PlrLabours.fromJson, field: 'plr_labours');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plr_agreed_labour'] = plrAgreedLabour;
    data['plr_demand_labour'] = plrDemandLabour;
    data['plr_tax_rate'] = plrTaxRate;
    data['plr_tax_amount'] = plrTaxAmount;
    data['plr_gross_amount'] = plrGrossAmount;
    if (plrLabours != null) {
      data['plr_labours'] = plrLabours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlrLabours {
  int? claimId;
  int? partId;
  String? rate;
  String? type;
  String? status;

  PlrLabours({this.claimId, this.partId, this.rate, this.type, this.status});

  PlrLabours.fromJson(Map<String, dynamic> json) {
    claimId = json['claim_id'];
    partId = json['part_id'];
    rate = json['rate'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claim_id'] = claimId;
    data['part_id'] = partId;
    data['rate'] = rate;
    data['type'] = type;
    data['status'] = status;
    return data;
  }
}
