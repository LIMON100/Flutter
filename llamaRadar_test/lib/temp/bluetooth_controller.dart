// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:get/get.dart';
//
// class BluetoothController extends GetxController {
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//
//   Future scanDevices() async {
//     // Start scanning
//     flutterBlue.startScan(timeout: const Duration(seconds: 5));
//
// // Listen to scan results
//     var subscription = flutterBlue.scanResults.listen((results) {
//       // do something with scan results
//       for (ScanResult r in results) {
//         print('${r.device.name} found! rssi: ${r.rssi}');
//       }
//     });
//     print('subscription: $subscription');
//     // Stop scanning
//     flutterBlue.stopScan();
//   }
//
//   // scan result stream
//   Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
//
//   // connect to device
//   Future<void> connectToDevice(BluetoothDevice device) async {
//     await device.connect();
//   }
//
// }