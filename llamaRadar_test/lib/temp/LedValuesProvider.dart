import 'package:flutter/material.dart';

class LedValuesProvider with ChangeNotifier {
  double leftLedValue = 50.0;
  double rightLedValue = 50.0;

  void updateLeftLedValue(double value) {
    leftLedValue = value;
    notifyListeners();
  }

  void updateRightLedValue(double value) {
    rightLedValue = value;
    notifyListeners();
  }

  void resetLedValues() {
    rightLedValue = 50.0;
    leftLedValue = 50.0;
    notifyListeners();
  }
}
