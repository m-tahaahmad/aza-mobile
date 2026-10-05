import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';
import '../constants/font_sizes.dart';
import '../constants/globals.dart';

class ClaimHeader extends StatefulWidget {
  final String? claimNo;
  final String? regNo;
  final String? insuranceCompanyName;

  const ClaimHeader({super.key, this.claimNo, this.regNo, this.insuranceCompanyName});

  @override
  State<ClaimHeader> createState() => _ClaimHeaderState();
}

class _ClaimHeaderState extends State<ClaimHeader> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      // height: size.height * 0.08,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: ColorConstants.primaryColor, width: 1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Claim#          ${widget.claimNo ?? notAvailable}",
                  style: TextStyle(fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300)),
              Text("Reg#          ${widget.regNo ?? notAvailable}", style: TextStyle(fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300)),
            ],
          ),
          Text("Branch Name:      ${widget.insuranceCompanyName ?? notAvailable}",
              style: TextStyle(fontSize: FontSizes.normalText1, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}
