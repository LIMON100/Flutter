// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class BLEDevicePage extends StatefulWidget {
//   // BluetoothDevice? device;
//
//   const BLEDevicePage({Key? key}) : super(key: key);
//
//   @override
//   _BLEDevicePageState createState() => _BLEDevicePageState();
// }
//
// class _BLEDevicePageState extends State<BLEDevicePage> {
//   late BluetoothDevice _device;
//   BluetoothCharacteristic? _characteristic;
//   Stream<List<int>>? _stream;
//   String _value = '';
//   late BluetoothDevice device;
//
//   @override
//   void initState() {
//     super.initState();
//     // _device = widget.device;
//     _device = device;
//     _connectToDevice();
//   }
//
//   Future<void> _connectToDevice() async {
//     await _device.connect();
//     List<BluetoothService> services = await _device.discoverServices();
//     for (BluetoothService service in services) {
//       List<BluetoothCharacteristic> characteristics = await service.characteristics;
//       for (BluetoothCharacteristic characteristic in characteristics) {
//         if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
//           _characteristic = characteristic;
//
//           // Enable notifications for the characteristic
//           await _characteristic!.setNotifyValue(true);
//
//           // Listen to the characteristic notifications
//           _stream = _characteristic!.value.asBroadcastStream();
//           _stream!.listen((value) {
//             setState(() {
//               _value = String.fromCharCodes(value);
//             });
//           });
//
//           print('Found characteristic ${characteristic.uuid}');
//           break;
//         }
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     if (_characteristic != null) {
//       _characteristic!.setNotifyValue(false);
//     }
//     _device.disconnect();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BLE Device'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Notifications:',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 16),
//             Text(
//               _value,
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEDevicePage extends StatefulWidget {
  final BluetoothDevice device;

  const BLEDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  _BLEDevicePageState createState() => _BLEDevicePageState();
}

class _BLEDevicePageState extends State<BLEDevicePage> {
  late BluetoothDevice _device;
  BluetoothCharacteristic? _characteristic;
  Stream<List<int>>? _stream;
  String _value = '';
  // BluetoothService? _service;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _connectToDevice();
  }

  Future<void> _connectToDevice() async {
    // await _device.connect();
    // List<BluetoothService> services = await _device.discoverServices();
    // for (BluetoothService service in services) {
    //   List<BluetoothCharacteristic> characteristics = await service.characteristics;
    //   for (BluetoothCharacteristic characteristic in characteristics) {
    //     if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
    //       _characteristic = characteristic;
    //
    //       // Enable notifications for the characteristic
    //       await _characteristic!.setNotifyValue(true);
    //
    //       // Listen to the characteristic notifications
    //       _stream = _characteristic!.value.asBroadcastStream();
    //       _stream!.listen((value) {
    //         setState(() {
    //           _value = String.fromCharCodes(value);
    //         });
    //       });
    //
    //       print('Found characteristic ${characteristic.uuid}');
    //       break;
    //     }
    //   }
    // }
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = await service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
          // _service = service;
          _characteristic = characteristic;

          // Enable notifications for the characteristic
          await _characteristic!.setNotifyValue(true);

          // Listen to the characteristic notifications
          _characteristic!.value.listen((value) {
            setState(() {
              _value = value.toString();
            });
          });

          print('Found characteristic ${characteristic.uuid}');
          break;
        }
      }
    }
    setState(() {
      _device = widget.device;
    });
  }

  @override
  void dispose() {
    if (_characteristic != null) {
      _characteristic!.setNotifyValue(false);
    }
    _device.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Device'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notifications:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              _value,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
