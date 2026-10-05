import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/constants/globals.dart';

class CustomerDetailSummaryBanner extends StatelessWidget {
  final String? claimNo;
  final String? regNo;
  final String? branchName;

  const CustomerDetailSummaryBanner({
    super.key,
    this.claimNo,
    this.regNo,
    this.branchName,
  });

  @override
  Widget build(BuildContext context) {
    final claim = claimNo?.isNotEmpty == true ? claimNo! : notAvailable;
    final reg = regNo?.isNotEmpty == true ? regNo.toString() : notAvailable;
    final branch = branchName?.isNotEmpty == true ? branchName! : notAvailable;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorConstants.primaryColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.primaryColor.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CLAIM #',
                      style: TextStyle(
                        fontSize: FontSizes.extraSmallText,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.75),
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      claim,
                      style: TextStyle(
                        fontSize: FontSizes.normalText2,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'REG #',
                    style: TextStyle(
                      fontSize: FontSizes.extraSmallText,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.75),
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      reg,
                      style: TextStyle(
                        fontSize: FontSizes.smallText,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          SizedBox(height: 14.h),
          Text(
            'BRANCH',
            style: TextStyle(
              fontSize: FontSizes.extraSmallText,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.75),
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            branch,
            style: TextStyle(
              fontSize: FontSizes.normalText2,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
