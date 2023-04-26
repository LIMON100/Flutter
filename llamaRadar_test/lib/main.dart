// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'SideBar.dart';
// import 'qrviewexample.dart';
// import 'package:wifi/wifi.dart';
// import 'package:wifi_info_flutter/wifi_info_flutter.dart';
//
//
// // void main() => runApp(const MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     home: MyHome()));
//
// void main() {
//   runApp(MaterialApp(
//     home: WifiPage(),
//   ));
// }
//
// // class MyHome extends StatelessWidget {
// //   const MyHome({Key? key}) : super(key: key);
// //
// //   List<WifiNetwork> _wifiList = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getWifiList();
// //   }
// //
// //   void _getWifiList() async {
// //     List<WifiNetwork> list = await Wifi.list('');
// //     setState(() {
// //       _wifiList = list;
// //     });
// //   }
// //
// //   void _connectToWifi(String ssid) async {
// //     await Wifi.connection(ssid, '', false);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       drawer: SideBar(),
// //
// //       appBar: AppBar(
// //         centerTitle: true,
// //         foregroundColor: Colors.black,
// //         title: const Text('LLama'),
// //         flexibleSpace: Container(
// //           decoration: BoxDecoration(
// //             // color: Color(0xFF6497d3),
// //             color: Color(0xFF2580B3),
// //           ),
// //         ),
// //       ),
// //         // backgroundColor: Colors.lightBlue,),
// //
// //       backgroundColor: Colors.white,
// //       // body: Center(
// //       //   child: Container(
// //       //     height: 500,
// //       //     width: 500,
// //       //     child: Image.asset('images/test.jpg',
// //       //       fit: BoxFit.fill,
// //       //       width: MediaQuery.of(context).size.width,
// //       //       height: MediaQuery.of(context).size.height,
// //       //     ),
// //       //   ),
// //       // ),
// //     );
// //   }
// // }
//


//Test
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// class BLEPage extends StatefulWidget {
//   @override
//   _BLEPageState createState() => _BLEPageState();
// }
//
// class _BLEPageState extends State<BLEPage> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<BluetoothDevice> _devicesList = [];
//
//   void _startScan() {
//     setState(() {
//       _devicesList.clear();
//     });
//
//     flutterBlue.scan(timeout: Duration(seconds: 4)).listen((scanResult) {
//       if (!_devicesList.contains(scanResult.device)) {
//         setState(() {
//           _devicesList.add(scanResult.device);
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: SideBar(),
//       appBar: AppBar(
//         centerTitle: true,
//         foregroundColor: Colors.black,
//         title: const Text('LLama'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             // color: Color(0xFF6497d3),
//             color: Color(0xFF2580B3),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.all(10),
//             child: ElevatedButton(
//               onPressed: () {
//                 _startScan();
//               },
//               child: Text("Pair device to start"),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _devicesList.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_devicesList[index].name),
//                   subtitle: Text(_devicesList[index].id.toString()),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//WIFI
import 'package:flutter/material.dart';
import 'package:lamaradar/mode/rideInfo.dart';
import 'package:lamaradar/mode/startRide.dart';
import 'package:lamaradar/temp//CollisionWarningPage.dart';

class WifiPage extends StatefulWidget {
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  final List<String> _wifiNames = ['Llama Defender(BLE)', 'Display(BLE)', 'Llama DashCam(wifi)'];
  String _selectedWifi = '';

  void _connectToWifi(String wifiName) {
    setState(() {
      _selectedWifi = wifiName;
    });
    // TODO: Connect to selected Wi-Fi.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('LLama'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xFF2580B3),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 60),
          Expanded(
            child: ListView.builder(
              itemCount: _wifiNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_wifiNames[index]),
                  trailing: _selectedWifi == _wifiNames[index]
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : ElevatedButton(
                    onPressed: () {
                      _connectToWifi(_wifiNames[index]);
                    },
                    child: Text('Connect'),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(45.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Pair Device to Start'),
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.all(30.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CollisionWarningPage()),
                );
              },
              child: Text('Go to Ride'),
            ),
          ),
        ],
      ),
    );
  }
}

//BLE
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// class BluetoothDevice {
//   final String name;
//   final DeviceIdentifier id;
//
//   BluetoothDevice({required this.name, required this.id});
// }
//
//
// class BLEPage extends StatefulWidget {
//   @override
//   _BLEPageState createState() => _BLEPageState();
// }
//
// class _BLEPageState extends State<BLEPage> {
//
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<BluetoothDevice> _devicesList = [
//     BluetoothDevice(
//       name: 'Demo Device 1',
//       id: DeviceIdentifier('00000000-0000-0000-0000-000000000001'),
//     ),
//     BluetoothDevice(
//       name: 'Demo Device 2',
//       id: DeviceIdentifier('00000000-0000-0000-0000-000000000002'),
//     ),
//     BluetoothDevice(
//       name: 'Demo Device 3',
//       id: DeviceIdentifier('00000000-0000-0000-0000-000000000003'),
//     ),
//   ];
//   BluetoothDevice? _selectedDevice = null;
//
//   void _connectToDevice() async {
//     if (_selectedDevice != null) {
//       // await _selectedDevice.connect();
//       Navigator.of(context).pushReplacementNamed('/connected');
//     } else {
//       // handle case where no device is selected
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BLE Devices'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.all(10),
//             child: ElevatedButton(
//               onPressed: () {
//                 // TODO: Implement BLE scan functionality
//               },
//               child: Text('Scan'),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _devicesList.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_devicesList[index].name),
//                   subtitle: Text(_devicesList[index].id.toString()),
//                   onTap: () {
//                     setState(() {
//                       _selectedDevice = _devicesList[index];
//                     });
//                   },
//                   trailing: _selectedDevice == _devicesList[index]
//                       ? Icon(Icons.check)
//                       : null,
//                 );
//               },
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.all(10),
//             child: ElevatedButton(
//               onPressed: _connectToDevice,
//               child: Text('Connect'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WifiPage(),
  ));
}
