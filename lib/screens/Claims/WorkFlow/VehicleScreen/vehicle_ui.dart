import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/LabourPartsProvider/labour_parts_provider.dart';
import 'package:icms_app/Providers/VehicleItemsProvider/vehicle_items_provider.dart';
import 'package:icms_app/components/claims/customer_detail_bottom_bar.dart';
import 'package:icms_app/components/claims/customer_detail_summary_banner.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/vehicle/vehicle_diagram_card.dart';
import 'package:icms_app/components/vehicle/vehicle_helpers.dart';
import 'package:icms_app/components/vehicle/vehicle_parts_card.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:provider/provider.dart';

import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Model/LabourParts/labour_request_model.dart';
import '../../../../Model/Workflow/workflow_response_model.dart';
import '../../../../Providers/CustomerDetailProvider/customer_detail_provider.dart';
import '../../../../Providers/WorkflowProvider/workflow_provider.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import 'package:icms_app/Model/LabourParts/plr_labour_request_model.dart' as plr;

class VehicleUI extends StatefulWidget {
  final int? id;
  final bool isItemsChecked;

  const VehicleUI({super.key, this.id, this.isItemsChecked = false});

  @override
  State<VehicleUI> createState() => _VehicleUIState();
}

class _VehicleUIState extends State<VehicleUI> {
  bool showDiagram = true;
  bool isLoading = false;
  bool isFinalizing = false;
  late CustomerDetailProvider customerDetailProvider;
  late LabourPartsProvider labourPartProvider;
  late VehicleItemsProvider vehicleItemsProvider;
  List<Part>? partItems;
  CustomerDetailData? customerDetailData;
  List<plr.PlrLabours> plrLaboursList = [];
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    labourPartProvider = Provider.of<LabourPartsProvider>(context, listen: false);
    vehicleItemsProvider = Provider.of<VehicleItemsProvider>(context, listen: false);
    customerDetailData = customerDetailProvider.customerDetailResponseModel!.data;
    partItems = labourPartProvider.labourPartsResponseModel!.data;

    if (widget.isItemsChecked) {
      for (var element in customerDetailData!.labours ?? []) {
        vehicleItemsProvider.addIntoTable(part: element.part, status: element.status ?? 'NO');
      }
    } else {
      for (var element in customerDetailData!.plrLabours ?? []) {
        vehicleItemsProvider.addIntoTable(part: element.part, status: element.status);
      }
    }
  }

  bool get _showBottomBar => !vehicleFieldsReadOnly();

  void _handleBack() {
    vehicleItemsProvider.resetProvider();
    Navigator.of(context).pop(true);
  }

  void _handlePartTap(String partName) {
    setState(() {
      vehicleItemsProvider.onCarPartTap(partItems, partName);
    });
  }

  void _handleStatusChanged(int index, String status) {
    setState(() {
      vehicleItemsProvider.updateTableIndex(
        index,
        part: vehicleItemsProvider.vehicleParts[index].part,
        status: status,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (customerDetailData == null) {
      return const SafeArea(
        child: Center(child: Text('Failed to load vehicle details.')),
      );
    }

    return Consumer2<VehicleItemsProvider, WorkflowProvider>(
      builder: (context, vehicleItemsProvider, workflowProvider, child) {
        return SafeArea(
          child: Column(
            children: [
              WorkflowPageHeader(
                title: vehicleScreenTitle(isItemsChecked: widget.isItemsChecked),
                subtitle: vehicleScreenSubtitle(isItemsChecked: widget.isItemsChecked),
                onBack: _handleBack,
              ),
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                  children: [
                    CustomerDetailSummaryBanner(
                      claimNo: customerDetailData!.intimationNo,
                      regNo: customerDetailData!.regNo,
                      branchName: customerDetailData!.policy?.insuranceCompany?.name,
                    ),
                    VehicleDiagramCard(
                      showDiagram: showDiagram,
                      onToggleDiagram: () => setState(() => showDiagram = !showDiagram),
                      onPartTap: _handlePartTap,
                    ),
                    VehiclePartsCard(
                      parts: vehicleItemsProvider.vehicleParts,
                      readOnly: vehicleFieldsReadOnly(),
                      onStatusChanged: _handleStatusChanged,
                    ),
                  ],
                ),
              ),
              if (_showBottomBar)
                CustomerDetailBottomBar(
                  isLoading: isLoading,
                  isFinalizing: isFinalizing,
                  onSave: () => saveLaborParts(),
                  onDone: () => saveLaborParts(isDone: true),
                ),
            ],
          ),
        );
      },
    );
  }

  saveLaborParts({bool isDone = false}) {
    dynamic requestModel;
    plrLaboursList = [];
    setState(() {
      isLoading = true;
    });

    for (var element in vehicleItemsProvider.vehicleParts) {
      plrLaboursList.add(plr.PlrLabours(
        claimId: customerDetailData!.id,
        partId: element.part.id,
        rate: '0',
        type: widget.isItemsChecked ? 'FINAL' : 'PLR',
        status: element.status,
      ));
    }

    if (widget.isItemsChecked) {
      requestModel = LabourRequestModel(
        data: LabourRequestData(
          labours: plrLaboursList,
        ),
      );
    } else {
      requestModel = LabourRequestModel(
        data: LabourRequestData(
          plrLabours: plrLaboursList,
        ),
      );
    }

    UpdateSingleCustomer().updateCustomerDetail(context, widget.id, requestModel.toJson()).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() {
          isLoading = false;
          isSaved = true;
        });
        showSnackBar(context, 'Saved');
        if (isDone) {
          final workflowProvider = Provider.of<WorkflowProvider>(context, listen: false);
          final data = workflowProvider.workflowResponseModel?.data;
          if (vehicleItemsProvider.vehicleParts.isNotEmpty) {
            vehicleItemsProvider.resetProvider();
            setState(() {
              isFinalizing = true;
            });
            final body = widget.isItemsChecked
                ? {
                    'data': {
                      'is_parts': 1,
                    }
                  }
                : {
                    'data': {
                      'is_labor': 1,
                    }
                  };
            UpdateSingleCustomer().updateCustomerDetail(context, customerDetailData!.id, body).then((value) {
              if (!mounted) return;
              if (value.responseData?.data == 'success') {
                setState(() {
                  isFinalizing = false;
                });
                workflowProvider.setWorkflow = WorkflowResponseModel(
                  data: WorkflowData(
                    isCustomer: data!.isCustomer,
                    isDriver: data.isDriver,
                    isFirstInspPics: data.isFirstInspPics,
                    isReInspPics: data.isReInspPics,
                    isLabor: widget.isItemsChecked ? data.isLabor : 1,
                    isParts: widget.isItemsChecked ? 1 : data.isLabor,
                    isFirstInspDocs: data.isFirstInspDocs,
                    isReInspDocs: data.isReInspDocs,
                    isComments: data.isComments,
                    isReInspComment: data.isReInspComment,
                  ),
                );
                vehicleItemsProvider.resetProvider();
                Navigator.of(context).pop(true);
              } else {
                setState(() {
                  isFinalizing = false;
                });
                showSnackBar(context, 'Something went wrong');
              }
            });
          } else {
            setState(() {
              isLoading = false;
              isFinalizing = false;
            });
            showSnackBar(context, 'Details are missing!!!');
          }
        } else {
          vehicleItemsProvider.resetProvider();
          Navigator.pop(context, true);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Something went wrong');
      }
    });
  }
}
