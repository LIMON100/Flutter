import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'bluetooth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';
import 'package:protobuf/protobuf.dart' as protos;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FlutterBlue flutterBlue = FlutterBlue.instance;

  late BluetoothDevice device;
  BluetoothService? service;
  BluetoothCharacteristic? characteristic;

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  Future<void> _scanForDevices() async {
    flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == 'ESP32') {
        setState(() {
          device = scanResult.device;
        });
      }
    });
  }

  Future<void> _connectToDevice() async {
    if (device == null) return;
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((s) {
      if (s.uuid.toString() == '4fafc201-1fb5-459e-8fcc-c5c9c331914b') {
        service = s;
        characteristic = s.characteristics.firstWhere(
                (c) => c.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8');
      }
    });
  }

  Future<void> _disconnectDevice() async {
    if (device == null) return;
    await device.disconnect();
  }

  Future<void> _sendData(String data) async {
    if (characteristic == null) {
      print('characteristic is null, cannot send data');
      return;
    }
    List<int> bytes = utf8.encode(data);
    await characteristic!.write(bytes);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('ESP32 BLE')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _connectToDevice,
                child: Text('Connect to BLE'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _disconnectDevice,
                child: Text('Disconnect BLE'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _sendData('Hello from Flutter!'),
                child: Text('Send Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}