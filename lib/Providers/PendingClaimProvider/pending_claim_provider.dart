import 'package:flutter/cupertino.dart';
import 'package:icms_app/Model/PendingClaims/pending_claim_response_model.dart';

class PendingClaimProvider extends ChangeNotifier {
  PendingClaimResponseModel? _pendingClaimResponseModel;

  PendingClaimResponseModel? get pendingClaimResponseModel => _pendingClaimResponseModel;

  set setPendingClaimResponseModel(PendingClaimResponseModel responseModel) {
    _pendingClaimResponseModel = responseModel;
    notifyListeners();
  }

  resetProvider() {
    pendingClaimResponseModel!.data = null;
    notifyListeners();
  }
}
