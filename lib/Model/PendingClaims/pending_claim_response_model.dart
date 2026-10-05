import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';

class PendingClaimResponseModel {
  bool? success;
  List<PendingClaimData>? data;
  Error? error;

  PendingClaimResponseModel({this.success, this.data, this.error});

  PendingClaimResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <PendingClaimData>[];
      json['data'].forEach((v) {
        data!.add(PendingClaimData.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    return data;
  }
}

class PendingClaimData {
  int? id;
  int? employeeId;
  dynamic zoneId;
  String? intimationNo;
  dynamic intChannel;
  dynamic claimCity;
  String? lossNo;
  String? appNo;
  String? regNo;
  dynamic refNo;
  int? claimTypeId;
  int? makeId;
  int? surveyorId;
  int? reInspSurveyorId;
  String? dateOfLoss;
  String? intimationDate;
  dynamic surveyDate;
  String? intimatedBy;
  String? intimatedAt;
  dynamic reportBy;
  dynamic reportAt;
  dynamic assignedBy;
  dynamic assignedAt;
  String? plrBy;
  String? plrAt;
  dynamic remarks;
  dynamic history;
  dynamic priority;
  dynamic status;
  String? stageKey;
  bool? isOverdue;
  String? overdueColor;
  String? agreedLabour;
  String? taxRate;
  String? taxAmount;
  String? grossAmount;
  String? plrAgreedLabour;
  String? plrTaxRate;
  String? plrTaxAmount;
  String? plrGrossAmount;
  String? totalParts;
  String? totalGst;
  String? totalDep;
  String? totalSalvage;
  String? plrTotalParts;
  String? plrTotalGst;
  String? plrTotalDep;
  String? plrTotalSalvage;
  String? netTotal;
  String? plrNetTotal;
  dynamic circumstances;
  int? isChequeReceived;
  int? isSubmitted;
  int? isSettled;
  int? isReinspection;
  int? isReferredBack;
  ClaimType? claimType;
  int? isCustomer;
  int? isDriver;
  int? isFirstInspPics;
  int? isReInspPics;
  int? isLabor;
  int? isParts;
  int? isFirstInspDocs;
  int? isReInspDocs;
  int? isComments;
  int? isReInspComment;
  Policy? policy;
  WorkshopDetail? workshop;

  PendingClaimData(
      {this.id,
      this.employeeId,
      this.zoneId,
      this.intimationNo,
      this.intChannel,
      this.claimCity,
      this.lossNo,
      this.appNo,
      this.regNo,
      this.refNo,
      this.claimTypeId,
      this.makeId,
      this.surveyorId,
      this.reInspSurveyorId,
      this.dateOfLoss,
      this.intimationDate,
      this.surveyDate,
      this.intimatedBy,
      this.intimatedAt,
      this.reportBy,
      this.reportAt,
      this.assignedBy,
      this.assignedAt,
      this.plrBy,
      this.plrAt,
      this.remarks,
      this.history,
      this.priority,
      this.status,
      this.stageKey,
      this.isOverdue,
      this.overdueColor,
      this.agreedLabour,
      this.taxRate,
      this.taxAmount,
      this.grossAmount,
      this.plrAgreedLabour,
      this.plrTaxRate,
      this.plrTaxAmount,
      this.plrGrossAmount,
      this.totalParts,
      this.totalGst,
      this.totalDep,
      this.totalSalvage,
      this.plrTotalParts,
      this.plrTotalGst,
      this.plrTotalDep,
      this.plrTotalSalvage,
      this.netTotal,
      this.plrNetTotal,
      this.circumstances,
      this.isChequeReceived,
      this.isSubmitted,
      this.isSettled,
      this.isReinspection,
      this.isReferredBack,
      this.isCustomer,
      this.isDriver,
      this.isFirstInspPics,
      this.isReInspPics,
      this.isLabor,
      this.isParts,
      this.isFirstInspDocs,
      this.isReInspDocs,
      this.isComments,
      this.isReInspComment,
      this.claimType,
      this.policy,
      this.workshop});

  PendingClaimData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    zoneId = json['zone_id'];
    intimationNo = json['intimation_no'];
    intChannel = json['int_channel'];
    claimCity = json['claim_city'];
    lossNo = json['loss_no'];
    appNo = json['app_no'];
    regNo = json['reg_no'];
    refNo = json['ref_no'];
    claimTypeId = json['claim_type_id'];
    makeId = json['make_id'];
    surveyorId = json['surveyor_id'];
    reInspSurveyorId = json['re_insp_surveyor_id'];
    dateOfLoss = json['date_of_loss'];
    intimationDate = json['intimation_date'];
    surveyDate = json['survey_date'];
    intimatedBy = json['intimated_by'];
    intimatedAt = json['intimated_at'];
    reportBy = json['report_by'];
    reportAt = json['report_at'];
    assignedBy = json['assigned_by'];
    assignedAt = json['assigned_at'];
    plrBy = json['plr_by'];
    plrAt = json['plr_at'];
    remarks = json['remarks'];
    history = json['history'];
    priority = json['priority'];
    status = json['status'];
    stageKey = json['stage_key']?.toString();
    isOverdue = json['is_overdue'] == true || json['is_overdue'] == 1;
    overdueColor = json['overdue_color']?.toString();
    agreedLabour = json['agreed_labour'];
    taxRate = json['tax_rate'];
    taxAmount = json['tax_amount'];
    grossAmount = json['gross_amount'];
    plrAgreedLabour = json['plr_agreed_labour'];
    plrTaxRate = json['plr_tax_rate'];
    plrTaxAmount = json['plr_tax_amount'];
    plrGrossAmount = json['plr_gross_amount'];
    totalParts = json['total_parts'];
    totalGst = json['total_gst'];
    totalDep = json['total_dep'];
    totalSalvage = json['total_salvage'];
    plrTotalParts = json['plr_total_parts'];
    plrTotalGst = json['plr_total_gst'];
    plrTotalDep = json['plr_total_dep'];
    plrTotalSalvage = json['plr_total_salvage'];
    netTotal = json['net_total'];
    plrNetTotal = json['plr_net_total'];
    circumstances = json['circumstances'];
    isChequeReceived = json['is_cheque_received'];
    isSubmitted = json['is_submitted'];
    isSettled = json['is_settled'];
    isReinspection = json['is_reinspection'];
    isReferredBack = json['is_referred_back'];
    isCustomer = json['is_customer'];
    isDriver = json['is_driver'];
    isFirstInspPics = json['is_first_insp_pics'];
    isReInspPics = json['is_re_insp_pics'];
    isLabor = json['is_labor'];
    isParts = json['is_parts'];
    isFirstInspDocs = json['is_first_insp_docs'];
    isReInspDocs = json['is_re_insp_docs'];
    isComments = json['is_comments'];
    isReInspComment = json['is_re_insp_comment'];
    claimType = json['claim_type'] != null ? ClaimType.fromJson(json['claim_type']) : null;
    policy = json['policy'] != null ? Policy.fromJson(json['policy']) : null;
    workshop = json['workshop'] != null ? WorkshopDetail.fromJson(json['workshop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['zone_id'] = zoneId;
    data['intimation_no'] = intimationNo;
    data['int_channel'] = intChannel;
    data['claim_city'] = claimCity;
    data['loss_no'] = lossNo;
    data['app_no'] = appNo;
    data['reg_no'] = regNo;
    data['ref_no'] = refNo;
    data['claim_type_id'] = claimTypeId;
    data['make_id'] = makeId;
    data['surveyor_id'] = surveyorId;
    data['re_insp_surveyor_id'] = reInspSurveyorId;
    data['date_of_loss'] = dateOfLoss;
    data['intimation_date'] = intimationDate;
    data['survey_date'] = surveyDate;
    data['intimated_by'] = intimatedBy;
    data['intimated_at'] = intimatedAt;
    data['report_by'] = reportBy;
    data['report_at'] = reportAt;
    data['assigned_by'] = assignedBy;
    data['assigned_at'] = assignedAt;
    data['plr_by'] = plrBy;
    data['plr_at'] = plrAt;
    data['remarks'] = remarks;
    data['history'] = history;
    data['priority'] = priority;
    data['status'] = status;
    data['stage_key'] = stageKey;
    data['is_overdue'] = isOverdue;
    data['overdue_color'] = overdueColor;
    data['agreed_labour'] = agreedLabour;
    data['tax_rate'] = taxRate;
    data['tax_amount'] = taxAmount;
    data['gross_amount'] = grossAmount;
    data['plr_agreed_labour'] = plrAgreedLabour;
    data['plr_tax_rate'] = plrTaxRate;
    data['plr_tax_amount'] = plrTaxAmount;
    data['plr_gross_amount'] = plrGrossAmount;
    data['total_parts'] = totalParts;
    data['total_gst'] = totalGst;
    data['total_dep'] = totalDep;
    data['total_salvage'] = totalSalvage;
    data['plr_total_parts'] = plrTotalParts;
    data['plr_total_gst'] = plrTotalGst;
    data['plr_total_dep'] = plrTotalDep;
    data['plr_total_salvage'] = plrTotalSalvage;
    data['net_total'] = netTotal;
    data['plr_net_total'] = plrNetTotal;
    data['circumstances'] = circumstances;
    data['is_cheque_received'] = isChequeReceived;
    data['is_submitted'] = isSubmitted;
    data['is_settled'] = isSettled;
    data['is_reinspection'] = isReinspection;
    data['is_referred_back'] = isReferredBack;
    data['is_customer'] = isCustomer;
    data['is_driver'] = isDriver;
    data['is_first_insp_pics'] = isFirstInspPics;
    data['is_re_insp_pics'] = isReInspPics;
    data['is_labor'] = isLabor;
    data['is_parts'] = isParts;
    data['is_first_insp_docs'] = isFirstInspDocs;
    data['is_re_insp_docs'] = isReInspDocs;
    data['is_comments'] = isComments;
    data['is_re_insp_comment'] = isReInspComment;
    if (claimType != null) {
      data['claim_type'] = claimType!.toJson();
    }
    if (policy != null) {
      data['policy'] = policy!.toJson();
    }
    if (workshop != null) {
      data['workshop'] = workshop!.toJson();
    }
    return data;
  }
}

class ClaimType {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  ClaimType({this.id, this.name, this.createdAt, this.updatedAt});

  ClaimType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Policy {
  int? id;
  int? claimId;
  dynamic intPerson;
  int? insuranceCompanyId;
  int? insuranceCompanyBranchId;
  int? isWindow;
  String? policyNo;
  dynamic certificateNo;
  dynamic sumInsured;
  dynamic deductible;
  dynamic endrosmentNo;
  String? expiryDate;
  dynamic underInsuranceValue;
  dynamic underInsurancePercentage;
  dynamic excess;
  dynamic marketValue;
  String? insuredName;
  String? insuredCnic;
  String? insuredAddress;
  int? cityId;
  String? insuredContact;
  int? bankId;
  int? bankCityId;
  dynamic regNo;
  dynamic surveyDate;
  dynamic lossNo;
  String? createdAt;
  String? updatedAt;
  ClaimType? insuranceCompany;
  InsuranceCompanyBranch? insuranceCompanyBranch;

  Policy(
      {this.id,
      this.claimId,
      this.intPerson,
      this.insuranceCompanyId,
      this.insuranceCompanyBranchId,
      this.isWindow,
      this.policyNo,
      this.certificateNo,
      this.sumInsured,
      this.deductible,
      this.endrosmentNo,
      this.expiryDate,
      this.underInsuranceValue,
      this.underInsurancePercentage,
      this.excess,
      this.marketValue,
      this.insuredName,
      this.insuredCnic,
      this.insuredAddress,
      this.cityId,
      this.insuredContact,
      this.bankId,
      this.bankCityId,
      this.regNo,
      this.surveyDate,
      this.lossNo,
      this.createdAt,
      this.updatedAt,
      this.insuranceCompany,
      this.insuranceCompanyBranch});

  Policy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    intPerson = json['int_person'];
    insuranceCompanyId = json['insurance_company_id'];
    insuranceCompanyBranchId = json['insurance_company_branch_id'];
    isWindow = json['is_window'];
    policyNo = json['policy_no'];
    certificateNo = json['certificate_no'];
    sumInsured = json['sum_insured'];
    deductible = json['deductible'];
    endrosmentNo = json['endrosment_no'];
    expiryDate = json['expiry_date'];
    underInsuranceValue = json['under_insurance_value'];
    underInsurancePercentage = json['under_insurance_percentage'];
    excess = json['excess'];
    marketValue = json['market_value'];
    insuredName = json['insured_name'];
    insuredCnic = json['insured_cnic'];
    insuredAddress = json['insured_address'];
    cityId = json['city_id'];
    insuredContact = json['insured_contact'];
    bankId = json['bank_id'];
    bankCityId = json['bank_city_id'];
    regNo = json['reg_no'];
    surveyDate = json['survey_date'];
    lossNo = json['loss_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    insuranceCompany = json['insurance_company'] != null ? ClaimType.fromJson(json['insurance_company']) : null;
    insuranceCompanyBranch = json['insurance_company_branch'] != null ? InsuranceCompanyBranch.fromJson(json['insurance_company_branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['int_person'] = intPerson;
    data['insurance_company_id'] = insuranceCompanyId;
    data['insurance_company_branch_id'] = insuranceCompanyBranchId;
    data['is_window'] = isWindow;
    data['policy_no'] = policyNo;
    data['certificate_no'] = certificateNo;
    data['sum_insured'] = sumInsured;
    data['deductible'] = deductible;
    data['endrosment_no'] = endrosmentNo;
    data['expiry_date'] = expiryDate;
    data['under_insurance_value'] = underInsuranceValue;
    data['under_insurance_percentage'] = underInsurancePercentage;
    data['excess'] = excess;
    data['market_value'] = marketValue;
    data['insured_name'] = insuredName;
    data['insured_cnic'] = insuredCnic;
    data['insured_address'] = insuredAddress;
    data['city_id'] = cityId;
    data['insured_contact'] = insuredContact;
    data['bank_id'] = bankId;
    data['bank_city_id'] = bankCityId;
    data['reg_no'] = regNo;
    data['survey_date'] = surveyDate;
    data['loss_no'] = lossNo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (insuranceCompany != null) {
      data['insurance_company'] = insuranceCompany!.toJson();
    }
    if (insuranceCompanyBranch != null) {
      data['insurance_company_branch'] = insuranceCompanyBranch!.toJson();
    }
    return data;
  }
}

class InsuranceCompanyBranch {
  int? id;
  int? companyId;
  String? name;
  String? createdAt;
  String? updatedAt;

  InsuranceCompanyBranch({this.id, this.companyId, this.name, this.createdAt, this.updatedAt});

  InsuranceCompanyBranch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class WorkshopDetail {
  int? id;
  int? claimId;
  int? workshopId;
  String? placeOfSurvey;
  String? sameAsWorkshop;
  String? placeOfLoss;
  dynamic billNo;
  dynamic invoiceDate;
  String? lossAmount;
  dynamic lumpSumpAmount;
  dynamic estimateDate;
  dynamic settlementDate;
  dynamic reInspDate;
  dynamic docReceiveDate;
  dynamic paymentBy;
  int? isLabourSettled;
  dynamic remarks;
  String? createdAt;
  String? updatedAt;
  Workshop? workshop;

  WorkshopDetail(
      {this.id,
      this.claimId,
      this.workshopId,
      this.placeOfSurvey,
      this.sameAsWorkshop,
      this.placeOfLoss,
      this.billNo,
      this.invoiceDate,
      this.lossAmount,
      this.lumpSumpAmount,
      this.estimateDate,
      this.settlementDate,
      this.reInspDate,
      this.docReceiveDate,
      this.paymentBy,
      this.isLabourSettled,
      this.remarks,
      this.createdAt,
      this.updatedAt,
      this.workshop});

  WorkshopDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    workshopId = json['workshop_id'];
    placeOfSurvey = json['place_of_survey'];
    sameAsWorkshop = json['same_as_workshop'];
    placeOfLoss = json['place_of_loss'];
    billNo = json['bill_no'];
    invoiceDate = json['invoice_date'];
    lossAmount = json['loss_amount'];
    lumpSumpAmount = json['lump_sump_amount'];
    estimateDate = json['estimate_date'];
    settlementDate = json['settlement_date'];
    reInspDate = json['re_insp_date'];
    docReceiveDate = json['doc_receive_date'];
    paymentBy = json['payment_by'];
    isLabourSettled = json['is_labour_settled'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    workshop = json['workshop'] != null ? Workshop.fromJson(json['workshop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['workshop_id'] = workshopId;
    data['place_of_survey'] = placeOfSurvey;
    data['same_as_workshop'] = sameAsWorkshop;
    data['place_of_loss'] = placeOfLoss;
    data['bill_no'] = billNo;
    data['invoice_date'] = invoiceDate;
    data['loss_amount'] = lossAmount;
    data['lump_sump_amount'] = lumpSumpAmount;
    data['estimate_date'] = estimateDate;
    data['settlement_date'] = settlementDate;
    data['re_insp_date'] = reInspDate;
    data['doc_receive_date'] = docReceiveDate;
    data['payment_by'] = paymentBy;
    data['is_labour_settled'] = isLabourSettled;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (workshop != null) {
      data['workshop'] = workshop!.toJson();
    }
    return data;
  }
}
