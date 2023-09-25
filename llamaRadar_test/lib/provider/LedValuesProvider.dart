import 'package:flutter/material.dart';

class LedValuesProvider with ChangeNotifier {
  double leftLedValue = 50.0;
  double rightLedValue = 50.0;
  double turnOnTime = 3.0;
  double turnOffTime = 10.0;

  void updateLeftLedValue(double value) {
    leftLedValue = value;
    notifyListeners();
  }

  void updateRightLedValue(double value) {
    rightLedValue = value;
    notifyListeners();
  }

  void updateTurnOnTime(double value) {
    turnOnTime = value;
    notifyListeners();
  }

  void updateTurnOffTime(double value) {
    turnOffTime = value;
    notifyListeners();
  }

  void resetLedValues() {
    rightLedValue = 50.0;
    leftLedValue = 50.0;
    turnOnTime = 3.0;
    turnOffTime = 30.0;
    notifyListeners();
  }
}
