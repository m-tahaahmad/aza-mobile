import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/vehicle/vehicle_helpers.dart';
import 'package:icms_app/components/vehicle/vehicle_part_row.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/Providers/VehicleItemsProvider/vehicle_items_provider.dart';

class VehiclePartsCard extends StatelessWidget {
  final List<VehiclePartDetail> parts;
  final bool readOnly;
  final void Function(int index, String status) onStatusChanged;

  const VehiclePartsCard({
    super.key,
    required this.parts,
    required this.readOnly,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Selected parts',
      icon: Icons.build_outlined,
      child: parts.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Tap parts on the diagram to add them here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: FontSizes.normalText1,
                  color: const Color(0xFF98A2B3),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < parts.length; i++) ...[
                  if (i > 0) customerDetailDivider(),
                  VehiclePartRow(
                    partName: parts[i].part.name ?? '',
                    status: parts[i].status,
                    readOnly: readOnly || vehicleFieldsReadOnly(),
                    onStatusChanged: (status) => onStatusChanged(i, status),
                  ),
                ],
              ],
            ),
    );
  }
}
