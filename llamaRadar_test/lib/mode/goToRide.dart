import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lamaradar/temp/CollisionWarningPage3.dart';
import 'package:lamaradar/temp/glowing_button.dart';
import 'package:lamaradar/temp/BLEDevicePage.dart';
import 'package:lamaradar/temp/CollisionWarningPage2.dart';

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';

class GoToRide extends StatefulWidget {
  final BluetoothDevice device;

  const GoToRide({Key? key, required this.device}) : super(key: key);

  @override
  _GoToRideState createState() => _GoToRideState();
}


class _GoToRideState extends State<GoToRide> {
  BluetoothDevice? _connectedDevice;
  bool _isDisconnected = false;

  // BLE disconnect
  void _disconnectFromDevice() {

    setState(() {
      _isDisconnected = true;
    });

    // Perform the disconnection logic asynchronously
    _performDisconnection();
  }

  Future<void> _performDisconnection() async {
    await widget.device.disconnect();
    print('Disconnected from ${widget.device.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFa8caba), Color(0xFF517fa4)],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.black,
          title: Text('Ride'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2580B3),
            ),
          ),
          actions: [
            SizedBox(height: 1),
            GlowingButton2(
              text: _isDisconnected ? "Disconnected" : "Disconnect",
              onPressed: _disconnectFromDevice,
              color1: Color(0xFF2580B3),
              color2: Color(0xFF2580B3),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Your widget content
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GlowingButton2(
                  text: "Turn on wifi & Go to ride",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CollisionWarningPage2(device: widget.device)),
                    );
                  },
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
