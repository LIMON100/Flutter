// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class BleWriteTest extends StatefulWidget {
//   const BleWriteTest({Key? key}) : super(key: key);
//
//   @override
//   _BleWriteTestState createState() => _BleWriteTestState();
// }
//
// class _BleWriteTestState extends State<BleWriteTest> {
//   late BluetoothDevice device;
//   BluetoothCharacteristic? characteristic;
//   bool isDataMatched = false;
//
//   String _value = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _connectToDevice();
//   }
//
//   Future<void> _connectToDevice() async {
//     // Scan for the device with the specified name
//     final devices = await FlutterBluePlus.instance.scan(timeout: Duration(seconds: 4))
//         .map((scanResult) => scanResult.device)
//         .where((device) => device.name == 'LLama Radar')
//         .toList();
//
//     if (devices.isNotEmpty) {
//       device = devices.first;
//       // Connect to the device
//       await device.connect();
//       // Discover the services and characteristics of the device
//       final services = await device.discoverServices();
//       // workable part
//       for (final service in services) {
//         for (final c in service.characteristics) {
//           print("Check the uuod first...............");
//           print(c.uuid.toString());
//           if (c.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a7') {
//             characteristic = c;
//             // break;
//           }
//         }
//         if (characteristic != null) {
//           break;
//         }
//       }
//       // try another
//       // for (BluetoothService service in services) {
//       //   for (BluetoothCharacteristic characteristic
//       //   in service.characteristics) {
//       //     // Find the notify characteristic
//       //     if (characteristic.uuid.toString() ==
//       //         'beb5483e-36e1-4688-b7f5-ea07361b26a8') {
//       //       _notifyCharacteristic = characteristic;
//       //       // Enable notifications for the notify characteristic
//       //       await _notifyCharacteristic!.setNotifyValue(true);
//       //       // Listen to the characteristic notifications
//       //       _notifyStream = characteristic!.value;
//       //       _notifyStream!.listen((value) {
//       //         setState(() {
//       //           _value = value.toString();
//       //         });
//       //       });
//       //     }
//       //     // Find the write characteristic
//       //     else if (characteristic.uuid.toString() ==
//       //         'beb5483e-36e1-4688-b7f5-ea07361b26a7') {
//       //       _writeCharacteristic = characteristic;
//       //     }
//       //   }
//       // }
//     }
//   }
//
//   Future<void> _sendData() async {
//     if (characteristic != null) {
//       // final dataToSend = [0x02, 0x01, 0x10, 0xA, 0x02, 0x15, 0xF];
//       final dataToSend = [0x02, 0x01, 0xC, 0x01, 0x10];
//       // await characteristic!.write(dataToSend);
//       await characteristic!.write(utf8.encode(dataToSend.toString()));
//       // Wait for the response from the BLE device
//       final response = await characteristic!.value.first;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(''),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _sendData,
//               // onPressed: showInfo,
//               child: const Text('Right button pressed'),
//             ),
//             const SizedBox(height: 16),
//             Text('Received Value: $_value'),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleWriteTest extends StatefulWidget {
  BleWriteTest({Key? key}) : super(key: key);

  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};

  @override
  _BleWriteTestState createState() => _BleWriteTestState();
}

