
import 'package:flutter/cupertino.dart';

import 'auth.dart';

class AuthState extends ChangeNotifier {
  bool _isUpdating = false;
  bool get isUpdatingValue => _isUpdating;

  void changeValue() {
    this._isUpdating = !_isUpdating;
    notifyListeners();
  }
}