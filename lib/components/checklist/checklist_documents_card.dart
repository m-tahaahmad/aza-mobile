import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Model/DocumentsModel/document_response_model.dart';
import 'package:icms_app/components/checklist/checklist_document_row.dart';
import 'package:icms_app/components/checklist/checklist_helpers.dart';
import 'package:icms_app/components/claims/customer_detail_section_card.dart';
import 'package:icms_app/constants/font_sizes.dart';

class ChecklistDocumentsCard extends StatelessWidget {
  final List<DocumentData> documents;
  final List<Documents> claimDocuments;
  final void Function(DocumentData document) onDocumentTap;

  const ChecklistDocumentsCard({
    super.key,
    required this.documents,
    required this.claimDocuments,
    required this.onDocumentTap,
  });

  @override
  Widget build(BuildContext context) {
    final completed = checklistCompletedCount(documents, claimDocuments);
    final total = documents.length;

    return CustomerDetailSectionCard(
      title: 'Documents',
      icon: Icons.checklist_rtl_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$completed of $total complete',
            style: TextStyle(
              fontSize: FontSizes.smallText,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF98A2B3),
            ),
          ),
          SizedBox(height: 8.h),
          ...List.generate(documents.length, (index) {
            final doc = documents[index];
            final isComplete = isDocumentComplete(doc, claimDocuments);
            return Column(
              children: [
                ChecklistDocumentRow(
                  document: doc,
                  isComplete: isComplete,
                  onTap: () => onDocumentTap(doc),
                ),
                if (index < documents.length - 1)
                  Divider(height: 1, color: const Color(0xFFEEF2F7)),
              ],
            );
          }),
        ],
      ),
    );
  }
}
