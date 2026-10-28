import 'plr_labour_request_model.dart';
import 'package:icms_app/utils/json_values.dart';

class ThirdPartyLaborUpdateRequestModel {
  ThirdPartyLaborUpdateData? data;

  ThirdPartyLaborUpdateRequestModel({this.data});

  ThirdPartyLaborUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    data = readJsonObject(json['data'], ThirdPartyLaborUpdateData.fromJson, field: 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ThirdPartyLaborUpdateData {
  ThirdPartyLaborDetail? thirdPartyDetail;
  List<PlrLabours>? thirdPartyLabours;

  ThirdPartyLaborUpdateData({this.thirdPartyDetail, this.thirdPartyLabours});

  ThirdPartyLaborUpdateData.fromJson(Map<String, dynamic> json) {
    thirdPartyDetail = readJsonObject(json['third_party_detail'], ThirdPartyLaborDetail.fromJson, field: 'third_party_detail');
    if (json['third_party_labours'] != null) {
      thirdPartyLabours = readJsonList(json['third_party_labours'], PlrLabours.fromJson, field: 'third_party_labours');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (thirdPartyDetail != null) {
      data['third_party_detail'] = thirdPartyDetail!.toJson();
    }
    if (thirdPartyLabours != null) {
      data['third_party_labours'] = thirdPartyLabours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ThirdPartyLaborDetail {
  int? claimId;
  int? agreedLabor;
  int? taxRate;
  int? taxAmount;
  int? grossAmount;

  ThirdPartyLaborDetail({this.claimId, this.agreedLabor, this.taxRate, this.taxAmount, this.grossAmount});

  ThirdPartyLaborDetail.fromJson(Map<String, dynamic> json) {
    claimId = json['claimId'];
    agreedLabor = json['agreed_labor'];
    taxRate = json['tax_rate'];
    taxAmount = json['tax_amount'];
    grossAmount = json['gross_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claimId'] = claimId;
    data['agreed_labor'] = agreedLabor;
    data['tax_rate'] = taxRate;
    data['tax_amount'] = taxAmount;
    data['gross_amount'] = grossAmount;
    return data;
  }
}
