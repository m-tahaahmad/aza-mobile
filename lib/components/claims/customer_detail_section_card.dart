import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class CustomerDetailSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const CustomerDetailSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: ColorConstants.secondaryColor.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.sp, color: ColorConstants.primaryColor),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: FontSizes.largeText,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

Widget customerDetailInfoRow({
  required String label,
  required String value,
  bool muted = false,
}) {
  final shown = value.isEmpty ? 'Not provided' : value;
  final isMuted = muted || shown.toLowerCase() == 'not provided';
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.normalText1,
              color: const Color(0xFF667085),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              shown,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: FontSizes.normalText1,
                color: isMuted ? const Color(0xFFB8C0CE) : const Color(0xFF1F2937),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget customerDetailDivider() {
  return Divider(height: 16.h, thickness: 1, color: const Color(0xFFEEF2F7));
}

Widget customerDetailPolicePill(String value) {
  final normalized = value.toUpperCase();
  final isYes = normalized == 'YES';
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
    decoration: BoxDecoration(
      color: isYes ? const Color(0xFFE2F4EA) : const Color(0xFFF4F6FB),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      isYes ? 'Yes' : 'No',
      style: TextStyle(
        fontSize: FontSizes.smallText,
        fontWeight: FontWeight.w700,
        color: isYes ? const Color(0xFF0A8F4C) : const Color(0xFF667085),
      ),
    ),
  );
}

BoxDecoration customerDetailInputDecoration() {
  return BoxDecoration(
    color: const Color(0xFFF4F6FB),
    borderRadius: BorderRadius.circular(12.r),
    border: Border.all(color: const Color(0xFFE4E9F2)),
  );
}

double customerDetailFieldHeight() => 44.h;

EdgeInsets get customerDetailFieldContentPadding =>
    EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h);

TextStyle customerDetailInputTextStyle() => TextStyle(
      fontSize: FontSizes.normalText1,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1F2937),
      height: 1.2,
    );

TextStyle customerDetailHintTextStyle() => TextStyle(
      fontSize: FontSizes.normalText1,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF98A2B3),
      height: 1.2,
    );

Widget customerDetailFieldLabel(String label) {
  return SizedBox(
    width: double.infinity,
    child: Text(
      label,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: FontSizes.normalText1,
        color: const Color(0xFF667085),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget customerDetailRequiredFieldLabel(String label) {
  return SizedBox(
    width: double.infinity,
    child: Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(
          fontSize: FontSizes.normalText1,
          color: const Color(0xFF667085),
          fontWeight: FontWeight.w600,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Color(0xFFE53935)),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    ),
  );
}

Widget customerDetailFieldHelperText(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 6.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: FontSizes.smallText,
        color: const Color(0xFF98A2B3),
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}


Widget customerDetailFieldGap() => SizedBox(height: 14.h);

InputBorder _customerDetailFieldBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(color: Color(0xFFE4E9F2)),
  );
}

InputDecoration customerDetailInputFieldDecoration({String? hintText}) {
  return InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF4F6FB),
    isDense: true,
    contentPadding: customerDetailFieldContentPadding,
    hintText: hintText,
    hintStyle: hintText != null ? customerDetailHintTextStyle() : null,
    border: _customerDetailFieldBorder(),
    enabledBorder: _customerDetailFieldBorder(),
    focusedBorder: _customerDetailFieldBorder(),
    disabledBorder: _customerDetailFieldBorder(),
    errorBorder: _customerDetailFieldBorder(),
    focusedErrorBorder: _customerDetailFieldBorder(),
  );
}

DropDownDecoratorProps customerDetailDropDownDecoratorProps({String? hintText}) {
  return DropDownDecoratorProps(
    decoration: customerDetailInputFieldDecoration(hintText: hintText),
    baseStyle: customerDetailInputTextStyle(),
    textAlign: TextAlign.left,
    textAlignVertical: TextAlignVertical.center,
  );
}

DropdownSuffixProps get customerDetailDropdownSuffixProps => DropdownSuffixProps(
      dropdownButtonProps: DropdownButtonProps(
        iconClosed: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 20.sp,
          color: const Color(0xFF98A2B3),
        ),
        iconOpened: Icon(
          Icons.keyboard_arrow_up_rounded,
          size: 20.sp,
          color: const Color(0xFF98A2B3),
        ),
        iconSize: 20.sp,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: 28.w, height: 28.h),
      ),
    );

