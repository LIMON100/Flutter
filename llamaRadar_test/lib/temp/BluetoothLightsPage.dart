import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:collection/collection.dart';

class BluetoothLightsPage extends StatefulWidget {
  @override
  _BluetoothLightsPageState createState() => _BluetoothLightsPageState();
}

class _BluetoothLightsPageState extends State<BluetoothLightsPage> {
  BluetoothDevice? _device;
  BluetoothService? _service;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;
  List<BluetoothDevice> devices = [];

  // Function to connect to the BLE device
  Future<void> _connectToDevice(String deviceId) async {
    // Search for the device using its MAC address
    // var devices = await FlutterBluePlus.instance.scan(
    //     timeout: Duration(seconds: 4));
    // var device = devices.firstWhereOrNull((d) => d.id.toString() == deviceId);

    FlutterBluePlus.instance.scan(
      timeout: Duration(seconds: 4),
    );
    // var device = devices.firstWhereOrNull((d) => d.id.toString() == deviceId);

    BluetoothDevice? device;
    if (devices.isNotEmpty) {
      device = devices.firstWhere(
            (d) => d.id.toString() == deviceId,
        // orElse: () => null,
      );
    }

    if (device == null) {
      print('Device not found');
      return;
    }

    // Connect to the device
    await device.connect();
    print('Connected to ${device.name}');

    // Discover services and characteristics
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = await service
          .characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.uuid.toString() ==
            'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
          _service = service;
          _characteristic = characteristic;
          print('Found characteristic ${characteristic.uuid}');
          break;
        }
      }
    }

    setState(() {
      _isConnected = true;
      _device = device;
    });
  }

  // Function to send command to turn the lights on/off
  Future<void> _sendCommand(bool isOn) async {
    if (!_isConnected || _characteristic == null) {
      print('Not connected to a device or characteristic not found');
      return;
    }

    // Send the command to turn the lights on/off
    List<int> command = isOn ? [0x01] : [
      0x00
    ]; // Replace with the command for your device
    await _characteristic!.write(command);
    print('Command sent: $command');
  }

  // Function to disconnect from the BLE device
  Future<void> _disconnectFromDevice() async {
    if (!_isConnected || _device == null) {
      print('Not connected to a device');
      return;
    }

    await _device!.disconnect();
    print('Disconnected from ${_device!.name}');

    setState(() {
      _isConnected = false;
      _device = null;
      _service = null;
      _characteristic = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Lights'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Connect'),
              onPressed: () async {
                await _connectToDevice(
                    '94:B5:55:0C:12:AE'); // Replace with the MAC address of your device
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Turn On'),
              onPressed: () async {
                await _sendCommand(true);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Turn Off'),
              onPressed: () async {
                await _sendCommand(false);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Disconnect'),
              onPressed: () async {
                await _disconnectFromDevice();
              },
            ),
          ],
        ),
      ),
    );
  }
}
