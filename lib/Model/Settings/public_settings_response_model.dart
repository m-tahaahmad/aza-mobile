import 'package:icms_app/utils/json_values.dart';

class PublicSettingsResponseModel {
  bool? success;
  PublicSettingsData? data;
  dynamic error;

  PublicSettingsResponseModel({this.success, this.data, this.error});

  PublicSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = readJsonObject(json['data'], PublicSettingsData.fromJson, field: 'data');
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = error;
    return data;
  }
}

class PublicSettingsData {
  String? logoUrl;
  String? primaryColor;
  String? secondaryColor;
  String? claimDetailBgColor;
  String? organizationName;
  ClaimStageColors? claimStageColors;

  PublicSettingsData({
    this.logoUrl,
    this.primaryColor,
    this.secondaryColor,
    this.claimDetailBgColor,
    this.organizationName,
    this.claimStageColors,
  });

  PublicSettingsData.fromJson(Map<String, dynamic> json) {
    logoUrl = readString(json['logo_url']);
    primaryColor = readString(json['primary_color']);
    secondaryColor = readString(json['secondary_color']);
    claimDetailBgColor = readString(json['claim_detail_bg_color']);
    organizationName = readString(json['organization_name']);
    claimStageColors = readJsonObject(json['claim_stage_colors'], ClaimStageColors.fromJson, field: 'claim_stage_colors');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logo_url'] = logoUrl;
    data['primary_color'] = primaryColor;
    data['secondary_color'] = secondaryColor;
    data['claim_detail_bg_color'] = claimDetailBgColor;
    data['organization_name'] = organizationName;
    if (claimStageColors != null) {
      data['claim_stage_colors'] = claimStageColors!.toJson();
    }
    return data;
  }
}

class ClaimStageColors {
  List<ClaimStage>? stages;

  ClaimStageColors({this.stages});

  ClaimStageColors.fromJson(Map<String, dynamic> json) {
    if (json['stages'] != null) {
      stages = readJsonList(json['stages'], ClaimStage.fromJson, field: 'stages');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stages != null) {
      data['stages'] = stages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClaimStage {
  String? key;
  String? label;
  String? color;

  ClaimStage({this.key, this.label, this.color});

  ClaimStage.fromJson(Map<String, dynamic> json) {
    key = readString(json['key']);
    label = readString(json['label']);
    color = readString(json['color']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['color'] = color;
    return data;
  }
}
