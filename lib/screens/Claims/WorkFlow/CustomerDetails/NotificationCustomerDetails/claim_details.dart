import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constants/font_sizes.dart';

class ClaimDetails extends StatelessWidget {
  final String? claimDate;
  final String? lossDate;
  final String? policyNo;
  final String? contactNo;

  const ClaimDetails({
    super.key,
    this.claimDate,
    this.lossDate,
    this.policyNo,
    this.contactNo,
  });

  @override
  Widget build(BuildContext context) {
    final entries = <MapEntry<String, String>>[
      MapEntry('Claim Date', claimDate ?? ''),
      MapEntry('Loss Date', lossDate ?? ''),
      MapEntry('Policy No.', policyNo ?? ''),
      MapEntry('Contact No.', contactNo ?? ''),
    ];

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
                child: Icon(
                  Icons.description_outlined,
                  size: 18.sp,
                  color: ColorConstants.primaryColor,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Claim Details',
                style: TextStyle(
                  fontSize: FontSizes.largeText,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          for (var i = 0; i < entries.length; i++) ...[
            _row(
              label: entries[i].key,
              value: entries[i].value,
              isPhone: entries[i].key == 'Contact No.',
            ),
            if (i != entries.length - 1)
              Divider(height: 16.h, thickness: 1, color: const Color(0xFFEEF2F7)),
          ],
        ],
      ),
    );
  }

  Widget _row({
    required String label,
    required String value,
    bool isPhone = false,
  }) {
    final shown = value.isEmpty ? 'Not provided' : value;
    final muted = shown.toLowerCase() == 'not provided';
    return Row(
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
            child: GestureDetector(
              onTap: isPhone && !muted
                  ? () async {
                      final phoneNo = Uri.parse('tel:$shown');
                      await launchUrl(phoneNo);
                    }
                  : null,
              child: Text(
                shown,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FontSizes.normalText1,
                  color: isPhone && !muted
                      ? ColorConstants.primaryColor
                      : muted
                          ? const Color(0xFFB8C0CE)
                          : const Color(0xFF1F2937),
                  fontWeight: FontWeight.w700,
                  decoration: isPhone && !muted ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
