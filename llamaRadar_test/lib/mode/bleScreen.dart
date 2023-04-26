import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BleScreen extends StatefulWidget {
  const BleScreen({Key? key}) : super(key: key);

  @override
  _BleScreenState createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen> {
  late FlutterBlue flutterBlue;
  late BluetoothDevice targetDevice;
  bool isConnected = false;
  late BluetoothCharacteristic targetCharacteristic;

  @override
  void initState() {
    super.initState();
    flutterBlue = FlutterBlue.instance;
    connectToDevice();
  }

  Future<void> connectToDevice() async {
    // var status = await Permission.bluetoothScan.request();
    // if (status == PermissionStatus.granted) {
    try {
      // Start scanning for devices with the specified service ID
      flutterBlue.scan(
        timeout: Duration(seconds: 4),
        withServices: [Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b")],
      ).listen((scanResult) async {
        // Check if the target device is found
        if (scanResult.device.name == "Target Device") {
          targetDevice = scanResult.device;
          // Connect to the target device
          await targetDevice.connect();
          // Discover services and characteristics
          List<BluetoothService> services = await targetDevice
              .discoverServices();
          services.forEach((service) {
            if (service.uuid ==
                Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b")) {
              service.characteristics.forEach((characteristic) {
                if (characteristic.uuid ==
                    Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8")) {
                  targetCharacteristic = characteristic;
                }
              });
            }
          });
          setState(() {
            isConnected = true;
          });
        }
      });
    } catch (e) {
      print("Error connecting to device: $e");
    }

    // else{
    //   print("PERMISSION DENIED");
    // }
  }

  Future<void> disconnectFromDevice() async {
    try {
      await targetDevice.disconnect();
      setState(() {
        isConnected = false;
      });
    } catch (e) {
      print("Error disconnecting from device: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLE"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isConnected ? "Connected to device" : "Not connected to device",
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(isConnected ? "Disconnect" : "Connect"),
              onPressed: isConnected ? disconnectFromDevice : connectToDevice,
            ),
          ],
        ),
      ),
    );
  }
}
