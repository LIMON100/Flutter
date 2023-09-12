import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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

class FileItem {
  final String name;
  final String filePath;
  // final String size;
  final String time;

  FileItem(this.name, this.filePath, this.time);
}

class FileName {
  final String name;
  FileName(this.name);
}


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
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(0),
          VlcAdvancedOptions.clockJitter(0),
          VlcAdvancedOptions.fileCaching(0),
          VlcAdvancedOptions.liveCaching(0),
        ]),),
    );
    getFilesFromCamera();
  }

  List<FileItem> images = [];
  List<FileItem> videos = [];

  Future<void> getFilesFromCamera() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3015';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final xmlDoc = xml.XmlDocument.parse(response.body);
        final fileElements = xmlDoc.findAllElements('File');

        // Clear the existing lists before updating
        setState(() {
          images.clear();
          videos.clear();
        });

        for (final fileElement in fileElements) {
          final nameElement = fileElement.findElements('NAME').single;
          final filePathElement = fileElement.findElements('FPATH').single;
          final timeElement = fileElement.findElements('TIME').single;

          final name = nameElement.text;
          final filePath = filePathElement.text;
          final time = timeElement.text;

          final fileItem = FileItem(name, filePath, time);

          if (name.endsWith('.JPG')) {
            setState(() {
              images.add(fileItem);
            });
          } else if (name.endsWith('.MP4')) {
            setState(() {
              videos.add(fileItem);
            });
          }
        }
      } else {
        print('Error occurred: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void toggleCameraStreaming() {
    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
    } else {
      _videoPlayerController = VlcPlayerController.network(
        'rtsp://192.168.1.254/xxxx.mp4',
        hwAcc: HwAcc.disabled,
        autoPlay: true,
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(0),
            VlcAdvancedOptions.clockJitter(0),
            VlcAdvancedOptions.fileCaching(0),
            VlcAdvancedOptions.liveCaching(0),
          ]),),
      );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashSettings()),
                );
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
        // body: _children[_currentIndex],
        body: IndexedStack(
          index: _currentIndex,
          children: [
            Home(
              toggleCameraStreaming: toggleCameraStreaming,
              isCameraStreaming: isCameraStreaming,
              videoPlayerController: _videoPlayerController,
              images: images,
              videos: videos,
            ),
            Files(
              isCameraStreaming: isCameraStreaming,
              images: images,
              videos: videos,
            ),
            // About(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          backgroundColor: Colors.indigoAccent,
          // color: Colors.indigo.shade200,
          color: Colors.blueGrey.shade200,
          animationDuration: Duration(milliseconds: 300),
          // currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home,
              color:
              _currentIndex == 0 ? Colors.white : Colors.blueGrey.shade700,
            ),
            Icon(
              Icons.image,
              color:
              _currentIndex == 1 ? Colors.white : Colors.blueGrey.shade700,
            ),
            // Icon(
            //   Icons.history,
            //   color:
            //   _currentIndex == 2 ? Colors.white : Colors.blueGrey.shade700,
            // ),
          ],
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
  List<FileItem> images = [];
  List<FileItem> videos = [];


  Home({
    required this.toggleCameraStreaming,
    required this.isCameraStreaming,
    required this.videoPlayerController,
    required this.images,
    required this.videos,
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
  List<FileItem> images = [];
  List<FileItem> videos = [];


  //IP Address
  final String ipAddress = '192.168.1.254';

  //files

  final String url = 'http://192.168.1.254';
  bool isFront = false;
  bool isSensor = false;
  List<dynamic> wifiNetworks = [];

  // Recording variable
  bool isRecording = false;
  Color buttonColor = Colors.deepPurpleAccent;
  String buttonText = 'Start Recording';

  // Rtsp Streaming
  @override
  void initState() {
    super.initState();
    // flipMovieMirror();
    isCameraStreaming = widget.isCameraStreaming; // Initialize state from widget
    images = widget.images;
    videos = widget.videos;
    initializePlayer();
    movieQualitySet();
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
    } else {
      // Open Camera
      setDateOfCam();
      setTimeOfCam();
      widget.videoPlayerController.play();
    }

    setState(() {
      isCameraStreaming = !isCameraStreaming;
    });
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
      // Delay the pop to ensure the connection process is completed
      // Future.delayed(const Duration(seconds: 3), () {
      //   Navigator.of(context).pop(); // Close the dialog window
      // });
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

  Future<void> dashFileList() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3015';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String xmlString = response.body;
        var document = xml.XmlDocument.parse(xmlString);
        var files = document.findAllElements('NAME');
        for (var file in files) {
          print(file.text);
        }

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

  Future<void> getFilesFromCamera() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3015';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final xmlDoc = xml.XmlDocument.parse(response.body);
        final fileElements = xmlDoc.findAllElements('File');

        // Clear the existing lists before updating
        setState(() {
          images.clear();
          videos.clear();
        });

        for (final fileElement in fileElements) {
          final nameElement = fileElement.findElements('NAME').single;
          final filePathElement = fileElement.findElements('FPATH').single;
          final timeElement = fileElement.findElements('TIME').single;

          final name = nameElement.text;
          final filePath = filePathElement.text;
          final time = timeElement.text;

          final fileItem = FileItem(name, filePath, time);

          if (name.endsWith('.JPG')) {
            setState(() {
              images.add(fileItem);
            });
          } else if (name.endsWith('.MP4')) {
            setState(() {
              videos.add(fileItem);
            });
          }
        }
      } else {
        print('Error occurred: ${response.statusCode}');
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
        await getFilesFromCamera();
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
    print(currentTime);
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

  // Widget buildCameraButton() {
  //   return Align(
  //     alignment: Alignment.topCenter,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 10),
  //       child: CircleButton(
  //         onPressed: () {
  //           setDateOfCam();
  //           widget.toggleCameraStreaming();
  //           setState(() {
  //             // Update the local variable instead
  //             isCameraStreaming = !isCameraStreaming;
  //           });
  //         },
  //         color: isCameraStreaming ? Colors.red : Color(0xFFa8caba),
  //         text: isCameraStreaming ? 'Stop Camera' : 'Open Camera',
  //       ),
  //     ),
  //   );
  // }
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
              color: isCameraStreaming ? Colors.red : Color(0xFFa8caba),
            ),
            SizedBox(height: 15),
            SizedBox(width: 15),
            Text(
              isCameraStreaming ? '  Close Camera' : '  Open Camera',
              style: TextStyle(
                color: isCameraStreaming ? Colors.red : Color(0xFFa8caba),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }




  // Recording part
  // Widget buildRecordingButton() {
  //   return Align(
  //     alignment: Alignment.topCenter,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 10),
  //       child: CircleButton(
  //         onPressed: () async {
  //           setDateOfCam();
  //           setTimeOfCam();
  //           if (isRecording) {
  //             // Stop record
  //             stopRecordingCmd();
  //           } else {
  //             // Start Recording
  //             changeToVideoMode();
  //             setDateOfCam();
  //             setTimeOfCam();
  //             startRecordingCmd();
  //           }
  //           setState(() {
  //             isRecording = !isRecording;
  //           });
  //         },
  //         color: isRecording ? Colors.red : Color(0xFFa8caba),
  //         text: isRecording ? 'Stop Recording' : 'Start Recording',
  //       ),
  //     ),
  //   );
  // }
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
              color: isRecording ? Colors.red : Color(0xFFa8caba),
            ),
            SizedBox(height: 8),
            Text(
              isRecording ? 'Stop Recording' : 'Start Recording',
              style: TextStyle(
                color: isRecording ? Colors.red : Color(0xFFa8caba),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double rotationAngle = 0.0;
  void changeOrientation() {
    setState(() {
      rotationAngle += 90.0; // Rotate by 90 degrees
      print("ROTATE ANGLE");
      print(rotationAngle);
      if (rotationAngle >= 360.0) {
        rotationAngle = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   height: 360,
                //   width: 400,
                //   // child: isCameraStreaming && _controller != null
                //   child: isCameraStreaming && widget.videoPlayerController != null
                //   ?Transform.rotate(
                //     angle: rotationAngle * 3.14159265359 / 180, // Apply rotation based on user choice
                //     child: VlcPlayer(
                //       controller: widget.videoPlayerController,
                //       aspectRatio: 16 / 9, // Adjust this to match your desired aspect ratio
                //     ),
                //   )
                //       : Image.asset(
                //     'images/test_background3.jpg',
                //     fit: BoxFit.fitWidth,
                //   ),
                // ),
                // SizedBox(height: 20.0),
                // if (isCameraStreaming)
                //   IconButton(
                //     icon: Icon(Icons.cameraswitch_outlined), // You can choose a different icon
                //     onPressed: changeOrientation,
                //     iconSize: 48.0, // Adjust the icon size as needed
                //   ),
                Stack(
                  children: [
                    Container(
                      height: 360,
                      width: 400,
                      child: isCameraStreaming && widget.videoPlayerController != null
                          ? Transform.rotate(
                        angle: rotationAngle * 3.14159265359 / 180, // Apply rotation based on user choice
                        child: VlcPlayer(
                          controller: widget.videoPlayerController,
                          aspectRatio: 16 / 9, // Adjust this to match your desired aspect ratio
                        ),
                      )
                          : Image.asset(
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
                          icon: Icon(Icons.cameraswitch_outlined), // You can choose a different icon
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
                        // Center(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment
                        //         .center, // Align buttons in the center
                        //     children: [
                        //       buildRecordingButton(),
                        //       SizedBox(width: 20),
                        //       // Align(
                        //       //   alignment: Alignment.center,
                        //       //   child: CircleButton(
                        //       //     onPressed: () {
                        //       //       setDateOfCam();
                        //       //       setTimeOfCam();
                        //       //       changeToPhotoMode();
                        //       //       takePicture();
                        //       //       changeToVideoMode();
                        //       //     },
                        //       //     color: Color(0xFFa8caba),
                        //       //     text: 'Capture',
                        //       //   ),
                        //       // ),
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
                        //                 changeToVideoMode();
                        //               },
                        //               icon: Icon(
                        //                 Icons.camera_alt,
                        //                 size: 40,
                        //                 color: Color(0xFFa8caba),
                        //               ),
                        //             ),
                        //             SizedBox(height: 4),
                        //             Text(
                        //               'Capture',
                        //               style: TextStyle(
                        //                 color: Color(0xFFa8caba),
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //
                        //     ],
                        //   ),
                        // ),
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
                                        setDateOfCam();
                                        setTimeOfCam();
                                        changeToPhotoMode();
                                        takePicture();
                                        changeToVideoMode();
                                      },
                                      icon: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Color(0xFFa8caba),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '   Capture',
                                      style: TextStyle(
                                        color: Color(0xFFa8caba),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

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
      ),
    );
  }
}

// Future<void> flipMovieMirror() async {
//   final response = await http
//       .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2023&par=4'));
//   if (response.statusCode == 200) {
//   } else {
//     print('Flip Error: ${response.statusCode}');
//   }
// }

Future<void> movieQualitySet() async {
  final response = await http
      .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2024&par=2'));
  if (response.statusCode == 200) {
    print('Movie quality set');
  } else {
    print('Quality Error: ${response.statusCode}');
  }
}

// File class
class Files extends StatefulWidget {
  final bool isCameraStreaming;
  List<FileItem> images = [];
  List<FileItem> videos = [];

  Files({
    required this.isCameraStreaming,
    required this.images,
    required this.videos,
  });

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {

  String? selectedFilePath;
  VideoPlayerController? videoController;

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
  List<FileItem> images = [];
  List<FileItem> videos = [];
  List<FileName> imagesName = [];
  List<FileName> videoName = [];
  bool isLoadingFiles = false;


  @override
  void initState() {
    super.initState();
    movieQualitySet();
    // flipMovieMirror();
    // Fetch files from the camera on page load
    images = widget.images;
    videos = widget.videos;
    Connectivity().onConnectivityChanged.listen((connectivity) {
      if (connectivity == ConnectivityResult.wifi) {
        getFilesFromCamera();
      }
    });
    getFilesFromCamera();
  }

  // Connectivity class to check connection


  // Open File

  void openImageOrPlayVideo(String file) {
    if (file.endsWith('.JPG')) {
      // Display the image
      String thumbnailUrl = 'http://192.168.1.254/CARDV/Photo/$file';
      // Show the image using a dialog or navigate to a new screen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: Image.network(thumbnailUrl),
        ),
      );
    } else if (file.endsWith('.MP4')) {
      // Play the video
      String videoUrl = 'http://192.168.1.254/CARDV/Movie/$file';

      // Initialize the video player controller
      VideoPlayerController controller = VideoPlayerController.network(videoUrl);

      // Show the video player widget
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing the dialog with a tap outside
        builder: (context) {
          // Add a listener to detect when the dialog is dismissed
          void handleDialogDismiss() {
            controller.pause(); // Pause the video playback
            controller.seekTo(Duration.zero); // Rewind the video to the beginning
            controller.dispose(); // Dispose of the video player controller
          }

          // Create the dialog content with video player and cross icon
          Widget dialogContent = GestureDetector(
            onTap: () {}, // Prevent accidental tap dismissal
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(controller),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),
                      color: Colors.red, // Set the color to red
                      onPressed: () {
                        handleDialogDismiss();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );

          // Initialize and play the video
          controller.initialize().then((_) {
            controller.play();
          });

          // Add a listener to detect when the dialog is dismissed
          return WillPopScope(
            onWillPop: () async {
              handleDialogDismiss();
              return true;
            },
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0.0),
              content: dialogContent,
            ),
          );
        },
      );
    }
  }

  Future<void> getFilesFromCamera() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3015';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final xmlDoc = xml.XmlDocument.parse(response.body);
        final fileElements = xmlDoc.findAllElements('File');

        // Clear the existing lists before updating
        setState(() {
          images.clear();
          videos.clear();
        });

        for (final fileElement in fileElements) {
          final nameElement = fileElement.findElements('NAME').single;
          final filePathElement = fileElement.findElements('FPATH').single;
          final timeElement = fileElement.findElements('TIME').single;

          final name = nameElement.text;
          final filePath = filePathElement.text;
          final time = timeElement.text;

          final fileItem = FileItem(name, filePath, time);
          final fileName = FileName(name);

          if (name.endsWith('.JPG')) {
            setState(() {
              images.add(fileItem);
              imagesName.add(fileName);
            });
          } else if (name.endsWith('.MP4')) {
            setState(() {
              videos.add(fileItem);
              videoName.add(fileName);
            });
          }
        }
      } else {
        print('Error occurred: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Delete file
  Future<void> deleteFile(String filePath) async {
    final Uri url;

    if (filePath.endsWith('.JPG')) {
      url = Uri.parse('http://192.168.1.254/CARDV/photo/$filePath');
    } else {
      url = Uri.parse('http://192.168.1.254/CARDV/Movie/$filePath');
    }

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('File deleted successfully');
        await getFilesFromCamera();
      } else {
        print('Failed to delete file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to delete file: $e');
    }
  }

  // Delete all files
  // Future<void> deleteAllFiles() async {
  //   final url = Uri.parse('http://192.168.1.254/?custom=1&cmd=4004');
  //
  //   try {
  //     if (current == 0) {
  //       // Delete all files
  //       final response = await http.get(url);
  //       if (response.statusCode == 200) {
  //         print('All files deleted successfully');
  //         await getFilesFromCamera();
  //       } else {
  //         print('Failed to delete all files. Status code: ${response.statusCode}');
  //       }
  //     } else if (current == 1) {
  //       // Delete only videos
  //       // Add your logic to delete video files here
  //     } else if (current == 2) {
  //       // Delete only images
  //       // Add your logic to delete image files here
  //     }
  //   } catch (e) {
  //     print('Failed to delete files: $e');
  //   }
  // }
  Future<void> deleteAllFiles() async {
    try {
      if (current == 0) {
        // Delete all files
        final allFilesUrl = Uri.parse('http://192.168.1.254/?custom=1&cmd=4004');
        final response = await http.get(allFilesUrl);
        if (response.statusCode == 200) {
          print('All files deleted successfully');
          await getFilesFromCamera();
        } else {
          print('Failed to delete all files. Status code: ${response.statusCode}');
        }
      } else if (current == 1) {
        // Delete only videos
        final videosUrl = Uri.parse('http://192.168.1.254/CARDV/movie/');
        final response = await http.get(videosUrl);
        if (response.statusCode == 200) {
          for (final fileName in videoName) {
            final filePath = fileName.name;
            final deleteUrl = Uri.parse('http://192.168.1.254/CARDV/movie/$filePath');
            final deleteResponse = await http.delete(deleteUrl);
            if (deleteResponse.statusCode == 200) {
              print('Deleted file: $fileName');
            } else {
              print('Failed to delete file: $fileName. Status code: ${deleteResponse.statusCode}');
            }
          }
          await getFilesFromCamera();
        } else {
          print('Failed to delete videos. Status code: ${response.statusCode}');
        }
      } else if (current == 2) {
        // Delete only images
        final imagesUrl = Uri.parse('http://192.168.1.254/CARDV/photo/');
        final response = await http.get(imagesUrl);
        if (response.statusCode == 200) {
          for (final fileName in imagesName) {
            final filePath = fileName.name;
            final deleteUrl2 = Uri.parse('http://192.168.1.254/CARDV/photo/$filePath');
            final deleteResponse = await http.delete(deleteUrl2);
            if (deleteResponse.statusCode == 200) {
              print('Deleted file: $fileName');
            } else {
              print('Failed to delete file: $fileName. Status code: ${deleteResponse.statusCode}');
            }
          }
          await getFilesFromCamera();
        }
        else {
          print('Failed to delete images. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Failed to delete files: $e');
    }
  }



  // Download Files to gallery
  // void downloadFile(String url) async {
  //   if (url.endsWith('.JPG')) {
  //     url = 'http://192.168.1.254/CARDV/photo/$url';
  //   } else {
  //     url = 'http://192.168.1.254/CARDV/Movie/$url';
  //   }
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final bytes = response.bodyBytes;
  //       final fileName = url.split('/').last;
  //       final directory = await getTemporaryDirectory();
  //       final filePath = '${directory.path}/$fileName';
  //       final file = File(filePath);
  //       await file.writeAsBytes(bytes);
  //
  //       // Save the file to the gallery
  //       await GallerySaver.saveImage(filePath);
  //       print('File saved to gallery');
  //
  //       // Delete the temporary file
  //       await file.delete();
  //     } else {
  //       print('Error downloading file: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error downloading file: $e');
  //   }
  // }

  // Download files
  bool _isDownloading = false;
  double _progress = 0.0;
  int? _downloadIndex;
  // int receivedBytes = 0;

  void _downloadFile(String url, int index) async {
    if (url.endsWith('.JPG')) {
      url = 'http://192.168.1.254/CARDV/photo/$url';
    } else {
      url = 'http://192.168.1.254/CARDV/Movie/$url';
    }

    setState(() {
      _isDownloading = true;
      _progress = 0.0;
      _downloadIndex = index;
    });

    try {
      final response = await http.get(Uri.parse(url),
          headers: {'Accept-Encoding': 'identity'});

      if (response.statusCode == 200) {
        final totalBytes = response.contentLength?.toDouble() ?? 0.0;
        final fileName = url.split('/').last;
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        int receivedBytes = 0;

        final bytes = response.bodyBytes;

        final completer = Completer<void>();

        final fileStream = file.openWrite();

        fileStream.add(bytes);
        receivedBytes += bytes.length;
        print("Progress in receivebytes");
        setState(() {
          _progress = receivedBytes.toDouble() / totalBytes;
        });

        await fileStream.close();


        if (url.endsWith('.JPG')) {
          await GallerySaver.saveImage(filePath);
        } else {
          await GallerySaver.saveVideo(filePath);
        }

        print('File saved to gallery: $fileName');

        setState(() {
          _isDownloading = false;
        });

        Fluttertoast.showToast(
          msg: 'Download complete',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        print('Error downloading file: ${response.statusCode}');
        setState(() {
          _isDownloading = false;
        });
      }
    } catch (e) {
      print('Error downloading file: $e');
      setState(() {
        _isDownloading = false;
      });
    }
  }

  // void _downloadFile(String url, int index) async {
  //   if (url.endsWith('.JPG')) {
  //     url = 'http://192.168.1.254/CARDV/photo/$url';
  //   } else {
  //     url = 'http://192.168.1.254/CARDV/Movie/$url';
  //   }
  //
  //   setState(() {
  //     _isDownloading = true;
  //     _progress = 0.0;
  //     _downloadIndex = index;
  //   });
  //
  //   try {
  //     final response = await http.get(Uri.parse(url),
  //         headers: {'Accept-Encoding': 'identity'});
  //
  //     if (response.statusCode == 200) {
  //       final totalBytes = response.contentLength?.toDouble() ?? 0.0;
  //       final fileName = url.split('/').last;
  //       final directory = await getTemporaryDirectory();
  //       final filePath = '${directory.path}/$fileName';
  //       final file = File(filePath);
  //       num? receivedBytes = 0;
  //
  //       final bytes = response.bodyBytes;
  //
  //       final completer = Completer<void>();
  //
  //       final fileStream = file.openWrite();
  //
  //       fileStream.addStream(
  //         Stream.fromIterable(bytes).map((chunk) {
  //           receivedBytes = receivedBytes! + chunk.bitLength;
  //           setState(() {
  //             _progress = receivedBytes!.toDouble() / totalBytes;
  //           });
  //           print("Check chunk");
  //           print(chunk);
  //           return [chunk];
  //         }),
  //       ).whenComplete(() {
  //         fileStream.close();
  //         completer.complete(); // Notify that download is complete
  //       });
  //
  //       if (url.endsWith('.JPG')) {
  //         await GallerySaver.saveImage(filePath);
  //       } else {
  //         await GallerySaver.saveVideo(filePath);
  //       }
  //
  //       print('File saved to gallery: $fileName');
  //
  //       setState(() {
  //         _isDownloading = false;
  //       });
  //
  //       Fluttertoast.showToast(
  //         msg: 'Download complete',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //     } else {
  //       print('Error downloading file: ${response.statusCode}');
  //       setState(() {
  //         _isDownloading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error downloading file: $e');
  //     setState(() {
  //       _isDownloading = false;
  //     });
  //   }
  // }


  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    List<FileItem> displayItems;

    if (current == 1) {
      // Show videos
      displayItems = videos;
    } else if (current == 2) {
      // Show images
      displayItems = images;
    } else {
      // Show all items
      displayItems = [...videos, ...images];
    }

    final bool allFiles = videos.isNotEmpty;
    final bool hasVideos = videos.isNotEmpty;
    final bool hasImages = images.isNotEmpty;
    final bool showTabs = hasVideos || hasImages;
    final bool showEmptyTabs = videos.isEmpty || images.isEmpty;


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(45),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  final bool showTab =
                      (index == 0 && (allFiles || !showTabs || showEmptyTabs)) || (index == 1 && (hasVideos || !showTabs || showEmptyTabs)) || (index == 2 && (hasImages || !showTabs || showEmptyTabs));
                  return Visibility(
                    visible: showTab,
                    child: Column(
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
                              color: current == index ? Colors.white70 : Colors.white54,
                              borderRadius: current == index ? BorderRadius.circular(15) : BorderRadius.circular(10),
                              border: current == index ? Border.all(color: Colors.deepPurpleAccent, width: 2) : null,
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: GoogleFonts.laila(
                                  fontWeight: FontWeight.w500,
                                  color: current == index ? Colors.black : Colors.grey,
                                ),
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
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Container(
            //       margin: const EdgeInsets.only(top: 30),
            //       width: double.infinity,
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           if (displayItems.isEmpty)
            //             Icon(
            //               icons[current],
            //               size: 200,
            //               color: Colors.deepPurple,
            //             ),
            //           if (displayItems.isEmpty) const SizedBox(height: 10),
            //           if (displayItems.isEmpty)
            //             Text(
            //               items[current],
            //               style: GoogleFonts.laila(
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 30,
            //                 color: Colors.deepPurple,
            //               ),
            //             ),
            //           SizedBox(height: 20),
            //           if (displayItems.isNotEmpty)
            //           // WITH ICON
            //             ListView.builder(
            //               shrinkWrap: true,
            //               physics: NeverScrollableScrollPhysics(),
            //               itemCount: displayItems.length,
            //               itemBuilder: (context, index) {
            //                 final bool isImage = displayItems[index].name.endsWith('.JPG');
            //                 final bool isVideo = displayItems[index].name.endsWith('.MP4');
            //
            //                 IconData iconData;
            //                 if (isImage) {
            //                   iconData = Icons.photo;
            //                 } else if (isVideo) {
            //                   iconData = Icons.videocam;
            //                 } else {
            //                   // Handle other file types if needed
            //                   iconData = Icons.insert_drive_file;
            //                 }
            //
            //                 return ListTile(
            //                   leading: Icon(iconData),
            //                   title: Text(displayItems[index].name),
            //                   subtitle: Text(displayItems[index].time),
            //                   trailing: IconButton(
            //                     icon: Icon(Icons.delete),
            //                     onPressed: () {
            //                       deleteFile(displayItems[index].name.toString());
            //                     },
            //                   ),
            //                   onTap: () {
            //                     openImageOrPlayVideo(displayItems[index].name);
            //                   },
            //                 );
            //               },
            //             ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (displayItems.isNotEmpty)
                        ListTile(
                          leading: Icon(Icons.delete_forever),
                          title: Text('Delete All Files'),
                          onTap: () {
                            deleteAllFiles();
                          },
                        ),
                      if (displayItems.isEmpty)
                        Icon(
                          icons[current],
                          size: 200,
                          color: Colors.deepPurple,
                        ),
                      if (displayItems.isEmpty) const SizedBox(height: 10),
                      if (displayItems.isEmpty)
                        Text(
                          items[current],
                          style: GoogleFonts.laila(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                            color: Colors.deepPurple,
                          ),
                        ),
                      SizedBox(height: 20),
                      if (displayItems.isNotEmpty)
                      // WITH ICON
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: displayItems.length,
                          itemBuilder: (context, index) {
                            final bool isImage = displayItems[index].name.endsWith('.JPG');
                            final bool isVideo = displayItems[index].name.endsWith('.MP4');

                            IconData iconData;
                            if (isImage) {
                              iconData = Icons.photo;
                            } else if (isVideo) {
                              iconData = Icons.videocam;
                            } else {
                              // Handle other file types if needed
                              iconData = Icons.insert_drive_file;
                            }
                            if (_isDownloading && _downloadIndex == index) {
                              // Show circular progress bar and cancel option
                              return ListTile(
                                leading: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    value: _progress,
                                    strokeWidth: 2.0,
                                    backgroundColor: Colors.black,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                  ),
                                ),
                                title: Text(displayItems[index].name),
                                subtitle: Text(displayItems[index].time),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _isDownloading = false;
                                      _downloadIndex = -1;
                                    });
                                  },
                                ),
                              );
                            } else {
                              // Show regular list tile with download button
                              return ListTile(
                                leading: Icon(iconData),
                                title: Text(displayItems[index].name),
                                subtitle: Text(displayItems[index].time),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        deleteFile(displayItems[index].name.toString());
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.download),
                                      onPressed: _isDownloading
                                          ? null
                                          : () => _downloadFile(displayItems[index].name.toString(), index),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  openImageOrPlayVideo(displayItems[index].name);
                                },
                              );
                            }

                          },
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
//       // backgroundColor: Colors.deepPurple.shade100,
//       backgroundColor: Colors.transparent,
//       body: Container(
//         alignment: Alignment.center,
//         child: Text("About"),
//       ),
//     );
//   }
// }
