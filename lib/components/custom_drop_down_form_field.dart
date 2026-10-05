import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';
import '../constants/font_sizes.dart';

class CustomDropDownFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final List<dynamic>? items;
  final String? value;
  final Function(dynamic)? onChange;
  final String? Function(dynamic)? validator;
  final Widget? suffixWidget, prefixWidget;
  final Color? labelColor, borderColor;

  const CustomDropDownFormField({super.key, 
    this.validator,
    this.items,
    this.value,
    this.prefixWidget,
    this.hintText,
    this.labelText,
    this.onChange,
    this.suffixWidget,
    this.labelColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: suffixWidget,
      ),
      dropdownColor: ColorConstants.primaryColor,
      iconDisabledColor: Colors.grey,
      iconEnabledColor: ColorConstants.white,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        contentPadding: EdgeInsets.only(bottom: 0, top: 10),
        labelStyle: TextStyle(color: labelColor ?? ColorConstants.primaryColor, fontSize: FontSizes.normalText1),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? ColorConstants.primaryColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? ColorConstants.primaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? ColorConstants.primaryColor),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(color: Colors.red, height: 1.1, fontSize: FontSizes.normalText1),
      ),
      hint: Text(
        hintText!,
        style: TextStyle(fontSize: FontSizes.smallText, color: ColorConstants.white.withValues(alpha: 0.5)),
      ),
      items: items as List<DropdownMenuItem>?,
      initialValue: value,
      onChanged: onChange,
      validator: validator,
    );
  }
}
