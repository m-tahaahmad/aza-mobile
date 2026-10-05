import 'package:flutter/material.dart';
import 'package:icms_app/Providers/DocumentsProvider/documents_provider.dart';
import 'package:icms_app/screens/Claims/WorkFlow/CheckList/document_pictures_ui.dart';
import 'package:provider/provider.dart';

import '../../../../Model/CustomersDataModel/customer_detail_response_model.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../Services/CustomerDetailServices/customer_detail_service.dart';
import '../../../../Services/Documents/document_service.dart';
import '../../../../components/app_loader.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/font_sizes.dart';

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
            if (!snapshot.hasData) {
              return const Center(child: AppLoader());
            }

            final results = snapshot.data!;
            final allCompleted = results.every((response) => response?.status == Status.completed);
            if (!allCompleted) {
              final message = results
                  .where((response) => response?.status == Status.error)
                  .map((response) => response?.message)
                  .whereType<String>()
                  .firstOrNull;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    message ?? 'Failed to load document details.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FontSizes.normalText1,
                      color: const Color(0xFF667085),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }

            return DocumentPicturesUI(
              documentId: widget.documentId,
              documentName: _resolveDocumentName(),
            );
          },
        ),
      ),
    );
  }
}
