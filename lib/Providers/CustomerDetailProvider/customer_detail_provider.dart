import 'package:flutter/material.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';

class CustomerDetailProvider extends ChangeNotifier {
  CustomerDetailResponseModel? _customerDetailResponseModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? selectedClaimType;
  String? selectedWorkShop;
  String? selectedPaymentType;
  int? selectedWorkshopId;
  String? selectedVehicleMake;
  int? selectedVehicleMakeId;
  TextEditingController locationController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController licenseNameController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController odometerController = TextEditingController();
  TextEditingController licenseExpiryController = TextEditingController();

  set setClaimType(value) {
    selectedClaimType = value;
    notifyListeners();
  }

  ///thirdParty
  TextEditingController addressController = TextEditingController();
  TextEditingController inspectionPlaceController = TextEditingController();
  TextEditingController estimatedLossController = TextEditingController();
  TextEditingController registrationNoController = TextEditingController();
  TextEditingController engineNoController = TextEditingController();
  TextEditingController chassisNoController = TextEditingController();
  TextEditingController horsePowerController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelYearController = TextEditingController();

  ///markAsImportant
  TextEditingController registrationDateController = TextEditingController();
  TextEditingController lossDateController = TextEditingController();
  TextEditingController totalMileageController = TextEditingController();
  TextEditingController insuredSinceController = TextEditingController();
  TextEditingController previousClaimsController = TextEditingController();

  ///PreInspection
  TextEditingController insuredPersonController = TextEditingController();
  TextEditingController insuredContactController = TextEditingController();

  CustomerDetailResponseModel? get customerDetailResponseModel => _customerDetailResponseModel;

  set setCustomerDetailResponseModel(CustomerDetailResponseModel responseModel) {
    _customerDetailResponseModel = responseModel;
    notifyListeners();
  }
}
