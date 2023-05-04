// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// // import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class BLEScannerScreen extends StatefulWidget {
//   @override
//   _BLEScannerScreenState createState() => _BLEScannerScreenState();
// }
//
// class _BLEScannerScreenState extends State<BLEScannerScreen> {
//   // List<ScanResult> results = [];
//   //
//   // BluetoothDevice? device;
//   // BluetoothState? state;
//   // BluetoothDeviceState? deviceState;
//   // Future<bool>? locationServiceEnabled;
//   // PermissionStatus? permissionGranted;
//   // LocationData? locationData;
//   //
//   // void _showDialog(String message) {
//   //   // flutter defined function
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       // return object of type Dialog
//   //       return AlertDialog(
//   //         title: new Text("Bluetooth"),
//   //         content: new Text(message),
//   //         actions: <Widget>[
//   //           new ElevatedButton(
//   //             child: new Text("Close"),
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//   //
//   // Widget getBLEList(results) {
//   //   return Container(
//   //     height: 300.0, // Change as per your requirement
//   //     width: 300.0, // Change as per your requirement
//   //     child: new ListView.builder(
//   //       shrinkWrap: true,
//   //       itemCount: results.length,
//   //       itemBuilder: (BuildContext context, int index) {
//   //         return new Text(
//   //             '${results[index].device.id}.. rssi: ${results[index].rssi}');
//   //       },
//   //     ),
//   //   );
//   // }
//   //
//   // void _showListDialog(results) {
//   //   // flutter defined function
//   //   if (results.length > 0) {
//   //     showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         // return object of type Dialog
//   //         return AlertDialog(
//   //           title: new Text("BLE device list"),
//   //           content: getBLEList(results),
//   //           actions: <Widget>[
//   //             new ElevatedButton(
//   //               child: new Text("Close"),
//   //               onPressed: () {
//   //                 Navigator.of(context).pop();
//   //               },
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     );
//   //   }
//   // }
//   //
//   // void initState() {
//   //   super.initState();
//   //   Location location = new Location();
//   //   locationServiceEnabled = location.serviceEnabled();
//   //
//   //   if (locationServiceEnabled == null) {
//   //     _showDialog('Please switch on your GPS');
//   //   }
//   //
//   //   List<ScanResult> resultsList = [];
//   //   FlutterBlue flutterBlue = FlutterBlue.instance;
//   //   flutterBlue.startScan(timeout: Duration(seconds: 4));
//   //
//   //   flutterBlue.state.listen((state) {
//   //     if (state == BluetoothState.off) {
//   //       _showDialog('Please switch on your bluetooth.');
//   //     } else if (state == BluetoothState.on) {
//   //       flutterBlue.scanResults.listen((results) {
//   //         for (ScanResult r in results) {
//   //           resultsList.add(r);
//   //         }
//   //       });
//   //       setState(() {
//   //         results = resultsList;
//   //       });
//   //
//   //       //_showListDialog(resultsList);
//   //     }
//   //   });
//   //
//   //   flutterBlue.stopScan();
//   // }
//   //
//   // void scanForDevices() async {}
//   //
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: Text("BLE TEST"),
//   //     ),
//   //     body: Center(
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: <Widget>[
//   //           Text(
//   //             'Device list:',
//   //           ),
//   //           Container(
//   //             height: 300.0, // Change as per your requirement
//   //             width: 300.0, // Change as per your requirement
//   //             child: new ListView.builder(
//   //               shrinkWrap: true,
//   //               itemCount: results.length,
//   //               itemBuilder: (BuildContext context, int index) {
//   //                 return new Text(
//   //                     '${results[index].device.id}.. rssi: ${results[index].rssi}');
//   //               },
//   //             ),
//   //           )
//   //         ],
//   //       ),
//   //     ),
//   //     floatingActionButton: FloatingActionButton(
//   //       onPressed: null,
//   //       tooltip: 'Increment',
//   //       child: Icon(Icons.add),
//   //     ),
//   //   );
//   // }
//   List<ScanResult> scanResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }
//
//   // Future<void> requestPermissions() async {
//   //   final PermissionStatus status = await Permission.bluetooth.status;
//   //   if (status != PermissionStatus.granted) {
//   //     await Permission.bluetooth.request();
//   //   }
//   //   final PermissionStatus scanStatus = await Permission.locationWhenInUse.status;
//   //   if (scanStatus != PermissionStatus.granted) {
//   //     await Permission.locationWhenInUse.request();
//   //   }
//   // }
//
//   Future<void> requestPermissions() async {
//     final Map<Permission, PermissionStatus> status = await [
//       Permission.bluetooth,
//       Permission.locationWhenInUse,
//     ].request();
//
//     if (status[Permission.bluetooth] != PermissionStatus.granted) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text('Bluetooth permission denied'),
//           content: Text('Please grant Bluetooth permission in settings to use this feature.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//
//     if (status[Permission.locationWhenInUse] != PermissionStatus.granted) {
//       // Handle location permission denied
//     }
//   }
//
//   Future<void> startScan() async {
//     FlutterBlue flutterBlue = FlutterBlue.instance;
//     scanResults.clear();
//     flutterBlue.scanResults.listen((results) {
//       setState(() {
//         scanResults = results;
//       });
//     });
//     flutterBlue.startScan();
//   }
//
//   Future<void> stopScan() async {
//     FlutterBlue flutterBlue = FlutterBlue.instance;
//     flutterBlue.stopScan();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Devices'),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           ElevatedButton(
//             onPressed: startScan,
//             child: Text('Scan'),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: scanResults.length,
//               itemBuilder: (BuildContext context, int index) {
//                 ScanResult result = scanResults[index];
//                 return ListTile(
//                   title: Text(result.device.name),
//                   subtitle: Text(result.device.id.toString()),
//                   trailing: Text('${result.rssi} dBm'),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: stopScan,
//         child: Icon(Icons.stop),
//       ),
//     );
//   }
// }
