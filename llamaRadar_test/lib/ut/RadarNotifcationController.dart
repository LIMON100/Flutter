import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
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
}