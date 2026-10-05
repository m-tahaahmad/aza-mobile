import 'package:flutter/material.dart';

import '../../../../components/bordered_container.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/font_sizes.dart';

class PartsTotalWidget extends StatefulWidget {
  final String? replacedPartsCosts;
  final String? depAmount;
  final String? gst;
  final String? gstAmount;
  final String? sal;
  final String? subTotal;

  const PartsTotalWidget({super.key, this.replacedPartsCosts, this.depAmount, this.gst, this.gstAmount, this.sal, this.subTotal});

  @override
  State<PartsTotalWidget> createState() => _PartsTotalWidgetState();
}

class _PartsTotalWidgetState extends State<PartsTotalWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "--------------------Parts-------------------",
            style: TextStyle(fontSize: FontSizes.normalText1, color: ColorConstants.primaryColor),
          ),
          const SizedBox(
            height: 15,
          ),
          BorderedContainer(
            title: "Costs of parts replaced",
            value: widget.replacedPartsCosts,
          ),
          BorderedContainer(
            value: widget.replacedPartsCosts,
            textColor: ColorConstants.primaryColor,
          ),
          BorderedContainer(
            title: "Depreciation Amount",
            value: widget.depAmount,
          ),
          BorderedContainer(
            value: int.parse(widget.replacedPartsCosts!) - int.parse(widget.depAmount!),
            textColor: ColorConstants.primaryColor,
          ),
          BorderedContainer(
            title: "GST Parts",
            value: widget.gstAmount,
            isGst: true,
            taxValue: widget.gst,
          ),
          BorderedContainer(
            value: (int.parse(widget.replacedPartsCosts!) - int.parse(widget.depAmount!)) + int.parse(widget.gstAmount!),
            textColor: ColorConstants.primaryColor,
          ),
          BorderedContainer(
            title: "Salvage",
            value: widget.sal,
          ),
          BorderedContainer(
            value: ((int.parse(widget.replacedPartsCosts!) - int.parse(widget.depAmount!)) + int.parse(widget.gstAmount!)) - int.parse(widget.sal!),
            textColor: ColorConstants.primaryColor,
          ),
          BorderedContainer(
            title: "SubTotal Parts Amount",
            value: widget.subTotal,
          ),
          BorderedContainer(
            value: widget.subTotal,
            textColor: ColorConstants.primaryColor,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
