// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:lamaradar/mode/dashCamDetails.dart';
// import 'package:lamaradar/mode/dashCamFIles.dart';
// import 'bleScreen.dart';
//
// class DashCam extends StatefulWidget {
//   const DashCam({Key? key}) : super(key: key);
//
//   @override
//   _DashCamState createState() => _DashCamState();
// }
//
// class _DashCamState extends State<DashCam> {
//
//   late CameraController _cameraController;
//   late List<CameraDescription> _cameras;
//   bool _isCameraReady = false;
//   bool _isFlashOn = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     // Get available cameras
//     _cameras = await availableCameras();
//     if (_cameras.length > 0) {
//       // Select the first available camera
//       _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
//
//       // Add a listener to know when the camera is initialized
//       _cameraController.initialize().then((_) {
//         if (!mounted) {
//           return;
//         }
//         setState(() {
//           _isCameraReady = true;
//         });
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }
//
//   int _currentIndex = 0;
//
//   final List<Widget> _children = [DashCam(),DashCamFiles(),DashCamDetails(),];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         foregroundColor: Colors.black,
//         title: const Text('DashCam'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {
//
//             },
//           ),
//         ],
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                   builder: (context) => BleScreen(title: '')
//               ),
//             );// Navigate to previous screen
//           },
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             // color: Color(0xFF6497d3),
//             // color: Color(0xFF2580B3),
//             color: Colors.deepPurpleAccent,
//           ),
//         ),
//       ),
//       backgroundColor: Colors.deepPurple.shade100,
//       _children[_currentIndex],
//       bottomNavigationBar: CurvedNavigationBar(
//         height: 50,
//         backgroundColor: Colors.indigoAccent,
//         color: Colors.indigo.shade200,
//         animationDuration: Duration(milliseconds: 300),
//         onTap: (index){
//           setState(() {
//             _currentIndex = index;
//           });
//           if(_currentIndex == 0)
//           {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DashCam()),
//             );
//           }
//           if(_currentIndex == 1)
//           {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DashCamFiles()),
//             );
//           }
//           if(_currentIndex == 2)
//           {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DashCamDetails()),
//             );
//           }
//         },
//         items: [
//           Icon(
//             Icons.home,
//             color: _currentIndex == 0 ? Colors.white : Colors.blueGrey.shade700,
//           ),
//           Icon(
//             Icons.image,
//             color: _currentIndex == 1 ? Colors.white : Colors.blueGrey.shade700,
//           ),
//           Icon(
//             Icons.history,
//             color: _currentIndex == 2 ? Colors.white : Colors.blueGrey.shade700,
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _isCameraReady
//                 ? AspectRatio(
//               aspectRatio: _cameraController.value.aspectRatio,
//               child: CameraPreview(_cameraController),
//             )
//                 : CircularProgressIndicator(),
//             ElevatedButton(
//               onPressed: () {
//                 // Add your camera logic here
//               },
//               child: Text('Open Camera'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.deepPurpleAccent.shade200, // Change button color here
//               ),
//             ),
//
//             SizedBox(height: 200),
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.deepPurpleAccent.shade200,
//               ),
//               child: InkWell(
//                 onTap: () {
//                   // Do something when the button is pressed
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.wifi,
//                       color: Colors.white,
//                     ),
//                     Text(
//                       'Connect WIFI',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// another part

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lamaradar/mode/dashCamDetails.dart';
import 'package:lamaradar/mode/dashCamFIles.dart';
import 'bleScreen.dart';
import 'package:google_fonts/google_fonts.dart';

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
          title: const Text('DashCam'),
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


class Home extends StatelessWidget {

  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraReady = false;
  bool _isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
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

            SizedBox(height: 200),
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

            /// MAIN BODY
            // Container(
            //   margin: const EdgeInsets.only(top: 30),
            //   width: double.infinity,
            //   height: 350,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(
            //         icons[current],
            //         size: 200,
            //         color: Colors.deepPurple,
            //       ),
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       Text(
            //         items[current],
            //         style: GoogleFonts.laila(
            //             fontWeight: FontWeight.w500,
            //             fontSize: 30,
            //             color: Colors.deepPurple),
            //       ),
            //     ],
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

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Container(
        alignment: Alignment.center,
        child: Text("About"),
      ),
    );
  }
}