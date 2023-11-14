import 'package:flutter/material.dart';

class PopupWindowProvider extends ChangeNotifier {
  bool _ispopupwindowEnabled = false;

  bool get isPopupWindowEnabled => _ispopupwindowEnabled;

  void setPopupWindowEnabled(bool value) {
    _ispopupwindowEnabled = value;
    notifyListeners();
  }
}


