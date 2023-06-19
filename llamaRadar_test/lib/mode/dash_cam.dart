import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lamaradar/mode/settings.dart';
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
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

import 'package:video_player/video_player.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

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
      'rtsp://192.168.1.254/xxxx.mov',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  void toggleCameraStreaming() {
    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
    } else {
      _videoPlayerController = VlcPlayerController.network(
        'rtsp://192.168.1.254/xxxx.mov',
        hwAcc: HwAcc.full,
        autoPlay: true,
        options: VlcPlayerOptions(),
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
                MaterialPageRoute(builder: (context) => BleScreen(title: '')),
              ); // Navigate to previous screen
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Color(0xFF517fa4)
                // color: Color(0xFF6497d3),
                // color: Color(0xFF2580B3),
                // color: Colors.deepPurpleAccent,
                // color: Colors.deepPurple[400],
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
            ),
            Files(
              isCameraStreaming: isCameraStreaming,
            ),
            About(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          backgroundColor: Colors.indigoAccent,
          color: Colors.indigo.shade200,
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
            Icon(
              Icons.history,
              color:
                  _currentIndex == 2 ? Colors.white : Colors.blueGrey.shade700,
            ),
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

  Home({
    required this.toggleCameraStreaming,
    required this.isCameraStreaming,
    required this.videoPlayerController,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //WIFI
  final String ssid = 'CARDV';
  final password = '12345678';
  bool isConnected = false;
  bool isCameraStreaming = false;


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
    isCameraStreaming = widget.isCameraStreaming; // Initialize state from widget
    initializePlayer();
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
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Permission Error'),
    //         content: Text('Please turn on Wi-Fi first.'),
    //         actions: [
    //           ElevatedButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
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

  Widget buildCameraButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: CircleButton(
          onPressed: () {
            setDateOfCam();
            widget.toggleCameraStreaming();
            setState(() {
              // Update the local variable instead
              isCameraStreaming = !isCameraStreaming;
            });
          },
          color: isCameraStreaming ? Colors.red : Color(0xFFa8caba),
          text: isCameraStreaming ? 'Stop Camera' : 'Open Camera',
        ),
      ),
    );
  }

  // Recording part
  Widget buildRecordingButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: CircleButton(
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
          color: isRecording ? Colors.red : Color(0xFFa8caba),
          text: isRecording ? 'Stop Recording' : 'Start Recording',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 400,
                width: 400,
                // child: isCameraStreaming && _controller != null
                child: isCameraStreaming && widget.videoPlayerController != null
                //     ? VlcPlayer(
                //   controller: widget.videoPlayerController,
                //   aspectRatio: 16 / 9,
                //   placeholder: Center(child: CircularProgressIndicator()),
                // )
                    ? Transform.rotate(
                  angle: 3.14159,
                  alignment: Alignment.center,
                  //transform: Matrix4.rotationY(1*2*3.14159),
                  child: VlcPlayer(
                    controller: widget.videoPlayerController,
                    aspectRatio: 16 / 9,
                    placeholder: Center(child: CircularProgressIndicator()),
                  ),
                )
                    : Image.asset(
                  'images/test_background3.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(height: 30),
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
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Align buttons in the center
                          children: [
                            buildRecordingButton(),
                            SizedBox(width: 15),
                            Align(
                              alignment: Alignment.center,
                              child: CircleButton(
                                onPressed: () {
                                  setDateOfCam();
                                  setTimeOfCam();
                                  changeToPhotoMode();
                                  takePicture();
                                  changeToVideoMode();
                                },
                                color: Color(0xFFa8caba),
                                text: 'Capture',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100),
              // InkWell(
              //   onTap: () {
              //     _scanWifiNetworks(context);
              //   },
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.wifi,
              //         color: isConnected ? Colors.green : Colors.black,
              //         size: 50,
              //       ),
              //       Text(
              //         isConnected ? 'Disconnected' : 'Connect WIFI',
              //         style: TextStyle(
              //           color: isConnected ? Colors.green : Colors.black,
              //           fontSize: 20,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// File class
class Files extends StatefulWidget {
  final bool isCameraStreaming;
  // final bool isLoadingFiles;

  Files({
    required this.isCameraStreaming,
    // required this.isLoadingFiles,
  });

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {

  String? selectedFilePath;
  VideoPlayerController? videoController;

  // Open File
  void openImageOrPlayVideo(String file) {
    if (file.endsWith('.JPG')) {
      // Display the image
      String thumbnailUrl = 'http://192.168.1.254/CARDV/Photo/$file';
      print(thumbnailUrl);
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

          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            content: dialogContent,
          );
        },
      );
    }
  }


  @override
  void initState() {
    super.initState();
    // Fetch files from the camera on page load
    getFilesFromCamera();
  }

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
  bool isLoadingFiles = false;

  Future<void> getFilesFromCamera() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3015';

    try {
      final response = await http.get(Uri.parse(url));
      // print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final xmlDoc = xml.XmlDocument.parse(response.body);
        final fileElements = xmlDoc.findAllElements('File');

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
                      (index == 0 && (allFiles || !showTabs)) || (index == 1 && (hasVideos || !showTabs)) || (index == 2 && (hasImages || !showTabs));

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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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

                            return ListTile(
                              leading: Icon(iconData),
                              title: Text(displayItems[index].name),
                              subtitle: Text(displayItems[index].time),
                              onTap: () {
                                openImageOrPlayVideo(displayItems[index].name);
                              },
                            );
                          },
                        ),

                      // GridView.builder(
                      //   shrinkWrap: true,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2,
                      //     crossAxisSpacing: 2.0,
                      //     mainAxisSpacing: 2.0,
                      //   ),
                      //   itemCount: displayItems.length,
                      //   itemBuilder: (context, index) {
                      //     final bool isSelected = selectedFilePath == displayItems[index].filePath;
                      //     return Container(
                      //       width: 80,
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           openImageOrPlayVideo(displayItems[index].name);
                      //         },
                      //         child: Card(
                      //           color: isSelected ? Colors.blueGrey.withOpacity(0.3) : null,
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               SizedBox(
                      //                 height: 40, // Adjust the size of the icon
                      //                 child: displayItems[index].name.endsWith('.JPG')
                      //                     ? Icon(Icons.photo, size: 40) // Specify the desired size of the photo icon
                      //                     : Icon(Icons.videocam, size: 40), // Specify the desired size of the video icon
                      //               ),
                      //               Text(displayItems[index].name),
                      //               Text(displayItems[index].time),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
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


class About extends StatelessWidget {
  final String weburl = 'http://192.168.1.254/CARDV/PHOTO/';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepPurple.shade100,
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
          child: Text("About"),
        ),
      );
  }
}
