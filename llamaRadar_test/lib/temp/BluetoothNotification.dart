// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class BluetoothNotification extends StatefulWidget {
//   @override
//   _BluetoothNotificationState createState() => _BluetoothNotificationState();
// }
//
// class _BluetoothNotificationState extends State<BluetoothNotification> {
//   BluetoothDevice? _device;
//   BluetoothService? _service;
//   BluetoothCharacteristic? _characteristic;
//   bool _isConnected = false;
//   List<BluetoothDevice> devices = [];
//
//   List<int> _value = [];
//
//   // Function to connect to the BLE device
//   Future<void> _connectToDevice(String deviceId) async {
//     // Search for the device using its MAC address
//
//     // var devices = await FlutterBluePlus.instance.scan(timeout: Duration(seconds: 4));
//     // var device = devices.firstWhere((d) => d.id.toString() == deviceId, orElse: () => null);
//
//     FlutterBluePlus.instance.scan(
//       timeout: Duration(seconds: 4),
//     );
//
//     BluetoothDevice? device;
//     if (devices.isNotEmpty) {
//       device = devices.firstWhere(
//             (d) => d.id.toString() == deviceId,
//         // orElse: () => null,
//       );
//     }
//
//     if (device == null) {
//       print('Device not found');
//       return;
//     }
//
//     // Connect to the device
//     await device.connect();
//     print('Connected to ${device.name}');
//
//     // Discover services and characteristics
//     List<BluetoothService> services = await device.discoverServices();
//     for (BluetoothService service in services) {
//       List<BluetoothCharacteristic> characteristics = await service.characteristics;
//       for (BluetoothCharacteristic characteristic in characteristics) {
//         if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
//           _service = service;
//           _characteristic = characteristic;
//
//           // Enable notifications for the characteristic
//           await _characteristic!.setNotifyValue(true);
//
//           // Listen to the characteristic notifications
//           _characteristic!.value.listen((value) {
//             setState(() {
//               _value = value;
//             });
//           });
//
//           print('Found characteristic ${characteristic.uuid}');
//           break;
//         }
//       }
//     }
//
//     setState(() {
//       _isConnected = true;
//       _device = device;
//     });
//   }
//
//   // Function to disconnect from the BLE device
//   Future<void> _disconnectFromDevice() async {
//     if (!_isConnected || _device == null) {
//       print('Not connected to a device');
//       return;
//     }
//
//     await _device!.disconnect();
//     print('Disconnected from ${_device!.name}');
//
//     setState(() {
//       _isConnected = false;
//       _device = null;
//       _service = null;
//       _characteristic = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Notification'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: Text('Connect'),
//               onPressed: () async {
//                 await _connectToDevice('94:B5:55:0C:12:AE'); // Replace with the MAC address of your device
//               },
//             ),
//             SizedBox(height: 16),
//             Text('Notification: ${_value.toString()}'),
//             SizedBox(height: 16),
//             ElevatedButton(
//               child: Text('Disconnect'),
//               onPressed: () async {
//                 await _disconnectFromDevice();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class BluetoothNotification extends StatefulWidget {
//   @override
//   _BluetoothNotificationState createState() => _BluetoothNotificationState();
// }
//
// class _BluetoothNotificationState extends State<BluetoothNotification> {
//   BluetoothDevice? _device;
//   BluetoothService? _service;
//   BluetoothCharacteristic? _characteristic;
//   bool _isConnected = false;
//   List<BluetoothDevice> devices = [];
//
//   List<int> _value = [];
//
//   // Function to connect to the BLE device
//   Future<void> _connectToDevice(String deviceId) async {
//     // Search for the device using its MAC address
//     await FlutterBluePlus.instance.scan(timeout: Duration(seconds: 4))
//         .map((scanResult) => scanResult.device)
//         .toList()
//         .then((deviceList) => devices = deviceList);
//     BluetoothDevice? device;
//     if (devices.isNotEmpty) {
//       device = devices.firstWhere((d) => d.id.toString() == deviceId
//           // orElse: () => null);
//       );}
//
//     if (device == null) {
//       print('Device not found');
//       return;
//     }
//
//     // Connect to the device
//     await device.connect();
//     print('Connected to ${device.name}');
//
//     // Discover services and characteristics
//     List<BluetoothService> services = await device.discoverServices();
//     for (BluetoothService service in services) {
//       List<BluetoothCharacteristic> characteristics = await service.characteristics;
//       for (BluetoothCharacteristic characteristic in characteristics) {
//         if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
//           _service = service;
//           _characteristic = characteristic;
//
//           // Enable notifications for the characteristic
//           await _characteristic!.setNotifyValue(true);
//
//           // Listen to the characteristic notifications
//           _characteristic!.value.listen((value) {
//             setState(() {
//               _value = value;
//             });
//           });
//
//           print('Found characteristic ${characteristic.uuid}');
//           break;
//         }
//       }
//     }
//
//     setState(() {
//       _isConnected = true;
//       _device = device;
//     });
//   }
//
//   // Function to disconnect from the BLE device
//   Future<void> _disconnectFromDevice() async {
//     if (!_isConnected || _device == null) {
//       print('Not connected to a device');
//       return;
//     }
//
//     await _device!.disconnect();
//     print('Disconnected from ${_device!.name}');
//
//     setState(() {
//       _isConnected = false;
//       _device = null;
//       _service = null;
//       _characteristic = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Notification'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: Text('Connect'),
//               onPressed: () async {
//                 await _connectToDevice('94:B5:55:0C:12:AE'); // Replace with the MAC address of your device
//               },
//             ),
//             SizedBox(height: 16),
//             Text('Notification: ${_value.toString()}'),
//             SizedBox(height: 16),
//             ElevatedButton(
//               child: Text('Disconnect'),
//               onPressed: () async {
//                 await _disconnectFromDevice();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// check mac address
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothNotification extends StatefulWidget {
  @override
  _BluetoothNotificationState createState() => _BluetoothNotificationState();
}

class _BluetoothNotificationState extends State<BluetoothNotification> {
  BluetoothDevice? _device;
  BluetoothService? _service;
  BluetoothCharacteristic? _characteristic;
  bool _isConnected = false;
  List<BluetoothDevice> devices = [];

  List<int> _value = [];

  // Function to connect to the BLE device
  Future<void> _connectToDevice(String deviceId) async {
    // Validate MAC address format
    final RegExp macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
    if (!macRegex.hasMatch(deviceId)) {
      print('Invalid MAC address: $deviceId');
      return;
    }

    // Search for the device using its MAC address
    await FlutterBluePlus.instance.scan(timeout: Duration(seconds: 4))
        .map((scanResult) => scanResult.device)
        .toList()
        .then((deviceList) => devices = deviceList);

    BluetoothDevice? device;
    if (devices.isNotEmpty) {
      device = devices.firstWhere((d) => d.id.toString() == deviceId
        // orElse: () => null);
      );}

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
      List<BluetoothCharacteristic> characteristics = await service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
          _service = service;
          _characteristic = characteristic;

          // Enable notifications for the characteristic
          await _characteristic!.setNotifyValue(true);

          // Listen to the characteristic notifications
          _characteristic!.value.listen((value) {
            setState(() {
              _value = value;
            });
          });

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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFa8caba), Color(0xFF517fa4)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF517fa4),
            ),
          ),
          title: Text('Bluetooth Notification'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Connect'),
                onPressed: () async {
                  await _connectToDevice('94:B5:55:0C:12:AE'); // Replace with the MAC address of your device
                },
              ),
              SizedBox(height: 16),
              Text('Notification: ${_value.toString()}'),
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
      ),
    );
  }
}
