import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lamaradar/sideBar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController extends StatefulWidget {
  @override
  _BluetoothControllerState createState() => _BluetoothControllerState();
}

class _BluetoothControllerState extends State<BluetoothController> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });
    flutterBlue.startScan();
  }

  void _stopScan() {
    flutterBlue.stopScan();
  }

  @override
  void dispose() {
    _stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Scanner'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _stopScan,
              child: Text(
                'Stop Scan',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (BuildContext context, int index) {
                ScanResult result = scanResults[index];
                BluetoothDevice device = result.device;
                String macAddress = device.id.toString();

                return ListTile(
                  title: Text(device.name ?? 'Unknown'),
                  subtitle: Text(macAddress),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
