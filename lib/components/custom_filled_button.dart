import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/theme_constants.dart';

class CustomFilledButton extends StatelessWidget {
  final String? title;
  final Gradient? buttonGradients;
  final double? width;
  final double? height;
  final double? btnRadius;
  final double textColorOpacity;
  final Color? textColor;
  final Color? btnColor, borderColor;
  final VoidCallback? onPressed;
  final double? fontSize;
  final bool isTitleUpperCase;
  final bool isCompleted;
  final bool isDownloadButton;
  final bool isSecondary;
  final Widget? downloadWidget;

  const CustomFilledButton(
      {super.key, this.title,
      this.onPressed,
      this.width,
      this.isTitleUpperCase = false,
      this.height,
      this.textColor,
      this.textColorOpacity = 1,
      this.btnColor,
      this.borderColor,
      this.btnRadius,
      this.buttonGradients,
      this.fontSize,
      this.isCompleted = false,
      this.isDownloadButton = false,
      this.isSecondary = false,
      this.downloadWidget});

  @override
  Widget build(BuildContext context) {
    final resolvedBtnColor = btnColor ??
        (isSecondary ? ColorConstants.secondaryColor : ColorConstants.primaryColor);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: resolvedBtnColor, borderRadius: BorderRadius.all(Radius.circular(btnRadius ?? 10))),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedBtnColor,
          side: BorderSide(color: borderColor ?? ColorConstants.transparent),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(btnRadius ?? 10)),
          minimumSize: Size(width!, height!),
        ),
        onPressed: onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text(
              title!,
              style: TextStyle(
                  color: textColor ?? ColorConstants.white,
                  fontSize: fontSize ?? 13.sp,
                  fontWeight: FontWeight.w300,
                  height: 1.25),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            isCompleted
                ? Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.green[300],
                  )
                : isDownloadButton
                    ? downloadWidget!
                    : SizedBox(),
          ],
        ),
      ),
    );
  }
}
