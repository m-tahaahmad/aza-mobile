import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter/services.dart";
import '../constants/theme_constants.dart';
import '../constants/font_sizes.dart';
import '../constants/globals.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? obscureCharacter;
  final bool isEnable, isObscure;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final FocusNode? node;
  final String? Function(String?)? validator;
  final Function(String)? onChange;
  final Function? onFieldSubmit, onEditingComplete;
  final TextInputAction? inputAction;
  final bool readOnly;
  final Widget? suffixWidget, prefixWidget;
  final Function()? onTap;
  final VoidCallback? onPressedLeadingIcon;
  final String? labelText;
  final double padding;
  final int maxLines;
  final String? initialValue;
  final Color? cursorColor;
  final int? numberLength;
  final String? counterText;
  final TextCapitalization? textCapitalization;
  final Color? borderColor, textColor, labelColor, hintColor;
  final bool isDense;
  final double? fontSize;
  final bool isDriverDetails;
  final bool isLabor;
  final AutovalidateMode? autoValidateMode;

  const CustomTextFormField({
    super.key,
    this.validator,
    this.initialValue,
    this.cursorColor,
    this.numberLength,
    this.inputAction,
    this.isEnable = true,
    this.isObscure = false,
    this.obscureCharacter,
    this.onFieldSubmit,
    this.prefixWidget,
    this.hintText,
    this.inputType,
    this.controller,
    this.node,
    this.onChange,
    this.onTap,
    this.suffixWidget,
    this.readOnly = false,
    this.onPressedLeadingIcon,
    this.labelText,
    this.maxLines = 1,
    this.padding = 0.0,
    this.counterText,
    this.onEditingComplete,
    this.textCapitalization,
    this.borderColor,
    this.labelColor,
    this.hintColor,
    this.isDense = true,
    this.textColor,
    this.fontSize,
    this.isDriverDetails = false,
    this.autoValidateMode,
    this.isLabor = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autoValidateMode,
      style: TextStyle(fontSize: fontSize ?? 15, color: textColor ?? Colors.black),
      cursorColor: cursorColor ?? Colors.white,
      onTap: onTap,
      autofocus: false,
      enabled: isEnable,
      obscureText: isObscure,
      focusNode: node,
      onFieldSubmitted: onFieldSubmit as void Function(String)?,
      initialValue: initialValue,
      controller: controller,
      textInputAction: inputAction,
      keyboardType: inputType,
      inputFormatters: inputType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : [],
      maxLines: maxLines,
      readOnly: readOnly != false ? readOnly : checkReadOnly(),
      maxLength: numberLength,
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      onEditingComplete: onEditingComplete as void Function()?,
      decoration: InputDecoration(
          isDense: isDense,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          counterText: counterText,
          fillColor: ColorConstants.transparent,
          counterStyle: const TextStyle(color: ColorConstants.transparent),
          suffixIcon: suffixWidget,
          prefixIcon: prefixWidget,
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(color: labelColor ?? ColorConstants.primaryColor, fontSize: FontSizes.normalText1),
          hintStyle: TextStyle(color: hintColor ?? ColorConstants.primaryColor.withValues(alpha: 0.5), fontSize: FontSizes.normalText1),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: borderColor ?? ColorConstants.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? ColorConstants.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? ColorConstants.primaryColor),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 9.sp),
          errorMaxLines: 3,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignLabelWithHint: true,
          filled: true),
      validator: validator,
      onChanged: onChange,
      onSaved: (String? val) {
        controller!.text = val!;
      },
    );
  }

  bool checkReadOnly() {
    bool value = false;
    if (isDriverDetails &&
        (claimsType == "1st Inspection" || claimsType == "Re-Inspections Pending" || claimsType == "Rejected")) {
      value = false;
    } else if (isLabor &&
        !(claimsType == "Waiting for approval" || claimsType == "Docs Pending" || claimsType == "Reports Pending")) {
      value = false;
    } else if (claimsType == "Waiting for approval" ||
        claimsType == "Re-Inspections Pending" ||
        claimsType == "Docs Pending" ||
        claimsType == "Reports Pending") {
      value = true;
    }
    return value;
  }
}