Widget customerDetailSizedTextField({
  required TextEditingController controller,
  bool readOnly = false,
  TextInputType? keyboardType,
  String? hintText,
  VoidCallback? onTap,
}) {
  return SizedBox(
    height: customerDetailFieldHeight(),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      style: customerDetailInputTextStyle(),
      textAlignVertical: TextAlignVertical.center,
      decoration: customerDetailInputFieldDecoration(hintText: hintText),
    ),
  );
}

Widget customerDetailSizedSuffixTextField({
  required TextEditingController controller,
  required String suffixText,
  String? hintText,
  bool readOnly = false,
  TextInputType? keyboardType,
}) {
  return SizedBox(
    height: customerDetailFieldHeight(),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: customerDetailInputTextStyle(),
      textAlignVertical: TextAlignVertical.center,
      decoration: customerDetailInputFieldDecoration(hintText: hintText).copyWith(
        suffixText: ' $suffixText',
        suffixStyle: customerDetailHintTextStyle().copyWith(fontWeight: FontWeight.w700),
      ),
    ),
  );
}

Widget customerDetailSizedDateField({
  required TextEditingController controller,
  String hintText = 'YYYY-MM-DD',
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return SizedBox(
    height: customerDetailFieldHeight(),
    child: TextField(
      controller: controller,
      readOnly: true,
      onTap: readOnly ? null : onTap,
      style: customerDetailInputTextStyle(),
      textAlignVertical: TextAlignVertical.center,
      decoration: customerDetailInputFieldDecoration(hintText: hintText).copyWith(
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          size: 18.sp,
          color: const Color(0xFF98A2B3),
        ),
      ),
    ),
  );
}

Widget customerDetailSizedPkrTextField({
  required TextEditingController controller,
}) {
  return SizedBox(
    height: customerDetailFieldHeight(),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: customerDetailInputTextStyle(),
      textAlignVertical: TextAlignVertical.center,
      decoration: customerDetailInputFieldDecoration().copyWith(
        prefixText: 'PKR ',
        prefixStyle: customerDetailHintTextStyle().copyWith(fontWeight: FontWeight.w700),
      ),
    ),
  );
}

Widget customerDetailLabeledTextField({
  required String label,
  required TextEditingController controller,
  bool readOnly = false,
  TextInputType? keyboardType,
  String? hintText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customerDetailFieldLabel(label),
      SizedBox(height: 8.h),
      customerDetailSizedTextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        hintText: hintText,
      ),
    ],
  );
}

Widget customerDetailLabeledSuffixTextField({
  required String label,
  required TextEditingController controller,
  required String suffixText,
  String? hintText,
  bool readOnly = false,
  TextInputType? keyboardType,
  bool isRequired = false,
  String? helperText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      isRequired ? customerDetailRequiredFieldLabel(label) : customerDetailFieldLabel(label),
      SizedBox(height: 8.h),
      customerDetailSizedSuffixTextField(
        controller: controller,
        suffixText: suffixText,
        hintText: hintText,
        readOnly: readOnly,
        keyboardType: keyboardType,
      ),
      if (helperText != null) customerDetailFieldHelperText(helperText),
    ],
  );
}

Widget customerDetailLabeledDateField({
  required String label,
  required TextEditingController controller,
  bool readOnly = false,
  VoidCallback? onTap,
  String hintText = 'YYYY-MM-DD',
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customerDetailFieldLabel(label),
      SizedBox(height: 8.h),
      customerDetailSizedDateField(
        controller: controller,
        hintText: hintText,
        readOnly: readOnly,
        onTap: onTap,
      ),
    ],
  );
}

Widget customerDetailLabeledPkrTextField({
  required String label,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customerDetailFieldLabel(label),
      SizedBox(height: 8.h),
      customerDetailSizedPkrTextField(controller: controller),
    ],
  );
}

Widget customerDetailSizedDropdown({required Widget child}) {
  return SizedBox(
    height: customerDetailFieldHeight(),
    width: double.infinity,
    child: child,
  );
}
