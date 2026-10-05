import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class AuthTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmit;
  final void Function(String)? onChanged;
  final TextCapitalization textCapitalization;

  const AuthTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.isObscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType,
    this.inputAction,
    this.validator,
    this.onFieldSubmit,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
  });

  static const Color _fieldBackground = Color(0xFFF2F4F7);
  static const Color _labelColor = Color(0xFF1F2937);
  static const Color _hintColor = Color(0xFF9CA3AF);
  static const Color _iconColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: FontSizes.normalText1,
              fontWeight: FontWeight.w600,
              color: _labelColor,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          keyboardType: inputType,
          textInputAction: inputAction,
          textCapitalization: textCapitalization,
          cursorColor: ColorConstants.primaryColor,
          style: TextStyle(
            fontSize: FontSizes.normalText1,
            color: ColorConstants.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: FontSizes.normalText1,
              color: _hintColor,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: prefixIcon ??
                Icon(
                  Icons.person_outline,
                  color: _iconColor,
                  size: 18.sp,
                ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: _fieldBackground,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: ColorConstants.primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            errorStyle: TextStyle(
                fontSize: FontSizes.extraSmallText, color: Colors.red),
          ),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmit,
        ),
      ],
    );
  }
}
