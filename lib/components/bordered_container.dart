import 'package:flutter/material.dart';

import '../constants/font_sizes.dart';

class BorderedContainer extends StatefulWidget {
  final String? title;
  final dynamic value;
  final String? taxValue;
  final bool isGst;
  final Color? textColor;

  const BorderedContainer({super.key, this.title, this.value, this.isGst = false, this.taxValue, this.textColor});

  @override
  State<BorderedContainer> createState() => _BorderedContainerState();
}

class _BorderedContainerState extends State<BorderedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title ?? "",
            style: TextStyle(fontSize: FontSizes.smallText, fontWeight: FontWeight.w400),
          ),
          widget.isGst
              ? Text(
                  "(${widget.taxValue ?? ""}%)",
                  style: TextStyle(fontSize: FontSizes.smallText, fontWeight: FontWeight.w400),
                )
              : const SizedBox(),
          Text(
            widget.value.toString(),
            style: TextStyle(fontSize: FontSizes.smallText, fontWeight: FontWeight.w400, color: widget.textColor ?? Colors.black),
          )
        ],
      ),
    );
  }
}
