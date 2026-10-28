import 'plr_parts_involve_request_model.dart';
import 'package:icms_app/utils/json_values.dart';

class ThirdPartyPartsUpdateRequestModel {
  ThirdPartyPartsUpdateData? data;

  ThirdPartyPartsUpdateRequestModel({this.data});

  ThirdPartyPartsUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    data = readJsonObject(json['data'], ThirdPartyPartsUpdateData.fromJson, field: 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ThirdPartyPartsUpdateData {
  ThirdPartyPartsDetail? thirdPartyDetail;
  List<PlrPartRequestDetails>? thirdPartyParts;

  ThirdPartyPartsUpdateData({this.thirdPartyDetail, this.thirdPartyParts});

  ThirdPartyPartsUpdateData.fromJson(Map<String, dynamic> json) {
    thirdPartyDetail = readJsonObject(json['third_party_detail'], ThirdPartyPartsDetail.fromJson, field: 'third_party_detail');
    if (json['third_party_parts'] != null) {
      thirdPartyParts = readJsonList(json['third_party_parts'], PlrPartRequestDetails.fromJson, field: 'third_party_parts');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (thirdPartyDetail != null) {
      data['third_party_detail'] = thirdPartyDetail!.toJson();
    }
    if (thirdPartyParts != null) {
      data['third_party_parts'] =
          thirdPartyParts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ThirdPartyPartsDetail {
  int? claimId;
  int? totalParts;
  int? totalDep;
  int? totalSalvage;
  int? totalGst;
  int? netTotal;

  ThirdPartyPartsDetail(
      {this.claimId,
        this.totalParts,
        this.totalDep,
        this.totalSalvage,
        this.totalGst,
        this.netTotal});

  ThirdPartyPartsDetail.fromJson(Map<String, dynamic> json) {
    claimId = json['claim_id'];
    totalParts = json['total_parts'];
    totalDep = json['total_dep'];
    totalSalvage = json['total_salvage'];
    totalGst = json['total_gst'];
    netTotal = json['net_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claim_id'] = claimId;
    data['total_parts'] = totalParts;
    data['total_dep'] = totalDep;
    data['total_salvage'] = totalSalvage;
    data['total_gst'] = totalGst;
    data['net_total'] = netTotal;
    return data;
  }
}
