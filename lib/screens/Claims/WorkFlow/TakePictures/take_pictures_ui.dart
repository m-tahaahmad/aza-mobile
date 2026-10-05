import 'package:flutter/material.dart';
import 'package:icms_app/Providers/CustomerDetailProvider/customer_detail_provider.dart';
import 'package:icms_app/Providers/MediaProvider/media_provider.dart';
import 'package:icms_app/Providers/WorkflowProvider/workflow_provider.dart';
import 'package:icms_app/Services/API/client_error_reporter.dart';
import 'package:icms_app/components/custom_snack_bar.dart';
import 'package:icms_app/components/pictures/pictures_bottom_bar.dart';
import 'package:icms_app/components/pictures/pictures_segmented_tabs.dart';
import 'package:icms_app/components/workflow/workflow_page_header.dart';
import 'package:icms_app/screens/Claims/WorkFlow/TakePictures/first_inspection_tab.dart';
import 'package:icms_app/screens/Claims/WorkFlow/TakePictures/pre_inspection_tab.dart';
import 'package:icms_app/screens/Claims/WorkFlow/TakePictures/re_inspection_tab.dart';
import 'package:icms_app/screens/Claims/WorkFlow/TakePictures/sd_tab.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../Model/Workflow/workflow_response_model.dart';
import '../../../../Providers/DialogProvider/dialog_provider.dart';
import '../../../../Services/CustomerDetailServices/update_single_customer.dart';
import '../../../../components/withdraw_dialog.dart';
import '../../../../constants/globals.dart';

class PicturesUI extends StatefulWidget {
  const PicturesUI({super.key});

  @override
  State<PicturesUI> createState() => _PicturesUIState();
}

