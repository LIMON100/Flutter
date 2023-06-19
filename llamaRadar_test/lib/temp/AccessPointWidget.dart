// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
// import 'package:permission_handler/permission_handler.dart';
//
//
// // class AccessPointWidget extends StatelessWidget {
// //   const AccessPointWidget({Key? key}) : super(key: key);
//
// class AccessPointWidget extends StatefulWidget {
//
//   const AccessPointWidget({Key? key}) : super(key: key);
//
//   @override
//   _AccessPointWidgetState createState() => _AccessPointWidgetState();
// }
//
// class _AccessPointWidgetState extends State<AccessPointWidget> {
//
//   final String ssid = "Mahmudur @ SF Networking"; // TODO replace with your ssid  Mahmudur @ SF Networking
//   final String password = "@@@@####"; // TODO replace with your password
//
//   Future<bool> _checkPermissions() async {
//     if (Platform.isIOS || await Permission.location.request().isGranted) {
//       return true;
//     }
//     return false;
//   }
//
//   void _connect() async {
//     if (await _checkPermissions()) {
//       FlutterIotWifi.connect(ssid, password, prefix: true).then((value) => print("connect initiated: $value"));
//     }
//     // else {
//     //   print("don't have permission");
//     // }
//     else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Permission Error'),
//             content: Text('Please turn on Wi-Fi first.'),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   void _disconnect() async {
//     if (await _checkPermissions()) {
//       FlutterIotWifi.disconnect().then((value) => print("disconnect initiated: $value"));
//     } else {
//       print("don't have permission");
//     }
//   }
//
//   void _scan() async {
//     if (await _checkPermissions()) {
//       FlutterIotWifi.scan().then((value) => print("scan started: $value"));
//     } else {
//       print("don't have permission");
//     }
//   }
//
//   // void _list() async {
//   //   if (await _checkPermissions()) {
//   //     FlutterIotWifi.list().then((value) => print("ssids: $value"));
//   //   } else {
//   //     print("don't have permission");
//   //   }
//   // }
//
//   void _list() async {
//     if (await _checkPermissions()) {
//       List<dynamic> wifiList = await FlutterIotWifi.list();
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Available Wi-Fi Networks'),
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 for (var wifiNetwork in wifiList)
//                   ListTile(
//                     title: Text(wifiNetwork['ssid']),
//                     subtitle: Text(wifiNetwork['bssid']),
//                   ),
//               ],
//             ),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       print("Don't have permission");
//     }
//   }
//
//
//
//   void _current() async {
//     if (await _checkPermissions()) {
//       FlutterIotWifi.current().then((value) => print("current ssid: $value"));
//     } else {
//       print("don't have permission");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Center(child: Text("SSID: $ssid, PASSWORD: $password")),
//         // _CustomButton(onPressed: _connect, child: const Text("Connect")),
//         // _CustomButton(onPressed: _disconnect, child: const Text("Disconnect")),
//         _CustomButton(onPressed: _scan, child: const Text("Scan (Android only)")),
//         _CustomButton(onPressed: _list, child: const Text("List (Android only)")),
//         // _CustomButton(onPressed: _current, child: const Text("Current")),
//       ],
//     );
//   }
// }
//
// class _CustomButton extends StatelessWidget {
//   const _CustomButton({Key? key, required this.onPressed, required this.child}) : super(key: key);
//
//   final VoidCallback onPressed;
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(height: 40, child: ElevatedButton(onPressed: onPressed, child: child));
//   }
// }



import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
// import 'package:wifi_iot/wifi_iot.dart' as wifi_iot;

import 'glowing_button.dart';

class AccessPointWidget extends StatefulWidget {
  const AccessPointWidget({Key? key}) : super(key: key);

  @override
  _AccessPointWidgetState createState() => _AccessPointWidgetState();
}

class _AccessPointWidgetState extends State<AccessPointWidget> {
  final String ssid = 'Mahmudur @ SF Networking';
  final String password = '@@@@####';
  bool isConnected = false;

  List<dynamic> wifiNetworks = [];

  Future<bool> _checkPermissions() async {
    if (Platform.isIOS || await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }

  // void _scanWifiNetworks() async {
  //   if (await _checkPermissions()) {
  //     try {
  //       bool? isSuccess = await FlutterIotWifi.scan();
  //       if (isSuccess!) {
  //         List<dynamic> networks = await FlutterIotWifi.list();
  //         setState(() {
  //           wifiNetworks = networks.cast<dynamic>();
  //         });
  //       } else {
  //         print('Failed to scan Wi-Fi networks');
  //       }
  //     } catch (e) {
  //       print('Failed to scan Wi-Fi networks: $e');
  //     }
  //   }
  // }
  void _scanWifiNetworks(BuildContext context) async {
    if (await _checkPermissions()) {
      try {
        bool? isSuccess = await FlutterIotWifi.scan();
        if (isSuccess!) {
          List<dynamic> networks = await FlutterIotWifi.list();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  width: 300, // Adjust the width as needed
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: networks.length,
                    itemBuilder: (context, index) {
                      final wifiNetwork = networks[index];
                      return ListTile(
                        title: Text(wifiNetwork.toString()),
                        onTap: () {
                          _connect(context, wifiNetwork.toString());
                          Navigator.of(context).pop(); // Close the dialog after selection
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        } else {
          print('Failed to scan Wi-Fi networks');
        }
      } catch (e) {
        print('Failed to scan Wi-Fi networks: $e');
      }
    }
  }

  // void _connect(BuildContext context, String ssid) async {
  //   print("CHECK WIFI SSID");
  //   print(ssid);
  //   if (await _checkPermissions()) {
  //     if (isConnected) {
  //       FlutterIotWifi.disconnect().then((value) {
  //         setState(() {
  //           isConnected = false;
  //         });
  //         print("Disconnect initiated: $value");
  //       });
  //     } else {
  //       FlutterIotWifi.connect(ssid, password).then((value) {
  //         setState(() {
  //           isConnected = true;
  //         });
  //         print("Connect initiated: $value");
  //       });
  //     }
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Permission Error'),
  //           content: Text('Please turn on Wi-Fi first.'),
  //           actions: [
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  // Try with dialog window
  void _connect(BuildContext context, String ssid) async {
    if (await _checkPermissions()) {
      if (isConnected) {
        FlutterIotWifi.disconnect().then((value) {
          setState(() {
            isConnected = false;
          });
          print("Disconnect initiated: $value");
        });
      } else {
        FlutterIotWifi.connect(ssid, password).then((value) {
          setState(() {
            isConnected = true;
          });
          print("Connect initiated: $value");
        });
      }
      // Delay the pop to ensure the connection process is completed
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the dialog window
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Error'),
            content: Text('Please turn on Wi-Fi first.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  void initState() {
    super.initState();
    // _scanWifiNetworks();
  }

  Dialog _buildWifiNetworksDialog(BuildContext context) {
    return Dialog(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: wifiNetworks.length,
        itemBuilder: (context, index) {
          final wifiNetwork = wifiNetworks[index];
          return ListTile(
            title: Text(wifiNetwork.toString()),
            onTap: () {
              _connect(context, wifiNetwork.toString());
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 15),
              GlowingButton2(
                text: "Scan Wi-Fi",
                onPressed: () {
                  _scanWifiNetworks(context);
                },
                color1: Color(0xFF517fa4),
                color2: Colors.deepPurpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
