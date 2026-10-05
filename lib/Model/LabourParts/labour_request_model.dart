import 'plr_labour_request_model.dart';

class LabourRequestModel {
  LabourRequestData? data;

  LabourRequestModel({this.data});

  LabourRequestModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? LabourRequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LabourRequestData {
  int? plrDemandLabour;
  int? agreedLabour;
  int? taxRate;
  int? taxAmount;
  int? grossAmount;
  List<PlrLabours>? labours;
  List<PlrLabours>? plrLabours;

  LabourRequestData(
      {this.plrDemandLabour, this.agreedLabour, this.taxRate, this.taxAmount, this.grossAmount, this.labours, this.plrLabours});

  LabourRequestData.fromJson(Map<String, dynamic> json) {
    plrDemandLabour = json['plr_demand_labour'];
    agreedLabour = json['agreed_labour'];
    taxRate = json['tax_rate'];
    taxAmount = json['tax_amount'];
    grossAmount = json['gross_amount'];
    if (json['labours'] != null) {
      labours = <PlrLabours>[];
      json['labours'].forEach((v) {
        labours!.add(PlrLabours.fromJson(v));
      });
    }
    if (json['plr_labours'] != null) {
      labours = <PlrLabours>[];
      json['plr_labours'].forEach((v) {
        labours!.add(PlrLabours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plr_demand_labour'] = plrDemandLabour;
    data['agreed_labour'] = agreedLabour;
    data['tax_rate'] = taxRate;
    data['tax_amount'] = taxAmount;
    data['gross_amount'] = grossAmount;
    if (labours != null) {
      data['labours'] = labours!.map((v) => v.toJson()).toList();
    }
    if (plrLabours != null) {
      data['plr_labours'] = plrLabours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
