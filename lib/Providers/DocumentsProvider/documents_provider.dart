import 'package:flutter/cupertino.dart';

import '../../Model/DocumentsModel/document_response_model.dart';

class DocumentsProvider extends ChangeNotifier {
  DocumentResponseModel? _documentResponseModel;

  DocumentResponseModel? get documentResponseModel => _documentResponseModel;

  int? progress;

  set setAllDocument(DocumentResponseModel responseModel) {
    _documentResponseModel = responseModel;
    notifyListeners();
  }

  setProgress(int value) {
    progress = value;
    notifyListeners();
  }
}