class _BleWriteTestState extends State<BleWriteTest> {
  final _writeController = TextEditingController();
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];
  String _value = '';

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  ListView _buildListViewOfDevices() {
    List<Widget> containers = <Widget>[];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        SizedBox(
          height: 50,
          child: Row(
            children: <Widget>[
              // Show available BLE connection
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              TextButton(
                child: const Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  widget.flutterBlue.stopScan();
                  try {
                    await device.connect();
                  } on PlatformException catch (e) {
                    if (e.code != 'already_connected') {
                      rethrow;
                    }
                  } finally {
                    _services = await device.discoverServices();
                  }
                  setState(() {
                    _connectedDevice = device;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];

    // Future<void> _sendData() async {
    //   if (characteristic != null) {
    //     // final dataToSend = [0x02, 0x01, 0x10, 0xA, 0x02, 0x15, 0xF];
    //     final dataToSend = [0x02, 0x01, 0xA, 0x01, 0xE];
    //     // await characteristic!.write(dataToSend);
    //     await characteristic!.write(utf8.encode(dataToSend.toString()));
    //     // Wait for the response from the BLE device
    //     final response = await characteristic!.value.first;
    //   }
    // }

    //BYTE ARRAY
    Future<void> _sendData() async {
      if (characteristic != null) {
        final dataToSend = [0x02, 0x01, 0xD, 0x01, 0x11];
        List<int> byteData = utf8.encode(dataToSend.toString());
        await characteristic!.write(byteData);
        // Wait for the response from the BLE device
        final response = await characteristic!.value.first;
      }
    }

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: const Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: _sendData,
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child:
              const Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                    _value = value.toString();
                  });
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Widget> containers = <Widget>[];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = <Widget>[];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        containers.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ${widget.readValues[characteristic.uuid]}'),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      }
      // containers.add(
      //   ExpansionTile(
      //       title: Text(service.uuid.toString()),
      //       children: characteristicsWidget),
      // );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
      // return buildCharacteristicWidget();
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(''),
    ),
    body: _buildView(),
  );
}


// write+notify

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class BleWriteTest extends StatefulWidget {
//   const BleWriteTest({Key? key}) : super(key: key);
//
//   @override
//   _BleWriteTestState createState() => _BleWriteTestState();
// }
//
// class _BleWriteTestState extends State<BleWriteTest> {
//   late BluetoothDevice _device;
//   BluetoothCharacteristic? _notifyCharacteristic;
//   BluetoothCharacteristic? _writeCharacteristic;
//   Stream<List<int>>? _notifyStream;
//   String _value = '';
//   bool _isDataMatched = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeBluetooth();
//   }
//
//   Future<void> _initializeBluetooth() async {
//     FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//     // Scan for the device with the specified name
//     Stream<ScanResult> scanResults =
//     flutterBlue.scan(timeout: Duration(seconds: 4));
//     await for (ScanResult result in scanResults) {
//       if (result.device.name == 'LLama Radar') {
//         BluetoothDevice device = result.device;
//         // Connect to the device
//         await device.connect();
//         // Discover services and characteristics
//         List<BluetoothService> services = await device.discoverServices();
//         for (BluetoothService service in services) {
//           for (BluetoothCharacteristic characteristic
//           in service.characteristics) {
//             // Find the notify characteristic
//             if (characteristic.uuid.toString() ==
//                 'beb5483e-36e1-4688-b7f5-ea07361b26a8') {
//               _notifyCharacteristic = characteristic;
//               // Enable notifications for the notify characteristic
//               await _notifyCharacteristic!.setNotifyValue(true);
//               // Listen to the characteristic notifications
//               _notifyStream = _notifyCharacteristic!.value;
//               _notifyStream!.listen((value) {
//                 setState(() {
//                   // _value = utf8.decode(value);
//                   _value = value.toString();
//                   // Check if the received value matches the expected value
//                   // _isDataMatched = _value == 'Your Expected Value';
//                 });
//               });
//             }
//             // Find the write characteristic
//             else if (characteristic.uuid.toString() ==
//                 'beb5483e-36e1-4688-b7f5-ea07361b26a7') {
//               _writeCharacteristic = characteristic;
//             }
//           }
//         }
//         setState(() {
//           _device = device;
//         });
//         break;
//       }
//     }
//   }
//
//   Future<void> _sendData() async {
//     if (_writeCharacteristic != null) {
//       final dataToSend = [0x02, 0x01, 0xC, 0x01, 0x10];
//       await _writeCharacteristic!.write(utf8.encode(dataToSend.toString()));
//       // final dataToSend = utf8.encode('Your Data to Send');
//       // await _writeCharacteristic!.write(dataToSend);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BLE Notify/Write Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _sendData,
//               child: Text('Send Data'),
//             ),
//             SizedBox(height: 16),
//             Text('Received Value: $_value'),
//             SizedBox(height: 16),
//             if (_isDataMatched)
//               Text('Data Matched')
//             else
//               Text('Data Not Matched'),
//           ],
//         ),
//       ),
//     );
//   }
// }
