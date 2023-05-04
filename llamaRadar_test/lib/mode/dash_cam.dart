import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lamaradar/mode/dashCamDetails.dart';
import 'package:lamaradar/mode/dashCamFIles.dart';

class DashCam extends StatefulWidget {
  const DashCam({Key? key}) : super(key: key);

  @override
  _DashCamState createState() => _DashCamState();
}

class _DashCamState extends State<DashCam> {

  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraReady = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get available cameras
    _cameras = await availableCameras();
    if (_cameras.length > 0) {
      // Select the first available camera
      _cameraController = CameraController(_cameras[0], ResolutionPreset.high);

      // Add a listener to know when the camera is initialized
      _cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isCameraReady = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;

  final List<Widget> _children = [DashCam(),DashCamFiles(),DashCamDetails(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('DashCam'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add your settings logic here
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            // color: Color(0xFF2580B3),
            color: Colors.deepPurpleAccent,
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.indigoAccent,
        color: Colors.indigo.shade200,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
          if(index == 0)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashCam()),
            );
          }
          if(index == 1)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashCamFiles()),
            );
          }
          if(index == 2)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashCamDetails()),
            );
          }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isCameraReady
                ? AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            )
                : CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () {
                // Add your camera logic here
              },
              child: Text('Open Camera'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent.shade200, // Change button color here
              ),
            ),

            SizedBox(height: 150),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurpleAccent.shade200,
              ),
              child: InkWell(
                onTap: () {
                  // Do something when the button is pressed
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi,
                      color: Colors.white,
                    ),
                    Text(
                      'Connect WIFI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

