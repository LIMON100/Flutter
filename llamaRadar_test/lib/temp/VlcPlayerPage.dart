// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class VlcPlayerPage extends StatefulWidget {
//   @override
//   _VlcPlayerPageState createState() => _VlcPlayerPageState();
// }
//
// class _VlcPlayerPageState extends State<VlcPlayerPage> {
//   VlcPlayerController? _vlcController;
//
//   Orientation currentOrientation = Orientation.portrait;
//   static const String rotationAngleKey = 'rotation_angle';
//   double rotationAngle = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _vlcController = VlcPlayerController.network(
//       'rtsp://192.168.1.254/xxxx.mp4',
//       hwAcc: HwAcc.disabled,
//       autoPlay: true,
//       options: VlcPlayerOptions(
//           extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
//           sout: VlcStreamOutputOptions([
//             VlcStreamOutputOptions.soutMuxCaching(0),
//           ])
//       ),);
//     _vlcController!.takeSnapshot();
//     _loadRotationAngle();
//   }
//
//   @override
//   void dispose() {
//     _vlcController?.removeListener(() {});
//     _vlcController?.dispose();
//     super.dispose();
//   }
//
//   void _loadRotationAngle() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       rotationAngle = prefs.getDouble(rotationAngleKey) ?? 0.0;
//     });
//   }
//
//   // Save the current rotation angle to SharedPreferences
//   void _saveRotationAngle(double angle) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble(rotationAngleKey, angle);
//   }
//
//   void changeOrientation() {
//     setState(() {
//       rotationAngle += 90.0; // Rotate by 90 degrees
//       if (rotationAngle >= 360.0) {
//         rotationAngle = 0.0;
//       }
//       _saveRotationAngle(rotationAngle); // Save the new angle
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('VLC Player')),
//       body: OrientationBuilder(
//           builder: (context, orientation) {
//             currentOrientation = orientation;
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 16),
//                   Container(
//                     width: 360, // Set the width of the fixed space
//                     height: 400, // Set the height of the fixed space
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                     ),
//                     child: Center(
//                       child: AspectRatio(
//                         aspectRatio: currentOrientation == Orientation.portrait
//                             ? 16 / 9
//                             : 9 / 16,
//                         child: Transform.rotate(
//                           angle: rotationAngle * 3.14159265359 / 180,
//                           child: VlcPlayer(
//                             controller: _vlcController!,
//                             aspectRatio: currentOrientation == Orientation.portrait
//                                 ? 16 / 9
//                                 : 9 / 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//
//                   ElevatedButton(
//                     onPressed: changeOrientation,
//                     child: Text('Change Orientation'),
//                   ),
//                   SizedBox(height: 20,),
//                 ],
//               ),
//             );
//           }
//       ),
//     );
//   }
// }
//


import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';

class VlcPlayerPage extends StatefulWidget {
  @override
  _VlcPlayerPageState createState() => _VlcPlayerPageState();
}

class _VlcPlayerPageState extends State<VlcPlayerPage> {
  Orientation currentOrientation = Orientation.portrait;
  double rotationAngle = 0.0;
  String streamUrl = '';
  int networkCache = 1000; // Default network cache duration
  bool isCameraStreaming = false;
  late VlcPlayerController _videoPlayerController;
  bool isRearCamOpen = false;


  bool isDataMatched = false;
  bool isConnected = false;
  List<dynamic> wifiNetworks = [];
  int blinkDurationMilliseconds = 10000;
  final sliderLabels = [10, 30, 60, 90];
  bool isButtonEnabled = true;
  bool isCameraAnimation = false;
  final String ssid = ' ';
  final String password = "12345678";

