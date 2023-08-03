import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mockito/mockito.dart';


class RadarNotificationController {
  BluetoothCharacteristic? characteristic_write;
  BluetoothCharacteristic? characteristic;
  String _value = '';
  // BluetoothDevice? device;
  bool isDisconnected = false;
  final BluetoothDevice device;

  // blinking variable
  Timer? _leftBlinkTimer;
  Timer? _rightBlinkTimer;
  bool isLeftBlinking = false;
  bool isRightBlinking = false;

  RadarNotificationController(this.device);

  // Disconnect
  Future<bool> performDisconnection() async {
    try{
      isDisconnected = true;
      await device!.disconnect();
      print('Disconnected from ${device!.name}');
      return true;
    }
    catch(e){
      return false;
    }
  }

  // Send data
  Future<void> connectAndSendCommand() async {
    // Connect to the BLE device (Assuming already connected)
    // await device.connect();

    // Discover services and characteristics
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = await service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a7') {
          await _sendData(characteristic, [0x02, 0x01, 0x0A, 0x01, 0x0E]);
        }
      }
    }
  }

  Future<void> _sendData(BluetoothCharacteristic characteristic, List<int> dataToSend) async {
    if (characteristic != null) {
      await characteristic.write(Uint8List.fromList(dataToSend));
      // Wait for the response from the BLE device (if needed)
      final response = await characteristic.value.first;
      // Process the response (if needed)
    }
  }

  // Right and left blinking
  List<dynamic> startLeftBlinking() {
    if (_leftBlinkTimer != null) {
      _leftBlinkTimer!.cancel();
      _leftBlinkTimer = null;
      isLeftBlinking = false;
      return [false, isLeftBlinking];
    } else {
      _leftBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
        isLeftBlinking = !isLeftBlinking;
      });
      // Stop the blinking after 3 seconds
      Future.delayed(Duration(seconds: 3)).then((_) {
        _leftBlinkTimer?.cancel();
        isLeftBlinking = false;
      });
      return [true, isLeftBlinking];
    }
  }

  // Right blinking
  List<dynamic> startRightBlinking() {
    if (_rightBlinkTimer != null) {
      _rightBlinkTimer!.cancel();
      _rightBlinkTimer = null;
      isRightBlinking = false;
      return [false, isRightBlinking];
    }
    else {
      _rightBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
        isRightBlinking = !isRightBlinking;
      });
      // Stop the blinking after 3 seconds
      Future.delayed(Duration(seconds: 30)).then((_) {
        _rightBlinkTimer?.cancel();
        isRightBlinking = false;
      });
      return [false, isRightBlinking];
    }
  }

  // Warning text
  String value = '';
  String get new_value => value;
  set new_value(String newValue) {
    value = newValue;
  }

  String getLocation(String value) {
    if (value == '') {
      return 'Notification Not Available';
    }
    switch (int.parse(value)) {
      case 1:
        return 'Right Notification Warning';
      case 2:
        return 'Right Notification Danger';
      case 3:
        return 'Left Notification Warning';
      case 4:
        return 'Left Notification Danger';
      case 5:
        return 'Rear Notification Danger';
      default:
        return '';
    }
  }

  // Left icon check
  bool isBlinkingIcon1 = false;
  bool isBlinkingIcon2 = false;
  bool isBlinkingIcon3 = false;

  Future<List<bool>> startBlinking3(String value) {
    Completer<List<bool>> completer = Completer<List<bool>>();
    Timer? _blinkTimer;
    bool isBlinking = false;

    _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      int parsedValue = int.tryParse(value) ?? 0;

      // When the value is 3, isBlinkingIcon2 and isBlinkingIcon3 will return false
      if (parsedValue == 3) {
        isBlinkingIcon1 = true;
        isBlinkingIcon2 = false;
        isBlinkingIcon3 = false;
        completer.complete([isBlinkingIcon1, isBlinkingIcon2, isBlinkingIcon3]);
        _blinkTimer?.cancel();
        return;
      }
      // When the value is 6, isBlinkingIcon1 and isBlinkingIcon3 will return false
      else if (parsedValue == 6) {
        isBlinkingIcon1 = false;
        isBlinkingIcon2 = true;
        isBlinkingIcon3 = false;
        completer.complete([isBlinkingIcon1, isBlinkingIcon2, isBlinkingIcon3]);
        _blinkTimer?.cancel();
        return;
      }
      // When the value is 9, isBlinkingIcon2 and isBlinkingIcon1 will return false
      else if (parsedValue == 9) {
        isBlinkingIcon1 = false;
        isBlinkingIcon2 = false;
        isBlinkingIcon3 = true;
        completer.complete([isBlinkingIcon1, isBlinkingIcon2, isBlinkingIcon3]);
        _blinkTimer?.cancel();
        return;
      }

      isBlinkingIcon1 = (parsedValue == 3) ? !isBlinkingIcon1 : false;
      isBlinkingIcon2 = (parsedValue == 6) ? !isBlinkingIcon2 : false;
      isBlinkingIcon3 = (parsedValue == 9) ? !isBlinkingIcon3 : false;

      isBlinking = !isBlinking;
    });

    // Return the Future from the Completer
    return completer.future;
  }

  // void startBlinking3(String value) {
  //   Timer _blinkTimer;
  //   bool isBlinking = false;
  //
  //   _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
  //     isBlinkingIcon1 = (int.tryParse(value) == 3) ? !isBlinkingIcon1 : false;
  //     isBlinkingIcon2 = (int.tryParse(value) == 6) ? !isBlinkingIcon2 : false;
  //     isBlinkingIcon3 = (int.tryParse(value) == 9) ? !isBlinkingIcon3 : false;
  //     isBlinking = !isBlinking;
  //   });
  //   // Stop the blinking after 3 seconds
  //   Future.delayed(Duration(seconds: 3)).then((_) {
  //     _blinkTimer?.cancel();
  //     isBlinking = false;
  //   });
  // }
}