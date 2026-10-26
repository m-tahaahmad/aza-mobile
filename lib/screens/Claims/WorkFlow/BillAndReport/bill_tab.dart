import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Services/CustomerDetailServices/customer_detail_service.dart';
import 'package:icms_app/Services/CustomerDetailServices/update_single_customer.dart';
import 'package:icms_app/components/app_loader.dart';
import 'package:icms_app/components/custom_filled_button.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/constants/font_sizes.dart';
import 'package:icms_app/utils/json_values.dart';
import 'package:provider/provider.dart';

class BillTab extends StatefulWidget {
  final int? claimId;

  const BillTab({super.key, this.claimId});

  @override
  State<BillTab> createState() => _BillTabState();
}

class _BillTabState extends State<BillTab> {
  final _professionalFeeController = TextEditingController();
  final _noOfPhotosController = TextEditingController();
  final _perPhotoRateController = TextEditingController();
  final _reInspFeeController = TextEditingController();
  final _outstationFeeController = TextEditingController();
  final _partsInspFeeController = TextEditingController();
  final _conveyanceFeeController = TextEditingController();
  final _poaInspFeeController = TextEditingController();
  final _underRepairInspFeeController = TextEditingController();
  final _remarksController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasPopulatedFromProvider = false;

  @override
  void initState() {
    super.initState();
    _loadClaim();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.claimId == null || _hasPopulatedFromProvider) return;
    final provider = Provider.of<CustomerDetailProvider>(context, listen: false);
    final bill = provider.customerDetailResponseModel?.data?.bill;
    if (bill != null) {
      _populateFromBill();
    }
  }

  Future<void> _loadClaim() async {
    if (widget.claimId == null) return;
    setState(() => _isLoading = true);
    await CustomerDetailService().getCustomerDetail(context, widget.claimId);
    if (mounted) {
      setState(() => _isLoading = false);
      _populateFromBill();
    }
  }

  void _populateFromBill() {
    final bill = Provider.of<CustomerDetailProvider>(context, listen: false).customerDetailResponseModel?.data?.bill;
    if (bill == null) return;
    _professionalFeeController.text = _str(bill.professionalFee);
    _noOfPhotosController.text = _str(bill.noOfPhotos);
    _perPhotoRateController.text = _str(bill.perPhotoRate);
    _reInspFeeController.text = _str(bill.reInspFee);
    _outstationFeeController.text = _str(bill.outstationFee);
    _partsInspFeeController.text = _str(bill.partsInspFee);
    _conveyanceFeeController.text = _str(bill.conveyanceFee);
    _poaInspFeeController.text = _str(bill.poaInspFee);
    _underRepairInspFeeController.text = _str(bill.underRepairInspFee);
    _remarksController.text = _str(bill.remarks);
    _hasPopulatedFromProvider = true;
  }

  String _str(dynamic v) {
    if (v == null) return '';
    return v.toString();
  }

  int? _billAmount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return readInt(trimmed, field: 'bill');
  }

  @override
  void dispose() {
    _professionalFeeController.dispose();
    _noOfPhotosController.dispose();
    _perPhotoRateController.dispose();
    _reInspFeeController.dispose();
    _outstationFeeController.dispose();
    _partsInspFeeController.dispose();
    _conveyanceFeeController.dispose();
    _poaInspFeeController.dispose();
    _underRepairInspFeeController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (widget.claimId == null) return;

    final nPhotos = _billAmount(_noOfPhotosController.text);
    final perPhoto = _billAmount(_perPhotoRateController.text);
    final profFee = _billAmount(_professionalFeeController.text);
    final reInsp = _billAmount(_reInspFeeController.text);
    final outstation = _billAmount(_outstationFeeController.text);
    final partsInsp = _billAmount(_partsInspFeeController.text);
    final conveyance = _billAmount(_conveyanceFeeController.text);
    final poaInsp = _billAmount(_poaInspFeeController.text);
    final underRepair = _billAmount(_underRepairInspFeeController.text);
    if ([nPhotos, perPhoto, profFee, reInsp, outstation, partsInsp, conveyance, poaInsp, underRepair].any((value) => value == null)) {
      showSnackBar(context, 'Enter a valid number');
      return;
    }

    setState(() => _isSaving = true);

    final photos = nPhotos!;
    final photoRate = perPhoto!;
    final fee = profFee!;
    final reInspection = reInsp!;
    final outstationFee = outstation!;
    final partsFee = partsInsp!;
    final conveyanceFee = conveyance!;
    final poaFee = poaInsp!;
    final underRepairFee = underRepair!;
    final totalPhoto = photos * photoRate;
    final taxPct = 16;
    final taxAmt = (taxPct / 100) * fee;
    final net = fee + taxAmt;
    final netTotal = net + totalPhoto + reInspection + outstationFee + partsFee + conveyanceFee + poaFee + underRepairFee;

    final billMap = {
      'claim_id': widget.claimId,
      'professional_fee': fee,
      'no_of_photos': photos,
      'per_photo_rate': photoRate,
      'total_photo': totalPhoto,
      'tax_percent': taxPct,
      'tax_amount': taxAmt.round(),
      'net': net.round(),
      're_insp_fee': reInspection,
      'outstation_fee': outstationFee,
      'parts_insp_fee': partsFee,
      'conveyance_fee': conveyanceFee,
      'poa_insp_fee': poaFee,
      'under_repair_insp_fee': underRepairFee,
      'net_total': netTotal.round(),
      'remarks': _remarksController.text.trim().isEmpty ? null : _remarksController.text.trim(),
    };

    final body = {'data': {'bill': billMap}};
    final result = await UpdateSingleCustomer().updateCustomerDetail(context, widget.claimId, body);

    if (mounted) {
      setState(() => _isSaving = false);
      if (result.responseData?.success == true) {
        showSnackBar(context, 'Bill saved successfully');
        _loadClaim();
      } else {
        showSnackBar(context, result.message ?? 'Failed to save bill', color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: AppLoader());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(12.sp),
      child: Consumer<CustomerDetailProvider>(
        builder: (context, provider, _) {
          final bill = provider.customerDetailResponseModel?.data?.bill;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field('Fee & Professional Charges', _professionalFeeController, keyType: TextInputType.number),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(child: _field('Photograph No(s)', _noOfPhotosController, keyType: TextInputType.number)),
                  SizedBox(width: 8.w),
                  Expanded(child: _field('Per Photo Rate', _perPhotoRateController, keyType: TextInputType.number)),
                ],
              ),
              SizedBox(height: 8.h),
              _field('Re-Inspection Charges', _reInspFeeController, keyType: TextInputType.number),
              SizedBox(height: 8.h),
              _field('Outstation', _outstationFeeController, keyType: TextInputType.number),
              SizedBox(height: 8.h),
              _field('S.D. Parts Inspection Charges', _partsInspFeeController, keyType: TextInputType.number),
              SizedBox(height: 8.h),
              _field('Conveyance Charges', _conveyanceFeeController, keyType: TextInputType.number),
              SizedBox(height: 8.h),
              _field('Place of Accident Inspection Charges', _poaInspFeeController, keyType: TextInputType.number),
              SizedBox(height: 8.h),
              _field('Under-Repair Inspection Charges', _underRepairInspFeeController, keyType: TextInputType.number),
              if (bill != null) ...[
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    'Net Total: ${bill.netTotal ?? ""}',
                    style: TextStyle(fontSize: FontSizes.normalText2, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              SizedBox(height: 8.h),
              _field('Survey Fee Bill Remark(s)', _remarksController, maxLines: 3),
              SizedBox(height: 20.h),
              _isSaving
                  ? const Center(child: AppLoader())
                  : CustomFilledButton(
                      width: MediaQuery.of(context).size.width,
                      height: 48.h,
                      title: "Save Bill",
                      btnColor: ColorConstants.primaryColor,
                      onPressed: _save,
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {TextInputType? keyType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyType,
      maxLines: maxLines,
      inputFormatters: keyType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: FontSizes.smallText, color: Colors.black87),
        border: OutlineInputBorder(borderSide: BorderSide(color: ColorConstants.primaryColor)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorConstants.primaryColor)),
      ),
    );
  }
}
