import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:provider/provider.dart';

import '../../../../HelperFunctions/helper_functions.dart';
import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../components/comments/comments_helpers.dart';
import '../../../../components/custom_snack_bar.dart';

class MarkImportantDialogUI extends StatefulWidget {
  final int? id;
  final String? lossDate;
  final String? totalMileage;
  final String? insuredSince;
  final String? previousClaims;

  const MarkImportantDialogUI({
    super.key,
    this.lossDate,
    this.totalMileage,
    this.id,
    this.insuredSince,
    this.previousClaims,
  });

  @override
  State<MarkImportantDialogUI> createState() => _MarkImportantDialogUIState();
}

class _MarkImportantDialogUIState extends State<MarkImportantDialogUI> {
  late CustomerDetailProvider customerDetailProvider;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    customerDetailProvider.lossDateController.text = widget.lossDate ?? '';
    customerDetailProvider.totalMileageController.text = widget.totalMileage ?? '';
    customerDetailProvider.insuredSinceController.text = widget.insuredSince ?? '';
    customerDetailProvider.previousClaimsController.text = widget.previousClaims ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
              child: CustomerDetailSectionCard(
                title: 'Important claim details',
                icon: Icons.flag_outlined,
                child: Column(
                  children: [
                    customerDetailLabeledDateField(
                      label: 'Reg. Date',
                      controller: customerDetailProvider.registrationDateController,
                      onTap: () {
                        HelperFunctions().selectDate(context, selectedDate, (date) {
                          customerDetailProvider.registrationDateController.text = date;
                        });
                      },
                    ),
                    customerDetailFieldGap(),
                    customerDetailLabeledDateField(
                      label: 'Loss Date',
                      controller: customerDetailProvider.lossDateController,
                      onTap: () {
                        HelperFunctions().selectDate(context, selectedDate, (date) {
                          customerDetailProvider.lossDateController.text = date;
                        });
                      },
                    ),
                    customerDetailFieldGap(),
                    customerDetailLabeledTextField(
                      label: 'Total Mileage',
                      controller: customerDetailProvider.totalMileageController,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter mileage',
                    ),
                    customerDetailFieldGap(),
                    customerDetailLabeledTextField(
                      label: 'Insured Since',
                      controller: customerDetailProvider.insuredSinceController,
                      hintText: 'Enter insured since',
                    ),
                    customerDetailFieldGap(),
                    customerDetailLabeledTextField(
                      label: 'Previous Claims',
                      controller: customerDetailProvider.previousClaimsController,
                      hintText: 'Enter previous claims',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: const Color(0xFFF3F5F9),
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: isLoading
                  ? const Center(child: AppLoader())
                  : ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Submit as important',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: FontSizes.normalText2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ),
        ],
    );
  }

  Future<void> _handleSubmit() async {
    final regDate = customerDetailProvider.registrationDateController.text.trim();
    final lossDate = customerDetailProvider.lossDateController.text.trim();
    final mileage = customerDetailProvider.totalMileageController.text.trim();
    final insuredSince = customerDetailProvider.insuredSinceController.text.trim();
    final previousClaims = customerDetailProvider.previousClaimsController.text.trim();

    if (regDate.isEmpty || lossDate.isEmpty || mileage.isEmpty || insuredSince.isEmpty || previousClaims.isEmpty) {
      showSnackBar(context, 'Please fill all required fields');
      return;
    }

    setState(() => isLoading = true);

    final commentResponse = await CustomerDetailService().getCustomerDetail(context, widget.id);
    if (!mounted) return;

    final comments = commentResponse?.responseData?.data?.comments ?? [];
    if (!hasRequiredMobileComment(comments)) {
      setState(() => isLoading = false);
      showSnackBar(context, 'Add a comment before submitting');
      return;
    }

    final body = {
      'data': {
        'is_submitted': 1,
        'is_referred_back': 0,
        'date_of_loss': lossDate,
        'is_important': 1,
        'insured_since': insuredSince,
        'previous_claims': previousClaims,
        'vehicle': {
          'reg_date': regDate,
          'millage': mileage,
        },
      },
    };

    UpdateSingleCustomer().updateCustomerDetail(context, widget.id, body).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() => isLoading = false);
        showSnackBar(context, 'Submitted Successfully');
        Navigator.of(context)
          ..pop()
          ..pop()
          ..pop(true);
      } else {
        setState(() => isLoading = false);
        showSnackBar(context, apiResponseErrorMessage(value));
      }
    });
  }
}
