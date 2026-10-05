import 'package:flutter/material.dart';
import 'package:icms_app/Providers/LabourPartsProvider/labour_parts_provider.dart';
import 'package:icms_app/constants/asset_constants.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../constants/globals.dart';

class PartsSelectionWidget extends StatefulWidget {
  final Function? onTap1;
  final Function? onTap2;
  final Function? onTap3;
  final Function? onTap4;
  final Function? onTap5;
  final Function? onTap6;
  final Function? onTap7;
  final Function? onTap8;
  final Function? onTap9;
  final Function? onTap10;
  final Function? onTap11;
  final Function? onTap12;
  final Function? onTap13;
  final Function? onTap14;
  final Function? onTap15;
  final Function? onTap16;
  final Function? onTap17;
  final Function? onTap18;
  final Function? onTap19;
  final Function? onTap20;
  final Function? onTap21;

  const PartsSelectionWidget(
      {super.key,
      this.onTap1,
      this.onTap2,
      this.onTap3,
      this.onTap4,
      this.onTap5,
      this.onTap6,
      this.onTap7,
      this.onTap8,
      this.onTap9,
      this.onTap10,
      this.onTap11,
      this.onTap12,
      this.onTap13,
      this.onTap14,
      this.onTap15,
      this.onTap16,
      this.onTap17,
      this.onTap18,
      this.onTap19,
      this.onTap20,
      this.onTap21});

  @override
  State<PartsSelectionWidget> createState() => _PartsSelectionWidgetState();
}

class _PartsSelectionWidgetState extends State<PartsSelectionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<LabourPartsProvider>(builder: (context, partsProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              AssetConstants.car,
              width: size.width * 0.65,
            ),
            SizedBox(
              width: size.width,
              height: size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      partIndicator(partsProvider.checkPartID("Right Front Fender"), onTap: widget.onTap1),
                      const SizedBox(
                        width: 10,
                      ),
                      partIndicator(partsProvider.checkPartID("Right View Mirror"), onTap: widget.onTap2),
                      const SizedBox(
                        width: 10,
                      ),
                      partIndicator(partsProvider.checkPartID("Right Front Door"), onTap: widget.onTap3),
                      const SizedBox(
                        width: 10,
                      ),
                      partIndicator(partsProvider.checkPartID("Right Rear Door"), onTap: widget.onTap4),
                      const SizedBox(
                        width: 10,
                      ),
                      partIndicator(partsProvider.checkPartID("Right Rear Fender"), onTap: widget.onTap5),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        partIndicator(partsProvider.checkPartID("Right Head Light"), onTap: widget.onTap6),
                        partIndicator(partsProvider.checkPartID("Right Tail Light"), onTap: widget.onTap7),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          partIndicator(partsProvider.checkPartID("Front Bumper"), onTap: widget.onTap8),
                          const SizedBox(
                            width: 10,
                          ),
                          partIndicator(partsProvider.checkPartID("Bonnet"), onTap: widget.onTap9),
                          const SizedBox(
                            width: 10,
                          ),
                          partIndicator(partsProvider.checkPartID("Front Wind Screen Fitting"), onTap: widget.onTap10),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      partIndicator(partsProvider.checkPartID("Roof"), onTap: widget.onTap11),
                      Row(
                        children: [
                          partIndicator(partsProvider.checkPartID("Rear Wind Screen Fitting"), onTap: widget.onTap12),
                          partIndicator(partsProvider.checkPartID("Dickey"), onTap: widget.onTap13),
                          partIndicator(partsProvider.checkPartID("Rear Bumper"), onTap: widget.onTap14),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        partIndicator(partsProvider.checkPartID("Left Head Light"), onTap: widget.onTap15),
                        partIndicator(partsProvider.checkPartID("Left Tail Light"), onTap: widget.onTap16),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      partIndicator(partsProvider.checkPartID("Left Front Fender"), onTap: widget.onTap17),
                      const SizedBox(
                        width: 10,
                      ),
                      partIndicator(partsProvider.checkPartID("Left View Mirror"), onTap: widget.onTap18),
                      const SizedBox(
                        width: 10,
                      ),
                      partIndicator(partsProvider.checkPartID("Left Front Door"), onTap: widget.onTap19),
                      const SizedBox(
                        width: 10,
                      ),
                      partIndicator(partsProvider.checkPartID("Left Rear Door"), onTap: widget.onTap20),
                      const SizedBox(
                        width: 10,
                      ),
                      partIndicator(partsProvider.checkPartID("Left Rear Fender"), onTap: widget.onTap21),
                    ],
                  ),
                ],
              ),
            ),
            claimsType == "Waiting for approval" ||
                    claimsType == "Docs Pending" ||
                    claimsType == "Reports Pending"
                ? Container(
                    color: Colors.black.withValues(alpha: 0.01),
                    width: size.width,
                    height: size.height * 0.3,
                  )
                : const SizedBox()
          ],
        ),
      );
    });
  }

  Widget partIndicator(bool part, {Function? onTap}) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: // Figma Flutter Generator Group5Widget - GROUP
              SizedBox(
                  width: 22,
                  height: 22,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(217, 217, 217, 1),
                              border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, 1),
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.all(Radius.elliptical(64, 64)),
                            ))),
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: part ? ColorConstants.notificationBar : const Color.fromRGBO(217, 217, 217, 1),
                              border: Border.all(
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.all(Radius.elliptical(64, 64)),
                            ))),
                  ]))),
    );
  }
}
