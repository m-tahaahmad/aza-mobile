class PublicSettingsResponseModel {
  bool? success;
  PublicSettingsData? data;
  dynamic error;

  PublicSettingsResponseModel({this.success, this.data, this.error});

  PublicSettingsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? PublicSettingsData.fromJson(json['data']) : null;
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
    logoUrl = json['logo_url'];
    primaryColor = json['primary_color'];
    secondaryColor = json['secondary_color'];
    claimDetailBgColor = json['claim_detail_bg_color'];
    organizationName = json['organization_name'];
    claimStageColors = json['claim_stage_colors'] != null
        ? ClaimStageColors.fromJson(json['claim_stage_colors'])
        : null;
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
      stages = <ClaimStage>[];
      json['stages'].forEach((v) {
        stages!.add(ClaimStage.fromJson(v));
      });
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
    key = json['key'];
    label = json['label'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['color'] = color;
    return data;
  }
}
