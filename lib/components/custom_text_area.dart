import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/theme_constants.dart';

class CustomTextArea extends StatelessWidget {
  final String? hintText;
  final bool isButtonEnable;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final FocusNode? node;
  final Function? validator, onFieldSubmit, onChange;
  final TextInputAction? inputAction;
  final bool readOnly;
  final Widget? suffixWidget, prefixWidget;
  final Function()? onTap;
  final VoidCallback? onPressedLeadingIcon;
  final String? labelText;
  final double padding;
  final double? borderRadius;
  final int maxLines;
  final double? height;
  final double? width;
  final String? initialValue;
  final Color? cursorColor, textAreaColor;

  const CustomTextArea(
      {super.key, this.validator,
      this.initialValue,
      this.cursorColor,
      this.textAreaColor,
      this.height,
      this.borderRadius,
      this.width,
      this.inputAction,
      this.isButtonEnable = false,
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
      this.maxLines = 10,
      this.padding = 0.0});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: width ?? size.width,
      height: height ?? 130.h,
      decoration:
          BoxDecoration(color: ColorConstants.searchbarBackground.withValues(alpha: 0.5), borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.black, fontSize: 13.sp),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.6), fontSize: 13.sp),
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: ColorConstants.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: ColorConstants.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: ColorConstants.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 30)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 30)),
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
          ),
          // isButtonEnable?Align(
          //   alignment: Alignment.bottomRight,
          //   child: Container(
          //       height: 40,
          //       width: 40,
          //       margin: EdgeInsets.only(right: 10,bottom: 10),
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //           gradient: GradientConstants.defaultCardGradient(),
          //           shape: BoxShape.circle
          //       ),
          //       child: InkWell(
          //           onTap: onTap,
          //           child: Icon(AppIcons.send,color: ColorConstants.white,size: 20,))
          //   ),
          // ):Container()
        ],
      ),
    );
  }
}
