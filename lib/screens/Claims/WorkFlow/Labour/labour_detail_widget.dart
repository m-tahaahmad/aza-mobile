import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/LabourPartsProvider/labour_parts_provider.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:provider/provider.dart';

import 'package:icms_app/utils/json_values.dart';

import '../../../../constants/globals.dart';

bool labourFieldsReadOnly() {
  return claimsType == 'Waiting for approval' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';
}

class LabourDetailWidget extends StatefulWidget {
  final String? plrDemand;
  final String? plrAgreed;
  final String? plrTaxRate;
  final bool comeFromThirdParty;

  const LabourDetailWidget({
    super.key,
    this.plrDemand,
    this.plrAgreed,
    this.plrTaxRate,
    this.comeFromThirdParty = false,
  });

  @override
  State<LabourDetailWidget> createState() => _LabourDetailWidgetState();
}

class _LabourDetailWidgetState extends State<LabourDetailWidget> {
  late LabourPartsProvider labourPartProvider;
  String? _settledError;

  @override
  void initState() {
    super.initState();
    labourPartProvider = Provider.of<LabourPartsProvider>(context, listen: false);
    labourPartProvider.demandController.text = widget.plrDemand ?? '';
    labourPartProvider.settledController.text = widget.plrAgreed ?? '';
    labourPartProvider.taxController.text = widget.plrTaxRate ?? '';
    labourPartProvider.settledController.addListener(() {
      _validateSettled(labourPartProvider.settledController.text);
    });
    labourPartProvider.demandController.addListener(() {
      _validateSettled(labourPartProvider.settledController.text);
    });
  }

  void _validateSettled(String value) {
    if (widget.comeFromThirdParty) {
      setState(() => _settledError = null);
      return;
    }
    if (value.isEmpty) {
      setState(() => _settledError = null);
      return;
    }
    final settled = readNum(value, field: 'settled', report: false);
    final demand = readNum(
      labourPartProvider.demandController.text.isNotEmpty ? labourPartProvider.demandController.text : '0',
      field: 'demand',
      report: false,
    );
    if (settled == null || demand == null || settled > demand) {
      setState(() => _settledError = 'Value cannot be greater than Demand');
    } else {
      setState(() => _settledError = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = labourFieldsReadOnly();

    return CustomerDetailSectionCard(
      title: 'Labour Costs',
      icon: Icons.payments_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.comeFromThirdParty) ...[
                Expanded(
                  child: _readOnlyField(
                    readOnly: readOnly,
                    child: customerDetailLabeledPkrTextField(
                      label: 'Labour Demand',
                      controller: labourPartProvider.demandController,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _readOnlyField(
                      readOnly: readOnly,
                      child: customerDetailLabeledPkrTextField(
                        label: 'Labour Settled',
                        controller: labourPartProvider.settledController,
                      ),
                    ),
                    if (_settledError != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          _settledError!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFFE53935),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          customerDetailFieldGap(),
          _readOnlyField(
            readOnly: readOnly,
            child: customerDetailLabeledSuffixTextField(
              label: 'Sales Tax',
              controller: labourPartProvider.taxController,
              suffixText: '%',
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget _readOnlyField({required bool readOnly, required Widget child}) {
    if (!readOnly) return child;
    return IgnorePointer(
      ignoring: true,
      child: Opacity(opacity: 0.75, child: child),
    );
  }
}
