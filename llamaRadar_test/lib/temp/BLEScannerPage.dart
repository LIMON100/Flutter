// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// class BLEScannerPage extends StatefulWidget {
//   const BLEScannerPage({Key? key}) : super(key: key);
//   @override
//   _BLEScannerPageState createState() => _BLEScannerPageState();
// }
//
// class _BLEScannerPageState extends State<BLEScannerPage> {
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   List<ScanResult> devices = [];
//   Set<BluetoothDevice> connectedDevices = {};
//
//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }
//
//   void startScan() {
//     flutterBlue.scan().listen((scanResult) {
//       if (!devices.contains(scanResult)) {
//         setState(() {
//           devices.add(scanResult);
//         });
//       }
//     });
//   }
//
//   void connectToDevice(ScanResult scanResult) async {
//     try {
//       await scanResult.device.connect(autoConnect: false);
//       setState(() {
//         connectedDevices.add(scanResult.device);
//       });
//     } catch (e) {
//       print('Failed to connect to device: $e');
//     }
//   }
//
//   void disconnectFromDevice(BluetoothDevice device) async {
//     try {
//       await device.disconnect();
//       setState(() {
//         connectedDevices.remove(device);
//       });
//     } catch (e) {
//       print('Failed to disconnect from device: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BLE Scanner'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: startScan,
//             child: Text('Scan for Devices'),
//           ),
//           SizedBox(height: 16),
//           Text('Available Devices:'),
//           Expanded(
//             child: ListView.builder(
//               itemCount: devices.length,
//               itemBuilder: (context, index) {
//                 ScanResult scanResult = devices[index];
//                 BluetoothDevice device = scanResult.device;
//                 return ListTile(
//                   title: Text(device.name),
//                   subtitle: Text(device.id.toString()),
//                   trailing: connectedDevices.contains(device)
//                       ? ElevatedButton(
//                     onPressed: () => disconnectFromDevice(device),
//                     child: Text('Disconnect'),
//                   )
//                       : ElevatedButton(
//                     onPressed: () => connectToDevice(scanResult),
//                     child: Text('Connect'),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lamaradar/mode/dashCamDetails.dart';
import 'package:lamaradar/mode/dashCamFIles.dart';
import '../temp/glowing_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:html/parser.dart' show parse;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class RoundTableButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color1;
  final Color color2;

  const RoundTableButton({
    required this.text,
    required this.onPressed,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      child: GlowingButton2(
        text: text,
        onPressed: onPressed,
        color1: color1,
        color2: color2,
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const CircleButton({
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class BLEScannerPage extends StatefulWidget {
  const BLEScannerPage({Key? key}) : super(key: key);
  @override
  _BLEScannerPageState createState() => _BLEScannerPageState();
}

class _BLEScannerPageState extends State<BLEScannerPage> {
  final String ssid = 'Car'; //CARDV-8c8b Mahmudur @ SF Networking
  final  password = '12345678';

  //IP Address
  final String ipAddress = '192.168.1.254';

  //files
  final String url = 'http://192.168.1.254';
  bool isConnected = false;
  bool isCameraStreaming = true;
  List<dynamic> wifiNetworks = [];

  // wifi connection
  Future<bool> _checkPermissions() async {
    if (Platform.isIOS || await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }

  void _scanWifiNetworks(BuildContext context) async {
    if (isConnected) {
      FlutterIotWifi.disconnect().then((value) {
        setState(() {
          isConnected = false;
        });
        print("Disconnect initiated: $value");

        // Start the Wi-Fi scan after disconnecting
        _startWifiScan(context);
      });
    } else if (await _checkPermissions()) {
      // Start the Wi-Fi scan directly
      _startWifiScan(context);
    }
  }

  void _startWifiScan(BuildContext context) async {
    try {
      bool? isSuccess = await FlutterIotWifi.scan();
      if (isSuccess!) {
        // Wait for the scan process to complete
        await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed

        List<dynamic> networks = await FlutterIotWifi.list();
        showDialog(
          context: context, // Use a parent context instead of the current context
          builder: (BuildContext dialogContext) { // Use a different variable for the dialog context
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
                        Navigator.of(dialogContext).pop(); // Close the dialog after selection using the dialog context
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
        await Future.delayed(Duration(seconds: 6)); // Adjust the delay as needed
        _startWifiScan(context);
      }
    } catch (e) {
      print('Failed to scan Wi-Fi networks: $e');
    }
  }

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
      Future.delayed(const Duration(seconds: 3), () {
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

  final VlcPlayerController _videoPlayerController = VlcPlayerController.network(
    'rtsp://192.168.1.254/xxxx.mov',
    hwAcc: HwAcc.full,
    autoPlay: true,
    options: VlcPlayerOptions(),
  );

  void playVlc() {
    VlcPlayer(
      controller: _videoPlayerController,
      aspectRatio: 16 / 9,
      placeholder: Center(child: CircularProgressIndicator()),
    );
  }

  // VLC PLAYER
  VlcPlayerController? _controller;

  Future<void> initializePlayer() async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mov',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    await _controller!.initialize();
  }

  Future<void> startRecordingCmd() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=2001&par=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Recording started...');
      } else {
        print('Error occured: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> stopRecordingCmd() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=2001&par=0';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Recording stopped...');
      } else {
        print('Error occured while stopping record: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> changeToPhotoMode() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3001&par=0';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Changed to Photo Mode');
      } else {
        print('Error occured while changing photo mode: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> changeToVideoMode() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3001&par=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Changed to Video Mode');
      } else {
        print('Error occured while changing to video mode: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> takePicture() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=1001';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Image captured');
      } else {
        print('Error occured: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  // retrieving files

  List<String> fileList = [];


  Future<void> fetchFiles() async {
    final response = await http.get(Uri.parse('http://192.168.1.254'));
    if (response.statusCode == 200) {
      setState(() {
        fileList = json.decode(response.body);
      });
    } else {
      print('File error: ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     foregroundColor: Colors.black,
    //     title: const Text('Dash Cam'),
    //     actions: <Widget>[
    //       IconButton(
    //         icon: Icon(Icons.settings),
    //         onPressed: () {
    //
    //         },
    //       ),
    //     ],
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back),
    //       onPressed: () {
    //
    //       },
    //     ),
    //     flexibleSpace: Container(
    //       decoration: BoxDecoration(
    //         // color: Color(0xFF6497d3),
    //         // color: Color(0xFF2580B3),
    //         // color: Colors.deepPurpleAccent,
    //         color: Colors.deepPurple[400],
    //       ),
    //     ),
    //   ),
    //   body: Column(
    //     children:[
    //       Stack(
    //       alignment: Alignment.center,
    //       children: [
    //         Center(
    //           child: Positioned(
    //             top: 50,
    //             left: 60,
    //             child: GlowingButton2(
    //               text: "Start Recording",
    //               onPressed: () {
    //                 // Send record command
    //                 changeToVideoMode();
    //                 startRecordingCmd();
    //                 //_videoPlayerController.startRecording("/sdcard/test/");
    //               },
    //               color1: Color(0xFF517fa4),
    //               color2: Colors.deepPurple,
    //             ),
    //           ),
    //         ),
    //         Center(
    //           child: Positioned(
    //             bottom: 10,
    //             left: 300,
    //             child: GlowingButton2(
    //               text: "Capture",
    //               onPressed: () {
    //                 // Send stop command
    //                 changeToPhotoMode();
    //                 takePicture();
    //                 changeToVideoMode();
    //               },
    //               color1: Color(0xFF517fa4),
    //               color2: Colors.deepPurple,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Circular Button Page'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Positioned(
                top: 10,
                child: CircleButton(
                  onPressed: () {
                    // Handle top button press
                  },
                  color: Colors.blue,
                ),
              ),
            ),
            Positioned(
              bottom: 220,
              child: CircleButton(
                onPressed: () {
                  // Handle bottom button press
                },
                color: Colors.red,
              ),
            ),
            Positioned(
              left: 70,
              child: CircleButton(
                onPressed: () {
                  // Handle left button press
                },
                color: Colors.green,
              ),
            ),
            Positioned(
              right: 70,
              child: CircleButton(
                onPressed: () {
                  // Handle right button press
                },
                color: Colors.yellow,
              ),
            ),
            Positioned(
              top: 220,
              child: CircleButton(
                onPressed: () {
                  // Handle right button press
                },
                color: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}