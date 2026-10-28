import 'package:icms_app/utils/json_values.dart';

class ThirdPartyCDUpdateRequestModel {
  ThirdPartyUpdateData? data;

  ThirdPartyCDUpdateRequestModel({this.data});

  ThirdPartyCDUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    data = readJsonObject(json['data'], ThirdPartyUpdateData.fromJson, field: 'data');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ThirdPartyUpdateData {
  ThirdPartyUpdateDetail? thirdPartyDetail;

  ThirdPartyUpdateData({this.thirdPartyDetail});

  ThirdPartyUpdateData.fromJson(Map<String, dynamic> json) {
    thirdPartyDetail = readJsonObject(json['third_party_detail'], ThirdPartyUpdateDetail.fromJson, field: 'third_party_detail');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (thirdPartyDetail != null) {
      data['third_party_detail'] = thirdPartyDetail!.toJson();
    }
    return data;
  }
}

class ThirdPartyUpdateDetail {
  int? claimId;
  String? ownerName;
  String? ownerAddress;
  String? placeOfInspection;
  String? estimatedLoss;

  ThirdPartyUpdateDetail(
      {this.claimId,
        this.ownerName,
        this.ownerAddress,
        this.placeOfInspection,
        this.estimatedLoss});

  ThirdPartyUpdateDetail.fromJson(Map<String, dynamic> json) {
    claimId = json['claimId'];
    ownerName = json['owner_name'];
    ownerAddress = json['owner_address'];
    placeOfInspection = json['place_of_inspection'];
    estimatedLoss = json['estimated_loss'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claimId'] = claimId;
    data['owner_name'] = ownerName;
    data['owner_address'] = ownerAddress;
    data['place_of_inspection'] = placeOfInspection;
    data['estimated_loss'] = estimatedLoss;
    return data;
  }
}
