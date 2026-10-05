import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:provider/provider.dart';

import '../Providers/DialogProvider/dialog_provider.dart';
import '../Services/CustomerDetailServices/update_single_customer.dart';
import '../constants/theme_constants.dart';
import 'app_loader.dart';
import 'custom_snack_bar.dart';

class WithdrawDialog extends StatefulWidget {
  final String? title;
  final String? actionText1;
  final String? actionText2;
  final int? claimId;
  final bool fromWorkflow;
  final bool fromMedia;
  final Function? onTap, onTap2;

  const WithdrawDialog({
    super.key,
    this.claimId,
    this.fromWorkflow = false,
    this.fromMedia = false,
    this.onTap,
    this.title,
    this.actionText1,
    this.actionText2,
    this.onTap2,
  });

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  String get _dialogTitle {
    if (widget.fromMedia) return 'Delete picture?';
    return 'Withdraw claim?';
  }

  String get _dialogMessage {
    if (widget.title != null) return widget.title!;
    if (widget.fromMedia) return 'Are you sure you want to delete this picture?';
    return 'Are you sure you want to withdraw this claim?';
  }

  String get _primaryActionLabel =>
      widget.actionText1 ?? (widget.fromMedia ? 'Delete' : 'Withdraw');

  String get _secondaryActionLabel =>
      widget.actionText2 ?? (widget.fromMedia ? 'Cancel' : 'Back');

  void _handlePrimaryAction(DialogProvider dialogProvider) {
    if (widget.fromMedia) {
      (widget.onTap as void Function()?)?.call();
      return;
    }

    dialogProvider.setLoading = true;

    final body = {
      'data': {'surveyor_id': null, 'is_withdraw': 1}
    };

    UpdateSingleCustomer().updateCustomerDetail(context, widget.claimId, body).then((value) {
      if (!mounted) return;

      if (value.responseData?.data == 'success') {
        dialogProvider.setLoading = false;

        if (widget.fromWorkflow) {
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pop(true);
        } else {
          Navigator.of(context)
            ..pop()
            ..pop(true);
        }
      } else {
        dialogProvider.setLoading = false;
        showSnackBar(context, 'Something went wrong!!!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DialogProvider>(builder: (context, dialogProvider, child) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEEEEE),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  widget.fromMedia ? Icons.delete_outline : Icons.undo_outlined,
                  size: 26.sp,
                  color: const Color(0xFFD63838),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                _dialogTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: FontSizes.largeText,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                _dialogMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: FontSizes.normalText1,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF667085),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              if (dialogProvider.isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const AppLoader(),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: widget.onTap2 as void Function()? ??
                              () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: ColorConstants.secondaryColor.withValues(alpha: 0.5),
                            ),
                            backgroundColor: ColorConstants.secondaryColor.withValues(alpha: 0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            _secondaryActionLabel,
                            style: TextStyle(
                              color: ColorConstants.primaryColor,
                              fontSize: FontSizes.normalText2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () => _handlePrimaryAction(dialogProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD63838),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            _primaryActionLabel,
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
                ),
            ],
          ),
        ),
      );
    });
  }
}
