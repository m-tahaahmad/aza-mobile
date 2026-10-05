import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/Model/DocumentsModel/document_response_model.dart';
import 'package:icms_app/constants/globals.dart';

bool checklistFieldsReadOnly() {
  return claimsType == 'Waiting for approval' || claimsType == 'Reports Pending';
}

bool checklistUploadReadOnly() {
  return claimsType == 'Reports Pending' ||
      claimsType == 'Waiting for approval' ||
      claimsType == 'Docs Pending';
}

bool isDocumentRequired(int? documentId) {
  if (documentId == null) return false;
  if (claimsType == 'Re-Inspections Pending' &&
      documentId != 3 &&
      documentId != 4 &&
      documentId != 11 &&
      documentId != 12) {
    return true;
  }
  if ((claimsType == '1st Inspection' || claimsType == 'Rejected') && documentId == 9) {
    return true;
  }
  return false;
}

bool checkDocumentExists(DocumentData doc, List<Documents> documentsData) {
  return documentsData.any((element) => doc.id == element.documentId);
}

bool isDocumentComplete(DocumentData doc, List<Documents> documentsData) {
  if (!checkDocumentExists(doc, documentsData)) return false;
  final match = documentsData.firstWhere((element) => element.documentId == doc.id);
  return match.documentValue == 2;
}

int checklistCompletedCount(List<DocumentData> docs, List<Documents> documentsData) {
  return docs.where((doc) => isDocumentComplete(doc, documentsData)).length;
}

bool reInspectionDocumentCheck(List<Documents> documentsData) {
  for (final doc in documentsData) {
    if (doc.documentId == 3 ||
        doc.documentId == 4 ||
        doc.documentId == 11 ||
        doc.documentId == 12 ||
        doc.documentId == 13) {
      continue;
    }
    if (doc.documentValue != 2) {
      return false;
    }
  }
  return true;
}
