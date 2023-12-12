import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamaradar/mode/settings.dart';
import '../temp/ConnectWifiForDashCam.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file.dart';

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
        width: 75,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// class FileItem {
//   final String name;
//   final String filePath;
//   // final String size;
//   final String time;
//
//   FileItem(this.name, this.filePath, this.time);
// }
//
// class FileName {
//   final String name;
//   FileName(this.name);
// }


// Main Dash Cam page
class DashCam extends StatefulWidget {
  const DashCam({Key? key}) : super(key: key);

  @override
  _DashCamState createState() => _DashCamState();
}

class _DashCamState extends State<DashCam> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  int _currentIndex = 0;
  bool isCameraStreaming = false;
  late VlcPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    stopRecordState();
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
          video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
            VlcVideoOptions.skipFrames(false)],),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
            ":rtsp-tcp",
          ]),
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(30),
            VlcAdvancedOptions.clockJitter(0),
            VlcAdvancedOptions.fileCaching(30),
            VlcAdvancedOptions.liveCaching(30),
            VlcAdvancedOptions.clockSynchronization(1),
          ]),
          sout: VlcStreamOutputOptions([
            VlcStreamOutputOptions.soutMuxCaching(0),
          ]),
          extras: ['--h264-fps=60']
      ),);
    // getFilesFromCamera();
  }

  // Recording also stop
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

  // auto record on/off
  Future<void> cyclicRecordStateoff() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2012&par=0'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  Future<void> cyclicRecordStateOn() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2012&par=1'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }
  // List<FileItem> images = [];
  // List<FileItem> videos = [];
  //
  // Future<void> getFilesFromCamera() async {
  //   String url = 'http://192.168.1.254/?custom=1&cmd=3015';
  //
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       final xmlDoc = xml.XmlDocument.parse(response.body);
  //       final fileElements = xmlDoc.findAllElements('File');
  //
  //       // Clear the existing lists before updating
  //       setState(() {
  //         images.clear();
  //         videos.clear();
  //       });
  //
  //       for (final fileElement in fileElements) {
  //         final nameElement = fileElement.findElements('NAME').single;
  //         final filePathElement = fileElement.findElements('FPATH').single;
  //         final timeElement = fileElement.findElements('TIME').single;
  //
  //         final name = nameElement.text;
  //         final filePath = filePathElement.text;
  //         final time = timeElement.text;
  //
  //         final fileItem = FileItem(name, filePath, time);
  //
  //         if (name.endsWith('.JPG')) {
  //           setState(() {
  //             images.add(fileItem);
  //           });
  //         } else if (name.endsWith('.MP4')) {
  //           setState(() {
  //             videos.add(fileItem);
  //           });
  //         }
  //       }
  //     } else {
  //       print('Error occurred: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  void toggleCameraStreaming() {
    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
    }
    else {
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
    });
  }


  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _navigateToFilesPage() async {
    setState(() {
      _isLoading = true;
    });

    // Stop the video controller
    _videoPlayerController.stop();

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });

    // Navigate to the Files page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Files(
          images: [],
          videos: [],
        ),
      ),
    );
  }

  bool _isLoadingSetting = false;

  void _navigateToSettingPage() async {
    setState(() {
      _isLoadingSetting = true;
    });

    // Stop the video controller
    _videoPlayerController.stop();

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoadingSetting = false;
    });

    // Navigate to the Files page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DashSettings()),
    );
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
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.white60,
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.black,
          title: const Text('Dash Cam'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _navigateToSettingPage();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => DashSettings()),
                // );
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ConnectWifiForDashCam()),
              ); // Navigate to previous screen
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Color(0xFF517fa4)
            ),
          ),
        ),
        body: Stack(
          children: [
            Home(
              toggleCameraStreaming: toggleCameraStreaming,
              isCameraStreaming: isCameraStreaming,
              videoPlayerController: _videoPlayerController,
              // images: [],
              // videos: [],
            ),
            if (_isLoading || _isLoadingSetting)
              Center(
                child: SpinKitSpinningCircle(
                  color: Colors.deepOrange,
                  size: 150.0,
                ),
              ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Center(
            child: InkWell(
              onTap: () {
                _navigateToFilesPage();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'FILES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Home class
// DashCam functionality
class Home extends StatefulWidget {
  final Function toggleCameraStreaming;
  final bool isCameraStreaming;
  final VlcPlayerController videoPlayerController;
  // List<FileItem> images = [];
  // List<FileItem> videos = [];


  Home({
    required this.toggleCameraStreaming,
    required this.isCameraStreaming,
    required this.videoPlayerController,
    // required this.images,
    // required this.videos,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //WIFI
  final String ssid = ' ';
  final password = '12345678';
  bool isConnected = false;
  bool isCameraStreaming = false;
  // List<FileItem> images = [];
  // List<FileItem> videos = [];


  //IP Address
  final String ipAddress = '192.168.1.254';

  final String url = 'http://192.168.1.254';
  bool isFront = false;
  bool isSensor = false;
  List<dynamic> wifiNetworks = [];

  // Recording variable
  bool isRecording = false;
  Color buttonColor = Colors.deepPurpleAccent;
  String buttonText = 'Start Recording';
  static const String rotationAngleKey = 'rotation_angle';


  // Rtsp Streaming
  @override
  void initState() {
    super.initState();
    isCameraStreaming = widget.isCameraStreaming; // Initialize state from widget
    // images = widget.images;
    // videos = widget.videos;
    initializePlayer();
    _loadRotationAngle();
    // liveViewState();
    stopRecordState();
  }

  // Recording also stop
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
  Future<void> initializePlayer() async {
    await widget.videoPlayerController.initialize();
    widget.videoPlayerController.play();

    setState(() {
      isCameraStreaming = true;
    });
  }

  void toggleCameraStreaming() {
    if (isCameraStreaming) {
      // Stop Camera
      widget.videoPlayerController.stop();
    }
    else {
      // Open Camera
      setDateOfCam();
      setTimeOfCam();
      cyclicRecordStateoff();
      widget.videoPlayerController.play();
    }

    setState(() {
      isCameraStreaming = !isCameraStreaming;
    });
  }

  // auto record on/off
  Future<void> cyclicRecordStateoff() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2012&par=0'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  Future<void> cyclicRecordStateOn() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2012&par=1'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
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
        // _startWifiScan(context);
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
        await Future.delayed(
            Duration(seconds: 2)); // Adjust the delay as needed

        List<dynamic> networks = await FlutterIotWifi.list();
        showDialog(
          context:
          context, // Use a parent context instead of the current context
          builder: (BuildContext dialogContext) {
            // Use a different variable for the dialog context
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
                        Navigator.of(dialogContext)
                            .pop(); // Close the dialog after selection using the dialog context
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
        await Future.delayed(
            Duration(seconds: 6)); // Adjust the delay as needed
        _startWifiScan(context);
      }
    } catch (e) {
      print('Failed to scan Wi-Fi networks: $e');
    }
  }

  // dialog window
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
    }
  }

  // Start recording
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

  // Stop recording
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

  Future<void> getDashThumb() async {
    String url = 'http://192.168.1.254/NOVATEK/MOVIE/2014_0321_011922_002.MOV?custom=1&cmd=4001';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Thumbnails');
      } else {
        print('Error occured: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> getFilesFromCamera() async {
  //   String url = 'http://192.168.1.254/?custom=1&cmd=3015';
  //
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       final xmlDoc = xml.XmlDocument.parse(response.body);
  //       final fileElements = xmlDoc.findAllElements('File');
  //
  //       // Clear the existing lists before updating
  //       setState(() {
  //         images.clear();
  //         videos.clear();
  //       });
  //
  //       for (final fileElement in fileElements) {
  //         final nameElement = fileElement.findElements('NAME').single;
  //         final filePathElement = fileElement.findElements('FPATH').single;
  //         final timeElement = fileElement.findElements('TIME').single;
  //
  //         final name = nameElement.text;
  //         final filePath = filePathElement.text;
  //         final time = timeElement.text;
  //
  //         final fileItem = FileItem(name, filePath, time);
  //
  //         if (name.endsWith('.JPG')) {
  //           setState(() {
  //             images.add(fileItem);
  //           });
  //         } else if (name.endsWith('.MP4')) {
  //           setState(() {
  //             videos.add(fileItem);
  //           });
  //         }
  //       }
  //     } else {
  //       print('Error occurred: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

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

  // Future<void> takePicture() async {
  //   if (isRecording) {
  //     String url = 'http://192.168.1.254/?custom=1&cmd=1001';
  //
  //     try {
  //       final response = await http.get(Uri.parse(url));
  //
  //       if (response.statusCode == 200) {
  //         print('Image captured');
  //         // await getFilesFromCamera();
  //         // Add snackbar message for a successful capture
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Image captured successfully.'),
  //             duration: Duration(seconds: 2), // Adjust the duration as needed
  //           ),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Image capture failed due to a network issue.'),
  //             duration: Duration(seconds: 2), // Adjust the duration as needed
  //           ),
  //         );
  //         print('Error occurred: ${response.statusCode}');
  //         // Add snackbar message for an error
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Image capture failed due to a network issue.'),
  //           duration: Duration(seconds: 2), // Adjust the duration as needed
  //         ),
  //       );
  //       print('Error: $e');
  //     }
  //   } else {
  //     // Display a snackbar message when recording is not started
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Please start recording before capturing an image.'),
  //         duration: Duration(seconds: 2), // Adjust the duration as needed
  //       ),
  //     );
  //   }
  // }

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

  // 2 -3
  Future<void> camFront() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3028&par=2'));
    if (response.statusCode == 200) {
      setState(() {
        //fileList = json.decode(response.body);
        print('Cam changed');
      });
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  Future<void> camBehind() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3028&par=3'));
    if (response.statusCode == 200) {
      setState(() {
        //fileList = json.decode(response.body);
        print('Cam changed');
      });
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  Future<void> dashCamReset() async {
    final response =
    await http.get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3011'));
    if (response.statusCode == 200) {
      setState(() {
        print('system is reset');
      });
    } else {
      print('System reset Error: ${response.statusCode}');
    }
  }

  Future<void> gSensorSens() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2011&par=2'));
    if (response.statusCode == 200) {
      setState(() {
        print('sensor activated');
      });
    } else {
      print('G sensor Error: ${response.statusCode}');
    }
  }

  // retrieving files
  List<String> fileList = [];

  // Future<void> fetchFiles() async {
  //   final response = await http.get(Uri.parse('http://192.168.1.254'));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       fileList = json.decode(response.body);
  //     });
  //   } else {
  //     print('File error: ${response.statusCode}');
  //   }
  // }

  // Open/Close camera streaming
  Widget buildCameraButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                setDateOfCam();
                widget.toggleCameraStreaming();
                setState(() {
                  // Update the local variable instead
                  isCameraStreaming = !isCameraStreaming;
                });
              },
              icon: Icon(
                Icons.camera,
                size: 45, // Adjust the icon size as needed
              ),
              color: isCameraStreaming ? Colors.red : Colors.black,
            ),
            SizedBox(height: 15),
            SizedBox(width: 15),
            Text(
              isCameraStreaming ? '  Close Camera' : '  Open Camera',
              style: TextStyle(
                color: isCameraStreaming ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Recording part
  Widget buildRecordingButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 1),
        child: Column(
          children: [
            IconButton(
              onPressed: () async {
                setDateOfCam();
                setTimeOfCam();
                if (isRecording) {
                  // Stop record
                  stopRecordingCmd();
                } else {
                  // Start Recording
                  changeToVideoMode();
                  setDateOfCam();
                  setTimeOfCam();
                  startRecordingCmd();
                }
                setState(() {
                  isRecording = !isRecording;
                });
              },
              icon: Icon(
                isRecording ? Icons.stop : Icons.videocam,
                size: 40,
              ),
              color: isRecording ? Colors.red : Colors.black,
            ),
            SizedBox(height: 8),
            Text(
              isRecording ? 'Stop Recording' : 'Start Recording',
              style: TextStyle(
                color: isRecording ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Change camera orientation
  Orientation currentOrientation = Orientation.portrait;
  double rotationAngle = 0.0;

  void _loadRotationAngle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        rotationAngle = prefs.getDouble(rotationAngleKey) ?? 0.0;
      });
    } catch (e) {
      print("Error loading rotation angle: $e");
    }
  }

  void _saveRotationAngle(double angle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setDouble(rotationAngleKey, angle);
    } catch (e) {
      print("Error saving rotation angle: $e");
    }
  }

  void changeOrientation() {
    setState(() {
      rotationAngle += 90.0; // Rotate by 90 degrees
      if (rotationAngle >= 360.0) {
        rotationAngle = 0.0;
      }
      _saveRotationAngle(rotationAngle); // Save the new angle
    });
  }


  // TEST FOR CAMERA
  bool isTakingPictures = false;
  Timer? pictureTimer;
  int pictureCount = 0;

  void startTakingPictures() {
    pictureTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (pictureCount < 15) {
        setDateOfCam();
        setTimeOfCam();
        changeToPhotoMode();
        takePicture();
        changeToVideoMode();
        pictureCount++;
      } else {
        stopTakingPictures();
      }
    });
  }

  void stopTakingPictures() {
    if (pictureTimer != null && pictureTimer!.isActive) {
      pictureTimer!.cancel();
      pictureCount = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: OrientationBuilder(builder: (context, orientation) {
      currentOrientation = orientation;
      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: 360,
                      width: 400,
                      child: isCameraStreaming &&
                          widget.videoPlayerController != null
                          ? Transform.rotate(
                        angle: rotationAngle * 3.14159265359 / 180,
                        // Apply rotation based on user choice
                        child: VlcPlayer(
                          controller: widget.videoPlayerController,
                          aspectRatio: currentOrientation == Orientation.portrait
                                ? 16 / 9
                                : 9 / 16,
                        ),
                      )
                          : Image.asset(
                        // 'images/trb.jpg',
                        'images/test_background3.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    if (isCameraStreaming)
                      Positioned(
                        bottom: 16.0,
                        right: 16.0,
                        child: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.cameraswitch_outlined),
                          // You can choose a different icon
                          onPressed: changeOrientation,
                          iconSize: 48.0, // Adjust the icon size as needed
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 54),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Start and stop camera
                        Center(
                          child: buildCameraButton(),
                        ),

                        SizedBox(height: 5),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildRecordingButton(),
                              SizedBox(width: 40),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // setDateOfCam();
                                        // setTimeOfCam();
                                        // changeToPhotoMode();
                                        // takePicture();
                                        // changeToVideoMode();
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

                        // TEST BUTTON FOR CAMERA
                        // SizedBox(height: 15),
                        // Center(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       SizedBox(width: 15),
                        //       Align(
                        //         alignment: Alignment.center,
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             //only capture image
                        //             IconButton(
                        //               onPressed: () {
                        //                 setDateOfCam();
                        //                 setTimeOfCam();
                        //                 changeToVideoMode();
                        //                 changeToPhotoMode();
                        //                 takePicture();
                        //               },
                        //               icon: Icon(
                        //                 Icons.camera_alt,
                        //                 size: 40,
                        //                 color: Colors.black87,
                        //               ),
                        //             ),
                        //             SizedBox(height: 8),
                        //             Text(
                        //               '   TEST-1',
                        //               style: TextStyle(
                        //                 // color: Color(0xFFa8caba),
                        //                 color: Colors.black87,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       SizedBox(width: 15),
                        //       Align(
                        //         alignment: Alignment.center,
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             IconButton(
                        //               onPressed: () {
                        //                 setDateOfCam();
                        //                 setTimeOfCam();
                        //                 changeToPhotoMode();
                        //                 takePicture();
                        //                 liveViewState();
                        //               },
                        //               icon: Icon(
                        //                 Icons.camera_alt,
                        //                 size: 40,
                        //                 color: Colors.black87,
                        //               ),
                        //             ),
                        //             SizedBox(height: 8),
                        //             Text(
                        //               '   TEST-2',
                        //               style: TextStyle(
                        //                 // color: Color(0xFFa8caba),
                        //                 color: Colors.black87,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       SizedBox(width: 15),
                        //       Align(
                        //         alignment: Alignment.center,
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             IconButton(
                        //               onPressed: () {
                        //                 setDateOfCam();
                        //                 setTimeOfCam();
                        //                 changeToPhotoMode();
                        //                 takePicture();
                        //               },
                        //               icon: Icon(
                        //                 Icons.camera_alt,
                        //                 size: 40,
                        //                 color: Colors.black87,
                        //               ),
                        //             ),
                        //             SizedBox(height: 8),
                        //             Text(
                        //               '   TEST-3',
                        //               style: TextStyle(
                        //                 // color: Color(0xFFa8caba),
                        //                 color: Colors.black87,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       SizedBox(width: 10),
                        //       Align(
                        //         alignment: Alignment.center,
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             IconButton(
                        //               onPressed: () {
                        //                 startTakingPictures();
                        //               },
                        //               icon: Icon(
                        //                 Icons.camera_alt,
                        //                 size: 40,
                        //                 color: Colors.black87,
                        //               ),
                        //             ),
                        //             SizedBox(height: 8),
                        //             Text(
                        //               '   TEST-4',
                        //               style: TextStyle(
                        //                 // color: Color(0xFFa8caba),
                        //                 color: Colors.black87,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      );
      }
    ),
    );
  }
}
