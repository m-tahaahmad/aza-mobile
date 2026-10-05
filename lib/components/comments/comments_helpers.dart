import 'package:icms_app/Model/CustomersDataModel/customer_detail_response_model.dart';
import 'package:icms_app/constants/globals.dart';

bool commentsFieldsReadOnly() {
  return claimsType == 'Waiting for approval' ||
      claimsType == 'Docs Pending' ||
      claimsType == 'Reports Pending';
}

bool hasRequiredMobileComment(List<Comments> comments) {
  Comments? latestNonMobile;

  for (final comment in comments) {
    if (comment.sender == 'mobile') {
      continue;
    }

    if (latestNonMobile == null || _isCommentNewer(comment, latestNonMobile)) {
      latestNonMobile = comment;
    }
  }

  for (final comment in comments) {
    if (comment.sender != 'mobile') {
      continue;
    }

    if (comment.message?.trim().isEmpty ?? true) {
      continue;
    }

    if (latestNonMobile == null || _isCommentNewer(comment, latestNonMobile)) {
      return true;
    }
  }

  return false;
}

bool _isCommentNewer(Comments candidate, Comments reference) {
  final candidateTime = DateTime.tryParse(candidate.createdAt ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
  final referenceTime = DateTime.tryParse(reference.createdAt ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);

  if (candidateTime.isAfter(referenceTime)) {
    return true;
  }

  if (candidateTime.isBefore(referenceTime)) {
    return false;
  }

  return (candidate.id ?? 0) > (reference.id ?? 0);
}

bool shouldShowAuthorName({
  required int index,
  required int total,
  required int? currentUserId,
  required int? nextUserId,
}) {
  if (index == total - 1) return true;
  return nextUserId != currentUserId;
}
