import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lamaradar/mode/dashCamDetails.dart';
import 'package:lamaradar/mode/dashCamFIles.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}


// class _BottomNavBarState extends State<BottomNavBar> {
//   var currentIndex = 0;
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
//   // final List<Widget> _children = [DashCam(),DashCamFiles(),DashCamDetails(),];
//
//
//   @override
//   Widget build(BuildContext context) {
//     double displayWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         foregroundColor: Colors.black,
//         title: const Text('DashCam'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {
//               // Add your settings logic here
//             },
//           ),
//         ],
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             // color: Color(0xFF6497d3),
//             // color: Color(0xFF2580B3),
//             color: Colors.deepPurpleAccent,
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.all(displayWidth * .05),
//         height: displayWidth * .155,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.1),
//               blurRadius: 30,
//               offset: Offset(0, 10),
//             ),
//           ],
//           borderRadius: BorderRadius.circular(50),
//         ),
//         child: ListView.builder(
//           itemCount: 3,
//           scrollDirection: Axis.horizontal,
//           padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
//           itemBuilder: (context, index) => InkWell(
//             onTap: () {
//               setState(() {
//                 currentIndex = index;
//                 HapticFeedback.lightImpact();
//               });
//
//              // test
//               if(index == 0)
//               {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BottomNavBar()),
//                 );
//               }
//               if(index == 1)
//               {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => da2()),
//                 );
//               }
//               if(index == 2)
//               {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => da2()),
//                 );
//               }
//             },
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: Stack(
//               children: [
//                 AnimatedContainer(
//                   duration: Duration(seconds: 1),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   width: index == currentIndex
//                       ? displayWidth * .32
//                       : displayWidth * .26,
//                   alignment: Alignment.center,
//                   child: AnimatedContainer(
//                     duration: Duration(seconds: 1),
//                     curve: Curves.fastLinearToSlowEaseIn,
//                     height: index == currentIndex ? displayWidth * .12 : 0,
//                     width: index == currentIndex ? displayWidth * .32 : 0,
//                     decoration: BoxDecoration(
//                       color: index == currentIndex
//                           ? Colors.blueAccent.withOpacity(.2)
//                           : Colors.transparent,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                 ),
//                 AnimatedContainer(
//                   duration: Duration(seconds: 1),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   width: index == currentIndex
//                       ? displayWidth * .31
//                       : displayWidth * .18,
//                   alignment: Alignment.center,
//                   child: Stack(
//                     children: [
//                       Row(
//                         children: [
//                           AnimatedContainer(
//                             duration: Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             width:
//                             index == currentIndex ? displayWidth * .13 : 0,
//                           ),
//                           AnimatedOpacity(
//                             opacity: index == currentIndex ? 1 : 0,
//                             duration: Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             child: Text(
//                               index == currentIndex
//                                   ? '${listOfStrings[index]}'
//                                   : '',
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           AnimatedContainer(
//                             duration: Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             width:
//                             index == currentIndex ? displayWidth * .03 : 40,
//                           ),
//                           Icon(
//                             listOfIcons[index],
//                             size: displayWidth * .076,
//                             color: index == currentIndex
//                                 ? Colors.blueAccent
//                                 : Colors.black26,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//
//     body: Center(
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
//
//   List<IconData> listOfIcons = [
//     Icons.home_rounded,
//     Icons.image,
//     Icons.details
//   ];
//
//   List<String> listOfStrings = [
//     'Home',
//     'Files',
//     'About',
//   ];
// }


class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    Files(),
    About(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Navigation Demo"),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("Home"),
    );
  }
}

class Files extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("Files"),
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