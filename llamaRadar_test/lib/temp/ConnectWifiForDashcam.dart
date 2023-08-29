import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../mode/bleScreen.dart';
import '../temp/glowing_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' show parse;
import 'package:xml/xml.dart' as xml;
import 'package:lamaradar/mode/dash_cam.dart';

class ConnectWifiForDashCam extends StatefulWidget {
  const ConnectWifiForDashCam({Key? key}) : super(key: key);

  @override
  _ConnectWifiForDashCamState createState() => _ConnectWifiForDashCamState();
}

class _ConnectWifiForDashCamState extends State<ConnectWifiForDashCam> {

  bool isConnected = false;
  bool isConnectedFromEmptyList = false;
  final String ssid = ' ';
  final password = '12345678';

  Future<bool> _checkPermissions() async {
    if (Platform.isIOS || await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }

  void _scanWifiNetworks(BuildContext context) async {
    print("Inside _scanWifiNetworks");
    if (isConnected) {
      FlutterIotWifi.disconnect().then((value) {
        setState(() {
          isConnected = false;
        });
        print("Disconnect initiated: $value");

        // Start the Wi-Fi scan after disconnecting
        // _startWifiScan(context);
      });
    } else if (await _checkPermissions()) {
      // Start the Wi-Fi scan directly
      _startWifiScan(context);
    }
  }

  // void _startWifiScan(BuildContext context) async {
  //   print("Inside startscan");
  //   try {
  //     bool? isSuccess = await FlutterIotWifi.scan();
  //     if (isSuccess!) {
  //       // Wait for the scan process to complete
  //       await Future.delayed(
  //           Duration(seconds: 2)); // Adjust the delay as needed
  //
  //       List<dynamic> networks = await FlutterIotWifi.list();
  //       print(networks);
  //       showDialog(
  //         context:
  //         context, // Use a parent context instead of the current context
  //         builder: (BuildContext dialogContext) {
  //           // Use a different variable for the dialog context
  //           return Dialog(
  //             child: Container(
  //               width: 300, // Adjust the width as needed
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: networks.length,
  //                 itemBuilder: (context, index) {
  //                   final wifiNetwork = networks[index];
  //                   return ListTile(
  //                     title: Text(wifiNetwork.toString()),
  //                     onTap: () {
  //                       _connect(context, wifiNetwork.toString());
  //                       Navigator.of(dialogContext)
  //                           .pop(); // Close the dialog after selection using the dialog context
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     } else {
  //       print('Failed to scan Wi-Fi networks');
  //       await Future.delayed(
  //           Duration(seconds: 6)); // Adjust the delay as needed
  //       _startWifiScan(context);
  //     }
  //   } catch (e) {
  //     print('Failed to scan Wi-Fi networks: $e');
  //   }
  // }

  // For Lower android version
  void _startWifiScan(BuildContext context) async {
    print("Inside startscan");
    try {
      bool? isSuccess = await FlutterIotWifi.scan();
      if (isSuccess!) {
        // Wait for the scan process to complete
        await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed

        List<dynamic> networks = await FlutterIotWifi.list();
        print(networks);

        if (networks.isEmpty) {
          isConnectedFromEmptyList = true;
          // Show a pop-up message when the networks list is empty
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text('No WiFi Networks Found'),
                content: Text(
                    "Can't find any WiFi network. Please connect to the WiFi named 'CARDV'."
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Show the list of available WiFi networks
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
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
                          Navigator.of(dialogContext).pop(); // Close the dialog after selection
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      } else {
        print('Failed to scan Wi-Fi networks');
        await Future.delayed(Duration(seconds: 6)); // Adjust the delay as needed
        _startWifiScan(context);
      }
    } catch (e) {
      print('Failed to scan Wi-Fi networks: $e');
    }
  }

  void _connect(BuildContext context, String ssid) async {
    if (!mounted) {
      return;
    }

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
    }
  }

  // Page Builder for images
  final List<String> imageList = [
    'assets/images/dashcammotor.jpg',
    'assets/images/dashcammotor2.jpg',
    'assets/images/dashcammotor3.jpg',
  ];
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (currentIndex < imageList.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.black,
          title: Text('Connect wifi'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2580B3),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BleScreen(title: '',)),
              ); // Navigate to previous screen
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200, // Set a fixed height for the PageView
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imageList[index],
                        fit: BoxFit.cover,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 180),
                InkWell(
                  onTap: () {
                    // _connect(context);
                    _scanWifiNetworks(context);
                  },
                  child: Icon(
                    Icons.wifi,
                    color: isConnected ? Colors.red : Colors.black,
                    size: 50,
                  ),
                ),
                Text(
                  isConnected ? 'Disconnect' : 'Connect WIFI',
                  style: TextStyle(
                    color: isConnected ? Colors.red : Colors.black,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                if (isConnected || isConnectedFromEmptyList) //for ozgun
                  GlowingButton2(
                    text: "Open Dashcam",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashCam(),
                        ),
                      );
                    },
                    color1: Color(0xFF517fa4),
                    color2: Colors.cyan,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}