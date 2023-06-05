import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lamaradar/mode/dashCamDetails.dart';
import 'package:lamaradar/mode/dashCamFIles.dart';
import '../temp/glowing_button.dart';
import 'bleScreen.dart';
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


class CircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;

  const CircleButton({
    required this.onPressed,
    required this.color,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 100,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


class DashCam extends StatefulWidget {
  const DashCam({Key? key}) : super(key: key);

  @override
  _DashCamState createState() => _DashCamState();
}

class _DashCamState extends State<DashCam> {

  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  // bool _isCameraReady = false;
  // bool _isFlashOn = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  final List<Widget> _children = [
    Home(),
    Files(),
    About(),
  ];

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
          centerTitle: true,
          foregroundColor: Colors.black,
          title: const Text('Dash Cam'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {

              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => BleScreen(title: '')
                ),
              );// Navigate to previous screen
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              // color: Color(0xFF2580B3),
              // color: Colors.deepPurpleAccent,
              color: Colors.deepPurple[400],
            ),
          ),
        ),
        body:_children[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          backgroundColor: Colors.indigoAccent,
          color: Colors.indigo.shade200,
          animationDuration: Duration(milliseconds: 300),
          // currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.white : Colors.blueGrey.shade700,
            ),
            Icon(
              Icons.image,
              color: _currentIndex == 1 ? Colors.white : Colors.blueGrey.shade700,
            ),
            Icon(
              Icons.history,
              color: _currentIndex == 2 ? Colors.white : Colors.blueGrey.shade700,
            ),
          ],
        ),
      ),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //WIFI
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

