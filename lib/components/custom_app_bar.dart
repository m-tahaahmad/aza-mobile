import 'package:flutter/material.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

Widget customAppBar(BuildContext context,
    {required String title,
    Color? backgroundColor,
    required bool showBackButton,
    returnValue = false,
    List<Widget>? widgets,
    Function? onTap,
    PreferredSizeWidget? bottom}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: FontSizes.normalText1, fontWeight: FontWeight.w400, color: ColorConstants.white),
    ),
    backgroundColor: backgroundColor ?? ColorConstants.primaryColor,
    automaticallyImplyLeading: false,
    actions: widgets,
    leading: showBackButton
        ? InkWell(
            onTap: onTap as void Function()? ??
                () {
                  Navigator.of(context, rootNavigator: true).pop(returnValue);
                },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ))
        : SizedBox(),
    bottom: bottom,
  );
}
