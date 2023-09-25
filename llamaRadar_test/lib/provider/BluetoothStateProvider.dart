import 'package:flutter/material.dart';

class BluetoothStateProvider with ChangeNotifier {
  bool _isBluetoothEnabled = true;

  bool get isBluetoothEnabled => _isBluetoothEnabled;

  void setBluetoothEnabled(bool value) {
    _isBluetoothEnabled = value;
    notifyListeners();
  }
}
