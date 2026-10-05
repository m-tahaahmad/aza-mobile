import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icms_app/components/app_pressable.dart';

import '../constants/theme_constants.dart';
import '../constants/font_sizes.dart';

Widget gridItem(Size size, String title, IconData icon, Function onTap, {bool showBadge = false, int? badgeCount = 0}) {
  return Container(
    decoration: BoxDecoration(
      color: ColorConstants.primaryColor,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.black.withValues(alpha: 0.3)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: AppPressable(
      onTap: onTap as void Function()?,
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: showBadge ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 35.sp,
                ),
                showBadge
                    ? SizedBox(
                        width: 60.w,
                        child: Text(
                          badgeCount != null && badgeCount > 0 && badgeCount < 10 ? "0$badgeCount" : badgeCount.toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: ColorConstants.baseColor, fontSize: FontSizes.hugeText, fontWeight: FontWeight.bold),
                          ),
                          textAlign: TextAlign.end,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            FittedBox(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1, fontSize: FontSizes.normalText1, color: ColorConstants.white),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