  @override
  void initState() {
    super.initState();
    _scanWifiNetworks(context);
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
          video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
            VlcVideoOptions.skipFrames(false)],),
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(30),
            VlcAdvancedOptions.clockJitter(0),
            VlcAdvancedOptions.fileCaching(30),
            VlcAdvancedOptions.liveCaching(30),
            VlcAdvancedOptions.clockSynchronization(1),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
            ":rtsp-tcp",
          ]),
          extras: ['--h264-fps=60'],
          // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
          sout: VlcStreamOutputOptions([
            VlcStreamOutputOptions.soutMuxCaching(0),
          ])
      ),);
    await _videoPlayerController!.initialize();
  }

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

  // For Lower android version
  void _startWifiScan(BuildContext context) async {
    try {
      bool? isSuccess = await FlutterIotWifi.scan();
      if (isSuccess!) {
        // Wait for the scan process to complete
        await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed

        List<dynamic> networks = await FlutterIotWifi.list();
        // print(networks);

        if (networks.isEmpty) {
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

  Future<void> liveViewState() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2015&par=1'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  Future<void> stopRecordState() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2001&par=0'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }
  void changeOrientation() {
    setState(() {
      rotationAngle += 90.0; // Rotate by 90 degrees
      if (rotationAngle >= 360.0) {
        rotationAngle = 0.0;
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void toggleCameraStreaming() {
    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
    }
    else {
      Connectivity().onConnectivityChanged.listen((connectivity) {
        if (connectivity == ConnectivityResult.wifi) {
          _videoPlayerController = VlcPlayerController.network(
            'rtsp://192.168.1.254/xxxx.mp4',
            hwAcc: HwAcc.disabled,
            autoPlay: true,
            options: VlcPlayerOptions(
                video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
                  VlcVideoOptions.skipFrames(false)],),
                advanced: VlcAdvancedOptions([
                  VlcAdvancedOptions.networkCaching(30),
                  VlcAdvancedOptions.clockJitter(0),
                  VlcAdvancedOptions.fileCaching(30),
                  VlcAdvancedOptions.liveCaching(30),
                  VlcAdvancedOptions.clockSynchronization(1),
                ]),
                rtp: VlcRtpOptions([
                  VlcRtpOptions.rtpOverRtsp(true),
                  ":rtsp-tcp",
                ]),
                extras: ['--h264-fps=60'],
                // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
                sout: VlcStreamOutputOptions([
                  VlcStreamOutputOptions.soutMuxCaching(0),
                ])
            ),);
          _videoPlayerController.initialize().then((_) {
            _videoPlayerController.play();
          });
        }
      });
      _videoPlayerController = VlcPlayerController.network(
        'rtsp://192.168.1.254/xxxx.mp4',
        hwAcc: HwAcc.disabled,
        autoPlay: true,
        options: VlcPlayerOptions(
            video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
              VlcVideoOptions.skipFrames(false)],),
            advanced: VlcAdvancedOptions([
              VlcAdvancedOptions.networkCaching(30),
              VlcAdvancedOptions.clockJitter(0),
              VlcAdvancedOptions.fileCaching(30),
              VlcAdvancedOptions.liveCaching(30),
              VlcAdvancedOptions.clockSynchronization(1),
            ]),
            rtp: VlcRtpOptions([
              VlcRtpOptions.rtpOverRtsp(true),
              ":rtsp-tcp",
            ]),
            extras: ['--h264-fps=60'],
            // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
            sout: VlcStreamOutputOptions([
              VlcStreamOutputOptions.soutMuxCaching(0),
            ])
        ),);
      _videoPlayerController.initialize().then((_) {
        _videoPlayerController.play();
      });
    }

    setState(() {
      isCameraStreaming = !isCameraStreaming;
      isRearCamOpen = !isRearCamOpen;
    });
  }

  // FOR JPG IMAGES
  void toggleCameraStreamingForJpg() {
    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
      againPlay();
    }
  }

  void againPlay(){
    print("AGAIN");
    Connectivity().onConnectivityChanged.listen((connectivity) {
      if (connectivity == ConnectivityResult.wifi) {
        _videoPlayerController = VlcPlayerController.network(
          'http://192.168.1.254:8192',
          hwAcc: HwAcc.disabled,
          autoPlay: true,
          options: VlcPlayerOptions(
              video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
                VlcVideoOptions.skipFrames(false)],),
              advanced: VlcAdvancedOptions([
                VlcAdvancedOptions.networkCaching(30),
                VlcAdvancedOptions.clockJitter(0),
                VlcAdvancedOptions.fileCaching(30),
                VlcAdvancedOptions.liveCaching(30),
                VlcAdvancedOptions.clockSynchronization(1),
              ]),
              rtp: VlcRtpOptions([
                VlcRtpOptions.rtpOverRtsp(true),
                ":rtsp-tcp",
              ]),
              extras: ['--h264-fps=60'],
              // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
              sout: VlcStreamOutputOptions([
                VlcStreamOutputOptions.soutMuxCaching(0),
              ])
          ),);
        _videoPlayerController.initialize().then((_) {
          _videoPlayerController.play();
        });
      }
    });
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
          video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
            VlcVideoOptions.skipFrames(false)],),
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(30),
            VlcAdvancedOptions.clockJitter(0),
            VlcAdvancedOptions.fileCaching(30),
            VlcAdvancedOptions.liveCaching(30),
            VlcAdvancedOptions.clockSynchronization(1),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
            ":rtsp-tcp",
          ]),
          extras: ['--h264-fps=60'],
          // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
          sout: VlcStreamOutputOptions([
            VlcStreamOutputOptions.soutMuxCaching(0),
          ])
      ),);
    _videoPlayerController.initialize().then((_) {
      _videoPlayerController.play();
    });
    // }

    // setState(() {
    //   isCameraStreaming = !isCameraStreaming;
    //   isRearCamOpen = !isRearCamOpen;
    // });
  }

  Widget buildCameraButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (isCameraStreaming) // Show "Stop Rear Camera" button when streaming
              ElevatedButton(
                onPressed: toggleCameraStreaming,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  'Stop Rear Camera',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            if (!isCameraStreaming) // Show "Open Rear Cam" button when not streaming
              ElevatedButton(
                onPressed: toggleCameraStreaming,
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  'Open Camera',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  String getCurrentTime() {
    var now = DateTime.now();
    var formatter = DateFormat('hh:mm:ss');
    String formattedTime = formatter.format(now);
    return formattedTime;
  }

  Future<void> setDateOfCam() async {
    String currentDate = getCurrentDate();
    print(currentDate);
    final response = await http.get(
        Uri.parse('http://192.168.1.254/?custom=1&cmd=3005&str=$currentDate'));
    if (response.statusCode == 200) {
      setState(() {
        print('Date setted');
      });
    } else {
      print('Date error: ${response.statusCode}');
    }
  }

  Future<void> setTimeOfCam() async {
    String currentTime = getCurrentTime();
    final response = await http.get(
        Uri.parse('http://192.168.1.254/?custom=1&cmd=3005&str=$currentTime'));
    if (response.statusCode == 200) {
      setState(() {
        print('Time setted');
      });
    } else {
      print('Time error: ${response.statusCode}');
    }
  }

  Future<void> changeToPhotoMode() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3001&par=0';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Changed to Photo Mode');
      } else {
        print(
            'Error occured while changing photo mode: ${response.statusCode}');
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
        print(
            'Error occured while changing to video mode: ${response.statusCode}');
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
        // await getFilesFromCamera();
        // Add snakbar message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('                  Image captured successfully.'),
            duration: Duration(seconds: 2), // Adjust the duration as needed
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('             Image cannot capture due to network.'),
            duration: Duration(seconds: 2), // Adjust the duration as needed
          ),
        );
        print('Error occured: ${response.statusCode}');
        // Add snakbar message
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('             Image cannot capture due to network.'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST VLC-2'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              height: 280,
              width: 300,
              child: Center(
                child: Stack(
                  children: [
                    isCameraStreaming && _videoPlayerController != null
                        ? Transform.rotate(
                      angle: rotationAngle * 3.14159265359 / 180,
                      child: VlcPlayer(
                        controller: _videoPlayerController,
                        aspectRatio: currentOrientation == Orientation.portrait
                            ? 16 / 9
                            : 9 / 16,
                      ),
                    )
                        : Image.asset(
                      'images/test_background3.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                    if (isCameraStreaming)
                      Positioned(
                        bottom: 16.0,
                        right: 16.0,
                        child: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.cameraswitch_outlined),
                          onPressed: changeOrientation,
                          iconSize: 40.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align children to the start (left)
              children: [
                SizedBox(width: 120),
                buildCameraButton(),
                SizedBox(width: 75),
              ],
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setDateOfCam();
                          setTimeOfCam();
                          changeToPhotoMode();
                          toggleCameraStreamingForJpg();
                          takePicture();
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '   Capture',
                        style: TextStyle(
                          // color: Color(0xFFa8caba),
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


