import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/app_pressable.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailSummaryCard extends StatelessWidget {
  final String customerName;
  final String contactNo;
  final String claimNo;
  final String claimType;

  const CustomerDetailSummaryCard({
    super.key,
    required this.customerName,
    required this.contactNo,
    required this.claimNo,
    required this.claimType,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(customerName);
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
                width: 48.w,
                height: 48.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.primaryColor,
                ),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: FontSizes.largeText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CUSTOMER',
                      style: TextStyle(
                        color: const Color(0xFF98A2B3),
                        letterSpacing: 1.1,
                        fontSize: FontSizes.extraSmallText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      customerName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF1F2937),
                        fontSize: FontSizes.normalText2,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              AppPressable(
                onTap: _openDialer,
                borderRadius: 14.r,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F4EA),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    CupertinoIcons.phone,
                    color: const Color(0xFF0A8F4C),
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _chip(
                icon: CupertinoIcons.doc_text,
                text: claimNo,
                textColor: ColorConstants.primaryColor,
                background: ColorConstants.secondaryColor.withValues(alpha: 0.25),
              ),
              _chip(
                icon: CupertinoIcons.exclamationmark_triangle,
                text: claimType,
                textColor: const Color(0xFFB06800),
                background: const Color(0xFFFFF0D8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String text,
    required Color textColor,
    required Color background,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: textColor),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: FontSizes.smallText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDialer() async {
    final number = contactNo.trim();
    if (number.isEmpty) return;
    final phoneNo = Uri.parse('tel:$number');
    await launchUrl(phoneNo);
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((element) => element.isNotEmpty).toList();
    if (parts.isEmpty) return 'NA';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}
