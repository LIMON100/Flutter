import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:camera/camera.dart';
import 'CollisionWarningPage.dart';

class TempWarning extends StatefulWidget {
  @override
  _TempWarningState createState() => _TempWarningState();
}

class _TempWarningState extends State<TempWarning> {
  int _selectedIndex = 0;

  List<String> _warningAudios = [    'audio/right_warning.mp3',    'audio/left_warning.mp3',    'audio/top_warning.mp3',    'audio/bottom_warning.mp3',  ];

  List<CameraDescription>? _cameras;
  CameraController? _cameraController;

  bool _isCameraInitialized = false;
  bool _isCameraOpened = false;
  bool _isLightOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController =
          CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _playWarningAudio(int index) async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_warningAudios[index]);
  }

  void _toggleCamera() {
    if (_isCameraOpened) {
      _cameraController?.stopImageStream();
      _isCameraOpened = false;
    } else {
      _cameraController?.startImageStream((CameraImage image) {
        // Handle image stream data
      });
      _isCameraOpened = true;
    }
  }


  void _toggleLight() {
    if (_isLightOn) {
      _cameraController?.setFlashMode(FlashMode.off);
      _isLightOn = false;
    } else {
      _cameraController?.setFlashMode(FlashMode.torch);
      _isLightOn = true;
    }
  }
  bool _cameraOn = false;
  bool _lightOn = false;
  bool _powerOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade400,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Warning Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,
            color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Battery Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {
                      // play warning audio for top
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Top'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {
                      // play warning audio for bottom
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Bottom'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      // play warning audio for left
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Left'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      // play warning audio for right
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Right'),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(_cameraOn ? Icons.camera_alt : Icons.camera_alt_outlined),
                    onPressed: () {
                      setState(() {
                        _cameraOn = !_cameraOn;
                      });
                      // open camera if _cameraOn is true
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Camera'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                      icon: Icon(_lightOn ? Icons.lightbulb : Icons.lightbulb_outline),
                      onPressed: () {
                        setState(() {
                          _lightOn = !_lightOn;
                        });
                      }
                  ),
                ],
              ),
            ],),

        ],),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.power_settings_new),
      ),
    );
  }
}
