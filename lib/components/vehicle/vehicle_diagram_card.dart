import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/components/vehicle/vehicle_helpers.dart';
import 'package:icms_app/components/vehicle_item_selection.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

class VehicleDiagramCard extends StatelessWidget {
  final bool showDiagram;
  final VoidCallback onToggleDiagram;
  final void Function(String partName) onPartTap;

  const VehicleDiagramCard({
    super.key,
    required this.showDiagram,
    required this.onToggleDiagram,
    required this.onPartTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomerDetailSectionCard(
      title: 'Vehicle diagram',
      icon: Icons.directions_car_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40.h,
            child: OutlinedButton(
              onPressed: onToggleDiagram,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ColorConstants.secondaryColor.withValues(alpha: 0.5)),
                backgroundColor: ColorConstants.secondaryColor.withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                showDiagram ? 'Hide diagram' : 'Show diagram',
                style: TextStyle(
                  color: ColorConstants.primaryColor,
                  fontSize: FontSizes.normalText2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (showDiagram) ...[
            SizedBox(height: 12.h),
            VehicleItemSelectionWidget(
              onTap1: () => onPartTap(kVehicleDiagramParts[0]),
              onTap2: () => onPartTap(kVehicleDiagramParts[1]),
              onTap3: () => onPartTap(kVehicleDiagramParts[2]),
              onTap4: () => onPartTap(kVehicleDiagramParts[3]),
              onTap5: () => onPartTap(kVehicleDiagramParts[4]),
              onTap6: () => onPartTap(kVehicleDiagramParts[5]),
              onTap7: () => onPartTap(kVehicleDiagramParts[6]),
              onTap8: () => onPartTap(kVehicleDiagramParts[7]),
              onTap9: () => onPartTap(kVehicleDiagramParts[8]),
              onTap10: () => onPartTap(kVehicleDiagramParts[9]),
              onTap11: () => onPartTap(kVehicleDiagramParts[10]),
              onTap12: () => onPartTap(kVehicleDiagramParts[11]),
              onTap13: () => onPartTap(kVehicleDiagramParts[12]),
              onTap14: () => onPartTap(kVehicleDiagramParts[13]),
              onTap15: () => onPartTap(kVehicleDiagramParts[14]),
              onTap16: () => onPartTap(kVehicleDiagramParts[15]),
              onTap17: () => onPartTap(kVehicleDiagramParts[16]),
              onTap18: () => onPartTap(kVehicleDiagramParts[17]),
              onTap19: () => onPartTap(kVehicleDiagramParts[18]),
              onTap20: () => onPartTap(kVehicleDiagramParts[19]),
              onTap21: () => onPartTap(kVehicleDiagramParts[20]),
            ),
          ],
        ],
      ),
    );
  }
}
