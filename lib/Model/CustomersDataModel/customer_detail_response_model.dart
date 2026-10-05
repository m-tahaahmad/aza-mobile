import 'package:icms_app/Model/error_model.dart';

class CustomerDetailResponseModel {
  bool? success;
  CustomerDetailData? data;
  ErrorModel? error;

  CustomerDetailResponseModel({this.success, this.data, this.error});

  CustomerDetailResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? CustomerDetailData.fromJson(json['data']) : null;
    error = json['error'] != null ? ErrorModel.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class CustomerDetailData {
  int? id;
  int? employeeId;
  int? zoneId;
  dynamic intType;
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
  dynamic reInspSurveyorId;
  String? dateOfLoss;
  String? intimationDate;
  String? surveyDate;
  String? intimatedBy;
  String? intimatedAt;
  dynamic reportBy;
  dynamic reportAt;
  dynamic assignedBy;
  dynamic assignedAt;
  dynamic plrBy;
  dynamic plrAt;
  dynamic remarks;
  dynamic history;
  dynamic priority;
  String? status;
  dynamic agreedLabour;
  dynamic taxRate;
  dynamic taxAmount;
  dynamic grossAmount;
  dynamic plrAgreedLabour;
  dynamic plrDemandLabour;
  dynamic plrTaxRate;
  dynamic plrTaxAmount;
  dynamic plrGrossAmount;
  String? totalParts;
  String? totalGst;
  String? totalDep;
  String? totalSalvage;
  String? plrTotalParts;
  String? plrTotalGst;
  String? plrTotalDep;
  String? plrTotalSalvage;
  dynamic netTotal;
  String? plrNetTotal;
  dynamic circumstances;
  int? isChequeReceived;
  int? isSubmitted;
  int? isSettled;
  int? isReinspection;
  int? isReferredBack;
  int? docReceived;
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
  int? isWithdraw;
  dynamic invoiceNo;
  dynamic employee;
  String? insuredSince;
  String? previousClaims;
  Surveyor? surveyor;
  ClaimType? claimType;
  Policy? policy;
  WorkshopDetail? workshop;
  Vehicle? vehicle;
  List<Labours>? labours;
  List<PartDetails>? partDetails;
  List<PlrLabours>? plrLabours;
  List<PlrPartDetails>? plrPartDetails;
  dynamic coInsurance;
  List<ClaimImages>? inspectionImages;
  List<ClaimImages>? reInspectionImages;
  List<ClaimImages>? sdImages;
  List<ClaimImages>? preInspectionImages;
  List<DocumentImage>? docImages;
  dynamic approvalPic;
  dynamic policyFile;
  List<Comments>? comments;
  List<Documents>? documents;
  ThirdPartyDetail? thirdPartyDetail;
  List<ThirdPartyLabours>? thirdPartyLabours;
  List<ThirdPartyParts>? thirdPartyParts;
  VehicleMake? vehicleMake;
  Bill? bill;

  CustomerDetailData(
      {this.id,
      this.employeeId,
      this.zoneId,
      this.intType,
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
        this.agreedLabour,
        this.taxRate,
        this.taxAmount,
        this.grossAmount,
        this.plrAgreedLabour,
        this.plrDemandLabour,
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
        this.docReceived,
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
      this.isWithdraw,
      this.invoiceNo,
      this.employee,
      this.insuredSince,
      this.previousClaims,
      this.surveyor,
      this.claimType,
      this.policy,
      this.workshop,
      this.vehicle,
      this.labours,
      this.partDetails,
      this.plrLabours,
      this.plrPartDetails,
      this.coInsurance,
      this.inspectionImages,
      this.reInspectionImages,
      this.sdImages,
      this.preInspectionImages,
      this.docImages,
      this.approvalPic,
      this.policyFile,
      this.comments,
      this.documents,
      this.thirdPartyDetail,
      this.thirdPartyLabours,
      this.thirdPartyParts,
      this.vehicleMake,
      this.bill});

  CustomerDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    zoneId = json['zone_id'];
    intType = json['int_type'];
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
    agreedLabour = json['agreed_labour'];
    taxRate = json['tax_rate'];
    taxAmount = json['tax_amount'];
    grossAmount = json['gross_amount'];
    plrAgreedLabour = json['plr_agreed_labour'];
    plrDemandLabour = json['plr_demand_labour'];
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
    docReceived = json['doc_received'];
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
    isWithdraw = json['is_withdraw'];
    invoiceNo = json['invoice_no'];
    employee = json['employee'];
    insuredSince = json['insured_since'];
    previousClaims = json['previous_claims'];
    surveyor = json['surveyor'] != null ? Surveyor.fromJson(json['surveyor']) : null;
    claimType = json['claim_type'] != null ? ClaimType.fromJson(json['claim_type']) : null;
    policy = json['policy'] != null ? Policy.fromJson(json['policy']) : null;
    workshop = json['workshop'] != null ? WorkshopDetail.fromJson(json['workshop']) : null;
    vehicle =
    json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    if (json['labours'] != null) {
      labours = <Labours>[];
      json['labours'].forEach((v) {
        labours!.add(Labours.fromJson(v));
      });
    }
    if (json['part_details'] != null) {
      partDetails = <PartDetails>[];
      json['part_details'].forEach((v) {
        partDetails!.add(PartDetails.fromJson(v));
      });
    }
    if (json['plr_labours'] != null) {
      plrLabours = <PlrLabours>[];
      json['plr_labours'].forEach((v) {
        plrLabours!.add(PlrLabours.fromJson(v));
      });
    }
    if (json['plr_part_details'] != null) {
      plrPartDetails = <PlrPartDetails>[];
      json['plr_part_details'].forEach((v) {
        plrPartDetails!.add(PlrPartDetails.fromJson(v));
      });
    }
    if (json['inspection_images'] != null) {
      inspectionImages = <ClaimImages>[];
      json['inspection_images'].forEach((v) {
        inspectionImages!.add(ClaimImages.fromJson(v));
      });
    }
    if (json['re_inspection_images'] != null) {
      reInspectionImages = <ClaimImages>[];
      json['re_inspection_images'].forEach((v) {
        reInspectionImages!.add(ClaimImages.fromJson(v));
      });
    }
    if (json['sd_images'] != null) {
      sdImages = <ClaimImages>[];
      json['sd_images'].forEach((v) {
        sdImages!.add(ClaimImages.fromJson(v));
      });
    }
    if (json['pre_inspection_images'] != null) {
      preInspectionImages = <ClaimImages>[];
      json['pre_inspection_images'].forEach((v) {
        preInspectionImages!.add(ClaimImages.fromJson(v));
      });
    }
    if (json['doc_images'] != null) {
      docImages = <DocumentImage>[];
      json['doc_images'].forEach((v) {
        docImages!.add(DocumentImage.fromJson(v));
      });
    }
    approvalPic = json['approval_pic'];
    policyFile = json['policy_file'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    thirdPartyDetail = json['third_party_detail'] != null
        ? ThirdPartyDetail.fromJson(json['third_party_detail'])
        : null;
    if (json['third_party_labours'] != null) {
      thirdPartyLabours = <ThirdPartyLabours>[];
      json['third_party_labours'].forEach((v) {
        thirdPartyLabours!.add(ThirdPartyLabours.fromJson(v));
      });
    }
    if (json['third_party_parts'] != null) {
      thirdPartyParts = <ThirdPartyParts>[];
      json['third_party_parts'].forEach((v) {
        thirdPartyParts!.add(ThirdPartyParts.fromJson(v));
      });
    }
    vehicleMake = json['vehicle_make'] != null ? VehicleMake.fromJson(json['vehicle_make']) : null;
    bill = json['bill'] != null ? Bill.fromJson(json['bill']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['zone_id'] = zoneId;
    data['int_type'] = intType;
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
    data['agreed_labour'] = agreedLabour;
    data['tax_rate'] = taxRate;
    data['tax_amount'] = taxAmount;
    data['gross_amount'] = grossAmount;
    data['plr_agreed_labour'] = plrAgreedLabour;
    data['plr_demand_labour'] = plrDemandLabour;
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
    data['doc_received'] = docReceived;
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
    data['is_withdraw'] = isWithdraw;
    data['invoice_no'] = invoiceNo;
    data['employee'] = employee;
    data['insured_since'] = insuredSince;
    data['previous_claims'] = previousClaims;
    if (surveyor != null) {
      data['surveyor'] = surveyor!.toJson();
    }
    if (claimType != null) {
      data['claim_type'] = claimType!.toJson();
    }
    if (policy != null) {
      data['policy'] = policy!.toJson();
    }
    if (workshop != null) {
      data['workshop'] = workshop!.toJson();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (labours != null) {
      data['labours'] = labours!.map((v) => v.toJson()).toList();
    }
    if (partDetails != null) {
      data['part_details'] = partDetails!.map((v) => v.toJson()).toList();
    }
    if (plrLabours != null) {
      data['plr_labours'] = plrLabours!.map((v) => v.toJson()).toList();
    }
    if (plrPartDetails != null) {
      data['plr_part_details'] =
          plrPartDetails!.map((v) => v.toJson()).toList();
    }
    data['co_insurance'] = coInsurance;
    if (inspectionImages != null) {
      data['inspection_images'] = inspectionImages!.map((v) => v.toJson()).toList();
    }
    if (reInspectionImages != null) {
      data['re_inspection_images'] = reInspectionImages!.map((v) => v.toJson()).toList();
    }
    if (sdImages != null) {
      data['sd_images'] = sdImages!.map((v) => v.toJson()).toList();
    }
    if (preInspectionImages != null) {
      data['pre_inspection_images'] = preInspectionImages!.map((v) => v.toJson()).toList();
    }
    if (docImages != null) {
      data['doc_images'] = docImages!.map((v) => v.toJson()).toList();
    }
    data['approval_pic'] = approvalPic;
    data['policy_file'] = policyFile;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    if (thirdPartyDetail != null) {
      data['third_party_detail'] = thirdPartyDetail!.toJson();
    }
    if (thirdPartyLabours != null) {
      data['third_party_labours'] = thirdPartyLabours!.map((v) => v.toJson()).toList();
    }
    if (thirdPartyParts != null) {
      data['third_party_parts'] = thirdPartyParts!.map((v) => v.toJson()).toList();
    }
    if (vehicleMake != null) {
      data['vehicle_make'] = vehicleMake!.toJson();
    }
    if (bill != null) {
      data['bill'] = bill!.toJson();
    }
    return data;
  }
}

class Bill {
  int? claimId;
  dynamic professionalFee;
  dynamic noOfPhotos;
  dynamic perPhotoRate;
  dynamic totalPhoto;
  dynamic taxPercent;
  dynamic taxAmount;
  dynamic reInspFee;
  dynamic net;
  dynamic outstationFee;
  dynamic partsInspFee;
  dynamic customText;
  dynamic customValue;
  dynamic conveyanceFee;
  dynamic poaInspFee;
  dynamic underRepairInspFee;
  dynamic reportDate;
  int? isReportIssued;
  dynamic isOutstation;
  dynamic netTotal;
  dynamic remarks;
  int? isBillEditable;

  Bill({
    this.claimId,
    this.professionalFee,
    this.noOfPhotos,
    this.perPhotoRate,
    this.totalPhoto,
    this.taxPercent,
    this.taxAmount,
    this.reInspFee,
    this.net,
    this.outstationFee,
    this.partsInspFee,
    this.customText,
    this.customValue,
    this.conveyanceFee,
    this.poaInspFee,
    this.underRepairInspFee,
    this.reportDate,
    this.isReportIssued,
    this.isOutstation,
    this.netTotal,
    this.remarks,
    this.isBillEditable,
  });

  Bill.fromJson(Map<String, dynamic> json) {
    claimId = json['claim_id'];
    professionalFee = json['professional_fee'];
    noOfPhotos = json['no_of_photos'];
    perPhotoRate = json['per_photo_rate'];
    totalPhoto = json['total_photo'];
    taxPercent = json['tax_percent'];
    taxAmount = json['tax_amount'];
    reInspFee = json['re_insp_fee'];
    net = json['net'];
    outstationFee = json['outstation_fee'];
    partsInspFee = json['parts_insp_fee'];
    customText = json['custom_text'];
    customValue = json['custom_value'];
    conveyanceFee = json['conveyance_fee'];
    poaInspFee = json['poa_insp_fee'];
    underRepairInspFee = json['under_repair_insp_fee'];
    reportDate = json['report_date'];
    isReportIssued = json['is_report_issued'];
    isOutstation = json['is_outstation'];
    netTotal = json['net_total'];
    remarks = json['remarks'];
    isBillEditable = json['is_bill_editable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['claim_id'] = claimId;
    data['professional_fee'] = professionalFee;
    data['no_of_photos'] = noOfPhotos;
    data['per_photo_rate'] = perPhotoRate;
    data['total_photo'] = totalPhoto;
    data['tax_percent'] = taxPercent;
    data['tax_amount'] = taxAmount;
    data['re_insp_fee'] = reInspFee;
    data['net'] = net;
    data['outstation_fee'] = outstationFee;
    data['parts_insp_fee'] = partsInspFee;
    data['custom_text'] = customText;
    data['custom_value'] = customValue;
    data['conveyance_fee'] = conveyanceFee;
    data['poa_insp_fee'] = poaInspFee;
    data['under_repair_insp_fee'] = underRepairInspFee;
    data['report_date'] = reportDate;
    data['is_report_issued'] = isReportIssued;
    data['is_outstation'] = isOutstation;
    data['net_total'] = netTotal;
    data['remarks'] = remarks;
    data['is_bill_editable'] = isBillEditable;
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
  dynamic underInsuranceAmount;
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
  InsuranceCompany? insuranceCompany;
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
      this.underInsuranceAmount,
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
    underInsuranceAmount = json['under_insurance_amount'];
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
    insuranceCompany = json['insurance_company'] != null ? InsuranceCompany.fromJson(json['insurance_company']) : null;
    insuranceCompanyBranch =
        json['insurance_company_branch'] != null ? InsuranceCompanyBranch.fromJson(json['insurance_company_branch']) : null;
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
    data['under_insurance_percentage'] = underInsuranceAmount;
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

class Vehicle {
  int? id;
  int? claimId;
  String? engineNo;
  String? chassisNo;
  String? millage;
  String? horsePower;
  int? colorId;
  String? model;
  String? licenseName;
  String? licenseNo;
  String? licenseExpiry;
  dynamic policeStation;
  dynamic ciaSsp;
  dynamic firNo;
  dynamic firDate;
  dynamic motorReg;
  int? isFinal;
  dynamic marketValue;
  dynamic seatingCapacity;
  String? createdAt;
  String? updatedAt;

  Vehicle(
      {this.id,
      this.claimId,
      this.engineNo,
      this.chassisNo,
      this.millage,
      this.horsePower,
      this.colorId,
      this.model,
      this.licenseName,
      this.licenseNo,
      this.licenseExpiry,
      this.policeStation,
      this.ciaSsp,
      this.firNo,
      this.firDate,
      this.motorReg,
      this.isFinal,
      this.marketValue,
      this.seatingCapacity,
      this.createdAt,
      this.updatedAt});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    engineNo = json['engine_no'];
    chassisNo = json['chassis_no'];
    millage = json['millage'];
    horsePower = json['horse_power'];
    colorId = json['color_id'];
    model = json['model'];
    licenseName = json['license_name'];
    licenseNo = json['license_no'];
    licenseExpiry = json['license_expiry'];
    policeStation = json['police_station'];
    ciaSsp = json['cia_ssp'];
    firNo = json['fir_no'];
    firDate = json['fir_date'];
    motorReg = json['motor_reg'];
    isFinal = json['is_final'];
    marketValue = json['market_value'];
    seatingCapacity = json['seating_capacity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['engine_no'] = engineNo;
    data['chassis_no'] = chassisNo;
    data['millage'] = millage;
    data['horse_power'] = horsePower;
    data['color_id'] = colorId;
    data['model'] = model;
    data['license_name'] = licenseName;
    data['license_no'] = licenseNo;
    data['license_expiry'] = licenseExpiry;
    data['police_station'] = policeStation;
    data['cia_ssp'] = ciaSsp;
    data['fir_no'] = firNo;
    data['fir_date'] = firDate;
    data['motor_reg'] = motorReg;
    data['is_final'] = isFinal;
    data['market_value'] = marketValue;
    data['seating_capacity'] = seatingCapacity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Labours {
  int? id;
  int? claimId;
  int? partId;
  dynamic rate;
  String? type;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  Part? part;

  Labours({this.id, this.claimId, this.partId, this.rate, this.type, this.status, this.createdAt, this.updatedAt, this.part});

  Labours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    partId = json['part_id'];
    rate = json['rate'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    part = json['part'] != null ? Part.fromJson(json['part']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['part_id'] = partId;
    data['rate'] = rate;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (part != null) {
      data['part'] = part!.toJson();
    }
    return data;
  }
}

class PartDetails {
  int? id;
  int? claimId;
  int? partId;
  String? rate;
  dynamic provider;
  String? gstPercentage;
  String? gst;
  String? salvagePercentage;
  String? salvage;
  String? depPercentage;
  String? dep;
  String? partNetAmount;
  dynamic partType;
  int? isSd;
  String? type;
  dynamic status;
  dynamic remarks;
  String? createdAt;
  String? updatedAt;
  Part? part;

  PartDetails(
      {this.id,
      this.claimId,
      this.partId,
      this.rate,
      this.provider,
      this.gstPercentage,
      this.gst,
      this.salvagePercentage,
      this.salvage,
      this.depPercentage,
      this.dep,
      this.partNetAmount,
      this.partType,
      this.isSd,
      this.type,
      this.status,
      this.remarks,
      this.createdAt,
      this.updatedAt,
      this.part});

  PartDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    partId = json['part_id'];
    rate = json['rate'];
    provider = json['provider'];
    gstPercentage = json['gst_percentage'];
    gst = json['gst'];
    salvagePercentage = json['salvage_percentage'];
    salvage = json['salvage'];
    depPercentage = json['dep_percentage'];
    dep = json['dep'];
    partNetAmount = json['part_net_amount'];
    partType = json['part_type'];
    isSd = json['is_sd'];
    type = json['type'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    part = json['part'] != null ? Part.fromJson(json['part']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['part_id'] = partId;
    data['rate'] = rate;
    data['provider'] = provider;
    data['gst_percentage'] = gstPercentage;
    data['gst'] = gst;
    data['salvage_percentage'] = salvagePercentage;
    data['salvage'] = salvage;
    data['dep_percentage'] = depPercentage;
    data['dep'] = dep;
    data['part_net_amount'] = partNetAmount;
    data['part_type'] = partType;
    data['is_sd'] = isSd;
    data['type'] = type;
    data['status'] = status;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (part != null) {
      data['part'] = part!.toJson();
    }
    return data;
  }
}

class PlrPartDetails {
  int? id;
  int? claimId;
  int? partId;
  String? rate;
  String? provider;
  String? gstPercentage;
  String? gst;
  String? salvagePercentage;
  String? salvage;
  String? depPercentage;
  String? dep;
  String? partNetAmount;
  String? partType;
  int? isSd;
  String? type;
  dynamic status;
  dynamic remarks;
  String? createdAt;
  String? updatedAt;
  Part? part;

  PlrPartDetails(
      {this.id,
      this.claimId,
      this.partId,
      this.rate,
      this.provider,
      this.gstPercentage,
      this.gst,
      this.salvagePercentage,
      this.salvage,
      this.depPercentage,
      this.dep,
      this.partNetAmount,
      this.partType,
      this.isSd,
      this.type,
      this.status,
      this.remarks,
      this.createdAt,
      this.updatedAt,
      this.part});

  PlrPartDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    partId = json['part_id'];
    rate = json['rate'];
    provider = json['provider'];
    gstPercentage = json['gst_percentage'];
    gst = json['gst'];
    salvagePercentage = json['salvage_percentage'];
    salvage = json['salvage'];
    depPercentage = json['dep_percentage'];
    dep = json['dep'];
    partNetAmount = json['part_net_amount'];
    partType = json['part_type'];
    isSd = json['is_sd'];
    type = json['type'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    part = json['part'] != null ? Part.fromJson(json['part']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['part_id'] = partId;
    data['rate'] = rate;
    data['provider'] = provider;
    data['gst_percentage'] = gstPercentage;
    data['gst'] = gst;
    data['salvage_percentage'] = salvagePercentage;
    data['salvage'] = salvage;
    data['dep_percentage'] = depPercentage;
    data['dep'] = dep;
    data['part_net_amount'] = partNetAmount;
    data['part_type'] = partType;
    data['is_sd'] = isSd;
    data['type'] = type;
    data['status'] = status;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (part != null) {
      data['part'] = part!.toJson();
    }
    return data;
  }
}

class ThirdPartyParts {
  int? id;
  int? claimId;
  int? partId;
  String? rate;
  String? provider;
  String? gstPercentage;
  String? gst;
  String? salvagePercentage;
  String? salvage;
  String? depPercentage;
  String? dep;
  String? partNetAmount;
  String? partType;
  int? isSd;
  String? type;
  dynamic status;
  dynamic remarks;
  String? createdAt;
  String? updatedAt;
  Part? part;

  ThirdPartyParts(
      {this.id,
      this.claimId,
      this.partId,
      this.rate,
      this.provider,
      this.gstPercentage,
      this.gst,
      this.salvagePercentage,
      this.salvage,
      this.depPercentage,
      this.dep,
      this.partNetAmount,
      this.partType,
      this.isSd,
      this.type,
      this.status,
      this.remarks,
      this.createdAt,
      this.updatedAt,
      this.part});

  ThirdPartyParts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    partId = json['part_id'];
    rate = json['rate'];
    provider = json['provider'];
    gstPercentage = json['gst_percentage'];
    gst = json['gst'];
    salvagePercentage = json['salvage_percentage'];
    salvage = json['salvage'];
    depPercentage = json['dep_percentage'];
    dep = json['dep'];
    partNetAmount = json['part_net_amount'];
    partType = json['part_type'];
    isSd = json['is_sd'];
    type = json['type'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    part = json['part'] != null ? Part.fromJson(json['part']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['part_id'] = partId;
    data['rate'] = rate;
    data['provider'] = provider;
    data['gst_percentage'] = gstPercentage;
    data['gst'] = gst;
    data['salvage_percentage'] = salvagePercentage;
    data['salvage'] = salvage;
    data['dep_percentage'] = depPercentage;
    data['dep'] = dep;
    data['part_net_amount'] = partNetAmount;
    data['part_type'] = partType;
    data['is_sd'] = isSd;
    data['type'] = type;
    data['status'] = status;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (part != null) {
      data['part'] = part!.toJson();
    }
    return data;
  }
}

class PlrLabours {
  int? id;
  int? claimId;
  int? partId;
  dynamic rate;
  String? type;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  Part? part;

  PlrLabours({this.id, this.claimId, this.partId, this.rate, this.type, this.status, this.createdAt, this.updatedAt, this.part});

  PlrLabours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    partId = json['part_id'];
    rate = json['rate'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    part = json['part'] != null ? Part.fromJson(json['part']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['part_id'] = partId;
    data['rate'] = rate;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (part != null) {
      data['part'] = part!.toJson();
    }
    return data;
  }
}

class ThirdPartyLabours {
  int? id;
  int? claimId;
  int? partId;
  dynamic rate;
  String? type;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  Part? part;

  ThirdPartyLabours({this.id, this.claimId, this.partId, this.rate, this.type, this.status, this.createdAt, this.updatedAt, this.part});

  ThirdPartyLabours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    partId = json['part_id'];
    rate = json['rate'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    part = json['part'] != null ? Part.fromJson(json['part']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['part_id'] = partId;
    data['rate'] = rate;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (part != null) {
      data['part'] = part!.toJson();
    }
    return data;
  }
}

class Part {
  int? id;
  String? name;
  dynamic createdAt;
  dynamic updatedAt;

  Part({this.id, this.name, this.createdAt, this.updatedAt});

  Part.fromJson(Map<String, dynamic> json) {
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

class Workshop {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Workshop({this.id, this.name, this.createdAt, this.updatedAt});

  Workshop.fromJson(Map<String, dynamic> json) {
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

class InsuranceCompany {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  InsuranceCompany({this.id, this.name, this.createdAt, this.updatedAt});

  InsuranceCompany.fromJson(Map<String, dynamic> json) {
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

class ClaimImages {
  int? id;
  int? claimId;
  int? imageId;
  String? createdAt;
  String? updatedAt;
  ClaimImage? image;

  ClaimImages({this.id, this.claimId, this.imageId, this.createdAt, this.updatedAt, this.image});

  ClaimImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    imageId = json['image_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'] != null ? ClaimImage.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['image_id'] = imageId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class ClaimImage {
  int? id;
  String? filename;
  String? path;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  ClaimImage({this.id, this.filename, this.path, this.createdAt, this.updatedAt, this.imageUrl});

  ClaimImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
    path = json['path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['filename'] = filename;
    data['path'] = path;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}

class DocumentImage {
  int? id;
  int? claimId;
  int? imageId;
  int? documentId;
  String? type;
  String? createdAt;
  String? updatedAt;
  ClaimImage? image;

  DocumentImage({this.id, this.claimId, this.imageId, this.documentId, this.type, this.createdAt, this.updatedAt, this.image});

  DocumentImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    imageId = json['image_id'];
    documentId = json['document_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'] != null ? ClaimImage.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['image_id'] = imageId;
    data['document_id'] = documentId;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Comments {
  int? id;
  int? claimId;
  int? userId;
  String? message;
  String? sender;
  String? createdAt;
  String? updatedAt;
  User? user;

  Comments({this.id, this.claimId, this.userId, this.message, this.sender, this.createdAt, this.updatedAt, this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    userId = json['user_id'];
    message = json['message'];
    sender = json['sender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['user_id'] = userId;
    data['message'] = message;
    data['sender'] = sender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? userableType;
  int? userableId;
  int? roleId;
  int? zoneId;
  String? username;
  int? isLoggedIn;
  int? isLeader;
  String? createdAt;
  String? updatedAt;
  Surveyor? userable;

  User(
      {this.id,
      this.userableType,
      this.userableId,
      this.roleId,
      this.zoneId,
      this.username,
      this.isLoggedIn,
      this.isLeader,
      this.createdAt,
      this.updatedAt,
      this.userable});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userableType = json['userable_type'];
    userableId = json['userable_id'];
    roleId = json['role_id'];
    zoneId = json['zone_id'];
    username = json['username'];
    isLoggedIn = json['is_logged_in'];
    isLeader = json['is_leader'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userable = json['userable'] != null ? Surveyor.fromJson(json['userable']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userable_type'] = userableType;
    data['userable_id'] = userableId;
    data['role_id'] = roleId;
    data['zone_id'] = zoneId;
    data['username'] = username;
    data['is_logged_in'] = isLoggedIn;
    data['is_leader'] = isLeader;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (userable != null) {
      data['userable'] = userable!.toJson();
    }
    return data;
  }
}

class Surveyor {
  int? id;
  int? zoneId;
  String? fullName;
  String? phone;
  String? email;
  String? address;
  String? cnicNo;
  String? joiningDate;
  String? salary;
  String? createdAt;
  String? updatedAt;

  Surveyor(
      {this.id,
      this.zoneId,
      this.fullName,
      this.phone,
      this.email,
      this.address,
      this.cnicNo,
      this.joiningDate,
      this.salary,
      this.createdAt,
      this.updatedAt});

  Surveyor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneId = json['zone_id'];
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    cnicNo = json['cnic_no'];
    joiningDate = json['joining_date'];
    salary = json['salary'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['zone_id'] = zoneId;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['cnic_no'] = cnicNo;
    data['joining_date'] = joiningDate;
    data['salary'] = salary;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Documents {
  int? id;
  int? claimId;
  int? documentId;
  int? documentValue;
  String? createdAt;
  String? updatedAt;

  Documents({this.id, this.claimId, this.documentId, this.documentValue, this.createdAt, this.updatedAt});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    documentId = json['document_id'];
    documentValue = json['document_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['document_id'] = documentId;
    data['document_value'] = documentValue;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ThirdPartyDetail {
  int? id;
  int? claimId;
  String? ownerName;
  String? ownerAddress;
  String? placeOfInspection;
  String? estimatedLoss;
  String? regNo;
  String? engineNo;
  String? chassisNo;
  String? horsePower;
  int? makeId;
  String? model;
  String? driverName;
  String? licenseNo;
  String? licenseExpiry;
  String? agreedLabor;
  String? taxRate;
  String? taxAmount;
  String? grossAmount;
  String? totalParts;
  String? totalDep;
  String? totalSalvage;
  String? totalGst;
  String? netTotal;
  String? createdAt;
  String? updatedAt;

  ThirdPartyDetail(
      {this.id,
        this.claimId,
        this.ownerName,
        this.ownerAddress,
        this.placeOfInspection,
        this.estimatedLoss,
        this.regNo,
        this.engineNo,
        this.chassisNo,
        this.horsePower,
        this.makeId,
        this.model,
        this.driverName,
        this.licenseNo,
        this.licenseExpiry,
        this.agreedLabor,
        this.taxRate,
        this.taxAmount,
        this.grossAmount,
        this.totalParts,
        this.totalDep,
        this.totalSalvage,
        this.totalGst,
        this.netTotal,
        this.createdAt,
        this.updatedAt});

  ThirdPartyDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    ownerName = json['owner_name'];
    ownerAddress = json['owner_address'];
    placeOfInspection = json['place_of_inspection'];
    estimatedLoss = json['estimated_loss'];
    regNo = json['reg_no'];
    engineNo = json['engine_no'];
    chassisNo = json['chassis_no'];
    horsePower = json['horse_power'];
    makeId = json['make_id'];
    model = json['model'];
    driverName = json['driver_name'];
    licenseNo = json['license_no'];
    licenseExpiry = json['license_expiry'];
    agreedLabor = json['agreed_labor'];
    taxRate = json['tax_rate'];
    taxAmount = json['tax_amount'];
    grossAmount = json['gross_amount'];
    totalParts = json['total_parts'];
    totalDep = json['total_dep'];
    totalSalvage = json['total_salvage'];
    totalGst = json['total_gst'];
    netTotal = json['net_total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['claim_id'] = claimId;
    data['owner_name'] = ownerName;
    data['owner_address'] = ownerAddress;
    data['place_of_inspection'] = placeOfInspection;
    data['estimated_loss'] = estimatedLoss;
    data['reg_no'] = regNo;
    data['engine_no'] = engineNo;
    data['chassis_no'] = chassisNo;
    data['horse_power'] = horsePower;
    data['make_id'] = makeId;
    data['model'] = model;
    data['driver_name'] = driverName;
    data['license_no'] = licenseNo;
    data['license_expiry'] = licenseExpiry;
    data['agreed_labor'] = agreedLabor;
    data['tax_rate'] = taxRate;
    data['tax_amount'] = taxAmount;
    data['gross_amount'] = grossAmount;
    data['total_parts'] = totalParts;
    data['total_dep'] = totalDep;
    data['total_salvage'] = totalSalvage;
    data['total_gst'] = totalGst;
    data['net_total'] = netTotal;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class VehicleMake {
  int? id;
  int? tenantId;
  String? name;
  String? createdAt;
  String? updatedAt;

  VehicleMake({this.id, this.tenantId, this.name, this.createdAt, this.updatedAt});

  VehicleMake.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenant_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenant_id'] = tenantId;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
