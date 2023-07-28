import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RadarNotificationController {
  Future<void> startScan({Duration? timeout}) async {
    // setState(() {
    //   _isScanning = true;
    //   _scanError = null;
    // });

    try {
      await FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
    } catch (e) {
      print("Error starting scan: $e");
      // setState(() {
      //   _scanError = e.toString();
      // });
    }

    // setState(() {
    //   _isScanning = false;
    // });
  }
}