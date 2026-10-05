import 'package:flutter/material.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';

import '../../../../components/bordered_container.dart';

class TotalLabourWidget extends StatefulWidget {
  final String? settledLabour;
  final String? salesTax;
  final String? totalLabour;
  final String? taxValue;

  const TotalLabourWidget({super.key, this.settledLabour, this.salesTax, this.totalLabour, this.taxValue});

  @override
  State<TotalLabourWidget> createState() => _TotalLabourWidgetState();
}

class _TotalLabourWidgetState extends State<TotalLabourWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "--------------------Labour-------------------",
            style: TextStyle(fontSize: FontSizes.normalText1, color: ColorConstants.primaryColor),
          ),
          const SizedBox(
            height: 15,
          ),
          BorderedContainer(
            title: "Settled Labour",
            value: widget.settledLabour,
          ),
          BorderedContainer(
            title: "Sales Tax",
            value: widget.salesTax,
            isGst: true,
            taxValue: widget.taxValue,
          ),
          BorderedContainer(
            title: "Total Labour",
            value: widget.totalLabour,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
