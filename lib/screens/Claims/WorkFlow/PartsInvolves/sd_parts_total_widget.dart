import 'package:flutter/material.dart';
import 'package:icms_app/utils/json_values.dart';

import '../../../../components/bordered_container.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/font_sizes.dart';

class SDPartsTotalWidget extends StatefulWidget {
  final String? replacedPartsCosts;
  final String? depAmount;
  final String? gst;
  final String? gstAmount;
  final String? sal;
  final String? subTotal;

  const SDPartsTotalWidget({super.key, this.replacedPartsCosts, this.depAmount, this.gst, this.gstAmount, this.sal, this.subTotal});

  @override
  State<SDPartsTotalWidget> createState() => _SDPartsTotalWidgetState();
}

class _SDPartsTotalWidgetState extends State<SDPartsTotalWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "--------------------SD-Parts-------------------",
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
            value: readIntOrZero(widget.replacedPartsCosts, field: 'replaced_parts') -
                readIntOrZero(widget.depAmount, field: 'dep'),
            textColor: ColorConstants.primaryColor,
          ),
          BorderedContainer(
            title: "GST SD Parts",
            value: widget.gstAmount,
            isGst: true,
            taxValue: widget.gst,
          ),
          BorderedContainer(
            value: (readIntOrZero(widget.replacedPartsCosts, field: 'replaced_parts') -
                    readIntOrZero(widget.depAmount, field: 'dep')) +
                readIntOrZero(widget.gstAmount, field: 'gst'),
            textColor: ColorConstants.primaryColor,
          ),
          BorderedContainer(
            title: "Salvage",
            value: widget.sal,
          ),
          BorderedContainer(
            value: ((readIntOrZero(widget.replacedPartsCosts, field: 'replaced_parts') -
                        readIntOrZero(widget.depAmount, field: 'dep')) +
                    readIntOrZero(widget.gstAmount, field: 'gst')) -
                readIntOrZero(widget.sal, field: 'salvage'),
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
