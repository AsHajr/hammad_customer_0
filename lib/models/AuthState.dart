
import 'package:flutter/cupertino.dart';

class AuthUpdating extends ChangeNotifier {
  bool _isUpdating = false;
  bool get isUpdatingValue => _isUpdating;

  void changeToTrue() {
    _isUpdating = true;
    notifyListeners();
  }
  void changeToFalse() {
    _isUpdating = false;
    notifyListeners();
  }
}