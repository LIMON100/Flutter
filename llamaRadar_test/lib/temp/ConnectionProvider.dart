import 'package:flutter/foundation.dart';

class ConnectionProvider extends ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void setConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }
}
