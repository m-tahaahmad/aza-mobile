import 'package:flutter/cupertino.dart';

class DialogProvider extends ChangeNotifier {
  bool isLoading = false;

  set setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