class _PicturesUIState extends State<PicturesUI> with SingleTickerProviderStateMixin {
  late CustomerDetailProvider customerDetailProvider;
  bool isFinalizing = false;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    customerDetailProvider = Provider.of<CustomerDetailProvider>(context, listen: false);
    _loadImages();
  }

  void _loadImages() {
    final data = customerDetailProvider.customerDetailResponseModel!.data;
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final inspImages = data?.inspectionImages?.toList() ?? [];
    final reInspImages = data?.reInspectionImages?.toList() ?? [];
    final sdImages = data?.sdImages?.toList() ?? [];
    final preInspectImages = data?.preInspectionImages?.toList() ?? [];

    for (final e in inspImages) {
      if (e.image != null) {
        mediaProvider.images.add(e.image!);
      }
    }
    for (final e in reInspImages) {
      if (e.image != null) {
        mediaProvider.reInspectImages.add(e.image!);
      }
    }
    for (final e in sdImages) {
      if (e.image != null) {
        mediaProvider.sdImages.add(e.image!);
      }
    }
    for (final e in preInspectImages) {
      if (e.image != null) {
        mediaProvider.preInspectImages.add(e.image!);
      }
    }
    mediaProvider.refreshMedia();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  bool get _showBottomBar =>
      claimsType != 'Waiting for approval' && claimsType != 'Reports Pending';

  void _handleBack(MediaProvider mediaProvider) {
    if (mediaProvider.isUploading) {
      ClientErrorReporter.report(
        kind: ClientErrorKind.client,
        userVisibleMessage: 'Tried to leave while uploading',
        exceptionClass: 'Mobile.UploadAbandonBlocked',
      );
      showSnackBar(context, 'Please wait — uploads in progress');
      return;
    }
    mediaProvider.resetProvider();
    Navigator.of(context).pop(true);
  }

  void _handleTabTap(int index) {
    if ((index == 1 || index == 2) && !checkForReInspections()) {
      showSnackBar(context, 'Not Available');
      return;
    }
    tabController?.animateTo(index);
  }

  bool _isFirstInspectionPictures(MediaProvider mediaProvider) {
    if (claimsType == '1st Inspection' || claimsType == 'Rejected' || claimsType == 'pre') {
      return true;
    }
    if (claimsType == 'Re-Inspections Pending' || isReinspectionsPending) {
      return false;
    }
    final activeTab = tabController?.index ?? 0;
    return activeTab == 0 && mediaProvider.images.isNotEmpty;
  }

  bool _isReInspectionPictures(MediaProvider mediaProvider) {
    if (claimsType == 'Re-Inspections Pending' || isReinspectionsPending) {
      return true;
    }
    final activeTab = tabController?.index ?? 0;
    return activeTab == 1 && mediaProvider.reInspectImages.isNotEmpty;
  }

  void _handleDone(MediaProvider mediaProvider) {
    final workflowProvider = Provider.of<WorkflowProvider>(context, listen: false);
    final data = workflowProvider.workflowResponseModel?.data;
    final markFirstInspPics = _isFirstInspectionPictures(mediaProvider);
    final markReInspPics = _isReInspectionPictures(mediaProvider);

    if (mediaProvider.images.isEmpty &&
        mediaProvider.reInspectImages.isEmpty &&
        mediaProvider.preInspectImages.isEmpty) {
      showSnackBar(context, 'Details are missing!!!');
      return;
    }

    setState(() => isFinalizing = true);

    workflowProvider.setWorkflow = WorkflowResponseModel(
      data: WorkflowData(
        isCustomer: data!.isCustomer,
        isDriver: data.isDriver,
        isFirstInspPics: markFirstInspPics ? 1 : data.isFirstInspPics,
        isReInspPics: markReInspPics ? 1 : data.isReInspPics,
        isLabor: data.isLabor,
        isParts: data.isParts,
        isFirstInspDocs: data.isFirstInspDocs,
        isReInspDocs: data.isReInspDocs,
        isComments: data.isComments,
        isReInspComment: data.isReInspComment,
      ),
    );

    if (isReinspectionsPending) {
      showDialog(
        context: context,
        builder: (_) {
          return WithdrawDialog(
            title: 'Done Taking Pictures?',
            actionText1: 'No',
            fromMedia: true,
            onTap: () {
              setState(() => isFinalizing = false);
              Navigator.of(context).pop();
            },
            actionText2: 'Yes',
            onTap2: () {
              final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
              final body = {
                'data': {
                  'is_reinspection': 1,
                  'is_re_insp_pics': 1,
                  'workshop': {'re_insp_date': formattedDate},
                }
              };
              UpdateSingleCustomer().updateCustomerDetail(context, claimId, body).then((value) {
                if (!mounted) return;
                if (value.responseData?.data == 'success') {
                  setState(() => isFinalizing = false);
                  mediaProvider.resetProvider();
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop()
                    ..pop(true);
                } else {
                  setState(() => isFinalizing = false);
                  showSnackBar(context, 'Something went wrong');
                }
              });
            },
          );
        },
      );
      return;
    }

    final Map<String, dynamic> body;
    if (markFirstInspPics) {
      body = {
        'data': {'is_first_insp_pics': 1}
      };
    } else if (markReInspPics) {
      body = {
        'data': {'is_re_insp_pics': 1}
      };
    } else if (claimsType == 'pre') {
      body = {
        'data': {'is_first_insp_pics': 1}
      };
    } else {
      body = {
        'data': {'is_first_insp_docs': 1}
      };
    }

    UpdateSingleCustomer().updateCustomerDetail(context, claimId, body).then((value) {
      if (!mounted) return;
      if (value.responseData?.data == 'success') {
        setState(() => isFinalizing = false);
        mediaProvider.resetProvider();
        Navigator.of(context).pop(true);
      } else {
        setState(() => isFinalizing = false);
        showSnackBar(context, 'Something went wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
        if (mediaProvider.isUploading) {
          ClientErrorReporter.report(
            kind: ClientErrorKind.client,
            userVisibleMessage: 'Tried to leave while uploading',
            exceptionClass: 'Mobile.UploadAbandonBlocked',
          );
          showSnackBar(context, 'Please wait — uploads in progress');
          return;
        }
        mediaProvider.resetProvider();
        Navigator.of(context).pop(true);
      },
      child: Consumer3<CustomerDetailProvider, DialogProvider, MediaProvider>(
        builder: (context, customerDetailProvider, dialogProvider, mediaProvider, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3F5F9),
            body: SafeArea(
              child: Column(
                children: [
                  WorkflowPageHeader(
                    title: 'Pictures',
                    subtitle: 'Vehicle inspection photos',
                    onBack: () => _handleBack(mediaProvider),
                  ),
                  if (claimsType != 'pre')
                    PicturesSegmentedTabs(
                      controller: tabController!,
                      onTabTap: _handleTabTap,
                    ),
                  Expanded(
                    child: claimsType == 'pre'
                        ? PreInspectionTab()
                        : TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: [
                              FirstInspectionTab(),
                              ReInspectionTab(),
                              SDTab(),
                            ],
                          ),
                  ),
                  if (_showBottomBar)
                    PicturesBottomBar(
                      isUploading: mediaProvider.isUploading,
                      isFinalizing: isFinalizing,
                      onCancelUpload: () => mediaProvider.cancelUploads(),
                      onDone: () => _handleDone(mediaProvider),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool checkForReInspections() {
    return claimsType == 'Re-Inspections Pending' ||
        claimsType == 'Reports Pending' ||
        claimsType == 'Waiting for approval';
  }
}