//  final String webUrl = 'http://192.168.1.254/';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 350,
                width: 400,
                child: isCameraStreaming && _controller != null
                    ? VlcPlayer(
                  controller: _controller!,
                  aspectRatio: 16 / 9,
                  placeholder: Center(child: CircularProgressIndicator()),
                )
                    : Image.asset(
                  'images/test_background2.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),

              SizedBox(height: 5),
              // GlowingButton2(
              //   text: "Open Camera",
              //   onPressed: () {
              //     initializePlayer();
              //     _controller!.play();
              //     playVlc();
              //     VlcPlayer(
              //       controller: _controller!,
              //       aspectRatio: 16 / 9,
              //       placeholder: Center(child: CircularProgressIndicator()),
              //     );
              //     setState(() {
              //       isCameraStreaming = true;
              //     });
              //   },
              //   color1: Color(0xFF517fa4),
              //   color2: Colors.deepPurpleAccent,
              // ),
              //
              // SizedBox(height: 5),
              // GlowingButton2(
              //   text: "Stop Camera",
              //   onPressed: () async {
              //     if (_controller != null) {
              //       await _controller!.stop();
              //       await _controller!.dispose();
              //     }
              //     _controller = null;
              //     setState(() {
              //       isCameraStreaming = false;
              //     });
              //   },
              //   color1: Color(0xFF517fa4),
              //   color2: Colors.deepPurple,
              // ),
              // SizedBox(height: 10),
              // // image capture
              // // http://192.168.1.254/?custom=1&cmd=1001
              // // file retreive test
              // // GlowingButton2(
              // //   text: "Files",
              // //   onPressed: () {
              // //     //send record command
              // //     fetchFiles();
              // //     print(fileList);
              // //     //_videoPlayerController.startRecording("/sdcard/test/");
              // //   },
              // //   color1: Color(0xFF517fa4),
              // //   color2: Colors.deepPurple,
              // // ),
              // GlowingButton2(
              //   text: "Start Recording",
              //   onPressed: () {
              //     //send record command
              //     changeToVideoMode();
              //     startRecordingCmd();
              //     //_videoPlayerController.startRecording("/sdcard/test/");
              //   },
              //   color1: Color(0xFF517fa4),
              //   color2: Colors.deepPurple,
              // ),
              // SizedBox(height: 10),
              //
              // GlowingButton2(
              //   text: "Stop Recording",
              //   onPressed: () {
              //     //send stop command
              //     stopRecordingCmd();
              //     //_videoPlayerController.stopRecording();
              //   },
              //   color1: Color(0xFF517fa4),
              //   color2: Colors.deepPurple,
              // ),
              // SizedBox(height: 10),
              // GlowingButton2(
              //   text: "Capture",
              //   onPressed: () {
              //     //send stop command
              //     changeToPhotoMode();
              //     takePicture();
              //     changeToVideoMode();
              //   },
              //   color1: Color(0xFF517fa4),
              //   color2: Colors.deepPurple,
              // ),

              //test round button
              Column(
                children: [
                  Positioned(
                    // right: 70,
                    child: CircleButton(
                      onPressed: () {
                        //send record command
                        changeToVideoMode();
                        startRecordingCmd();
                        //_videoPlayerController.startRecording("/sdcard/test/");
                      },
                      color: Colors.deepPurpleAccent,
                      text: 'Start Recording',
                    ),
                  ),
                  SizedBox(height: 1),
                  Row(
                    children:[
                      SizedBox(width: 1),
                    Positioned(
                      right: 10,
                      child: CircleButton(
                        onPressed: () {
                          //send stop command
                          stopRecordingCmd();
                          //_videoPlayerController.stopRecording();
                        },
                        color: Colors.deepPurpleAccent,
                        text: 'Stop Recording',
                      ),
                    ),
                    SizedBox(width: 1),
                    Center(
                      child: Positioned(
                        top: 10,
                        child: GlowingButton2(
                            text: "Open Camera",
                            onPressed: () {
                              initializePlayer();
                              _controller!.play();
                              playVlc();
                              VlcPlayer(
                                controller: _controller!,
                                aspectRatio: 16 / 9,
                                placeholder: Center(child: CircularProgressIndicator()),
                              );
                              setState(() {
                                isCameraStreaming = true;
                              });
                            },
                            color1: Color(0xFF517fa4),
                            color2: Colors.deepPurpleAccent,
                          ),
                      ),
                    ),
                      SizedBox(width: 1),
                      Positioned(
                        top: 2,
                        child: CircleButton(
                          onPressed: () {
                            changeToPhotoMode();
                            takePicture();
                            changeToVideoMode();
                          },
                          color: Colors.deepPurpleAccent,
                          text: 'Capture',
                        ),
                      ),

                    ],
                  ),
                  Positioned(
                    top: 2,
                    child: CircleButton(
                      onPressed: () async {
                        if (_controller != null) {
                          await _controller!.stop();
                          await _controller!.dispose();
                        }
                        _controller = null;
                        setState(() {
                          isCameraStreaming = false;
                        });
                      },
                      color: Colors.deepPurpleAccent,
                      text: 'Stop Camera',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    // _connect(context);
                    _scanWifiNetworks(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi,
                        color: isConnected ? Colors.green : Colors.black,
                        size: 50,
                      ),
                      Text(
                        isConnected ? 'Disconnected' : 'Connect WIFI',
                        style: TextStyle(
                          color: isConnected ? Colors.green : Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class Files extends StatefulWidget {
  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {

// class Files extends StatelessWidget {
  int _currentIndex = 0;

  List<String> items = [
    "All",
    "Video",
    "Photos",
  ];

  /// List of body icon
  List<IconData> icons = [
    Icons.home,
    Icons.video_file,
    Icons.photo,
  ];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Container(

        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(45),
        child: Column(
          children: [
            /// CUSTOM TABBAR
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 90,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? Colors.white70
                                  : Colors.white54,
                              borderRadius: current == index
                                  ? BorderRadius.circular(15)
                                  : BorderRadius.circular(10),
                              border: current == index
                                  ? Border.all(
                                  color: Colors.deepPurpleAccent, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: GoogleFonts.laila(
                                    fontWeight: FontWeight.w500,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: current == index,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  shape: BoxShape.circle),
                            ))
                      ],
                    );
                  }),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[current],
                        size: 200,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        items[current],
                        style: GoogleFonts.laila(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                            color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class About extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade100,
//       body: Container(
//         alignment: Alignment.center,
//         child: Text("About"),
//       ),
//     );
//   }
// }



//
// class About extends StatelessWidget {
//   final String url = 'http://192.168.1.254/CARDV/';
//
//   Future<void> fetchFiles() async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         // Dosyaları çekme işlemlerini burada yapabilirsiniz
//         print('Dosyalar çekildi: ${response.body}');
//       } else {
//         print('Dosyaları çekerken bir hata oluştu. Kod: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Dosyaları çekerken bir hata oluştu: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade100,
//       body: Container(
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "About",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               child: Text('Dosyaları Çek'),
//               onPressed: () {
//                 fetchFiles();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class About extends StatelessWidget {
  final String url = 'http://192.168.1.254/CARDV/PHOTO/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          child: Text('Display Files'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WebviewScaffold(
                url: url,
                appBar: AppBar(
                  title: Text('Files'),
                ),
              ),
            ));
          },
        ),
      ),
    );
  }
}
