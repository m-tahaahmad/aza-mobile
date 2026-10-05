import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/constants/theme_constants.dart';

import '../../../../../constants/font_sizes.dart';

class InsuranceDetailsNotifications extends StatelessWidget {
  final String? regNo;
  final String? engineNo;
  final String? chassisNo;
  final String? make;
  final String? model;
  final String? policeStation;
  final String? firNumber;
  final String? firDate;
  final String? workshopName;

  const InsuranceDetailsNotifications({
    super.key,
    this.regNo,
    this.engineNo,
    this.chassisNo,
    this.make,
    this.model,
    this.policeStation,
    this.firNumber,
    this.firDate,
    this.workshopName,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Registration No.', regNo ?? ''),
      MapEntry('Engine No.', engineNo ?? ''),
      MapEntry('Chassis No.', chassisNo ?? ''),
      MapEntry('Make', make ?? ''),
      MapEntry('Model', model ?? ''),
      MapEntry('Police Station', policeStation ?? ''),
      MapEntry('FIR Number', firNumber ?? ''),
      MapEntry('FIR Date', firDate ?? ''),
      MapEntry('Workshop Name', workshopName ?? ''),
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 100.h),
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
                  Icons.car_repair_outlined,
                  size: 18.sp,
                  color: ColorConstants.primaryColor,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Vehicle & Workshop',
                style: TextStyle(
                  fontSize: FontSizes.largeText,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          for (var i = 0; i < rows.length; i++) ...[
            _row(label: rows[i].key, value: rows[i].value),
            if (i != rows.length - 1)
              Divider(height: 16.h, thickness: 1, color: const Color(0xFFEEF2F7)),
          ],
        ],
      ),
    );
  }

  Widget _row({required String label, required String value}) {
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
            child: Text(
              shown,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: FontSizes.normalText1,
                color: muted ? const Color(0xFFB8C0CE) : const Color(0xFF1F2937),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
