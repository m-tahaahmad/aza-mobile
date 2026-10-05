import 'plr_labour_request_model.dart';

class ThirdPartyLaborUpdateRequestModel {
  ThirdPartyLaborUpdateData? data;

  ThirdPartyLaborUpdateRequestModel({this.data});

  ThirdPartyLaborUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ThirdPartyLaborUpdateData.fromJson(json['data']) : null;
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
    thirdPartyDetail = json['third_party_detail'] != null ? ThirdPartyLaborDetail.fromJson(json['third_party_detail']) : null;
    if (json['third_party_labours'] != null) {
      thirdPartyLabours = <PlrLabours>[];
      json['third_party_labours'].forEach((v) {
        thirdPartyLabours!.add(PlrLabours.fromJson(v));
      });
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
