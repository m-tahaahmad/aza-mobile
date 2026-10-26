import 'package:flutter/material.dart';
import 'package:icms_app/Providers/DocumentsProvider/documents_provider.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CheckList/document_pictures_ui.dart';
import 'package:provider/provider.dart';

import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../Services/Documents/document_service.dart';
import '../../../../components/workflow/workflow_async_body.dart';
import '../../../../constants/theme_constants.dart';

class TakeDocumentPicturesScreen extends StatefulWidget {
  final int? id;
  final int? documentId;
  final String? documentName;

  const TakeDocumentPicturesScreen({
    super.key,
    this.id,
    this.documentId,
    this.documentName,
  });

  @override
  State<TakeDocumentPicturesScreen> createState() => _TakeDocumentPicturesScreenState();
}

class _TakeDocumentPicturesScreenState extends State<TakeDocumentPicturesScreen> {
  Future<ApiResponse<CustomerDetailResponseModel>?>? _getCustomerDetails;
  Future<ApiResponse<dynamic>>? _getDocuments;
  Future<List<ApiResponse<dynamic>?>>? apisList;

  @override
  void initState() {
    super.initState();
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    _getDocuments = DocumentService().getAllDocument(context);
    apisList = Future.wait([_getCustomerDetails!, _getDocuments!]);
  }

  Future _handleRefresh() async {
    _getCustomerDetails = CustomerDetailService().getCustomerDetail(context, widget.id);
    _getDocuments = DocumentService().getAllDocument(context);
    apisList = Future.wait([_getCustomerDetails!, _getDocuments!]);
    await Future.delayed(const Duration(milliseconds: 1500));
    return apisList;
  }

  String? _resolveDocumentName() {
    if (widget.documentName?.isNotEmpty == true) return widget.documentName;
    final docs = Provider.of<DocumentsProvider>(context, listen: false).documentResponseModel?.data ?? [];
    final match = docs.where((d) => d.id == widget.documentId).firstOrNull;
    return match?.name;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorConstants.primaryColor,
      onRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        body: FutureBuilder<List<ApiResponse<dynamic>?>>(
          future: apisList,
          builder: (context, AsyncSnapshot<List<ApiResponse<dynamic>?>> snapshot) {
            return workflowAsyncBody(
              snapshot: snapshot,
              fallback: 'Failed to load document details.',
              ready: () => DocumentPicturesUI(
                documentId: widget.documentId,
                documentName: _resolveDocumentName(),
              ),
            );
          },
        ),
      ),
    );
  }
}
