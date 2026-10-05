class CustomerDetailRequestModel {
  CustomerRequestData? data;

  CustomerDetailRequestModel({this.data});

  CustomerDetailRequestModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? CustomerRequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CustomerRequestData {
  int? claimTypeId;
  UpdatePolicy? policy;
  UpdateWorkshop? workshop;

  CustomerRequestData({this.claimTypeId, this.policy, this.workshop});

  CustomerRequestData.fromJson(Map<String, dynamic> json) {
    claimTypeId = json['claim_type_id'];
    policy = json['policy'] != null ? UpdatePolicy.fromJson(json['policy']) : null;
    workshop = json['workshop'] != null ? UpdateWorkshop.fromJson(json['workshop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claim_type_id'] = claimTypeId;
    if (policy != null) {
      data['policy'] = policy!.toJson();
    }
    if (workshop != null) {
      data['workshop'] = workshop!.toJson();
    }
    return data;
  }
}

class UpdatePolicy {
  String? insuredName;
  String? insuredContact;

  UpdatePolicy({this.insuredName, this.insuredContact});

  UpdatePolicy.fromJson(Map<String, dynamic> json) {
    insuredName = json['insured_name'];
    insuredContact = json['insured_contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['insured_name'] = insuredName;
    data['insured_contact'] = insuredContact;
    return data;
  }
}

class UpdateWorkshop {
  int? workshopId;
  String? lossAmount;
  String? paymentBy;

  UpdateWorkshop({this.workshopId, this.lossAmount, this.paymentBy});

  UpdateWorkshop.fromJson(Map<String, dynamic> json) {
    workshopId = json['workshop_id'];
    lossAmount = json['loss_amount'];
    paymentBy = json['payment_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (workshopId != null) {
      data['workshop_id'] = workshopId;
    }
    data['loss_amount'] = lossAmount;
    data['payment_by'] = paymentBy;
    return data;
  }
}
