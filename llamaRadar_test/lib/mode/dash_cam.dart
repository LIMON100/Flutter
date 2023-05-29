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

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:lamaradar/mode/dashCamDetails.dart';
// import 'package:lamaradar/mode/dashCamFIles.dart';
// import 'bleScreen.dart';
// import 'package:google_fonts/google_fonts.dart';
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
//
//   final List<Widget> _children = [
//     Home(),
//     Files(),
//     About(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFFa8caba), Color(0xFF517fa4)],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           centerTitle: true,
//           foregroundColor: Colors.black,
//           title: const Text('DashCam'),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.settings),
//               onPressed: () {
//
//               },
//             ),
//           ],
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                     builder: (context) => BleScreen(title: '')
//                 ),
//               );// Navigate to previous screen
//             },
//           ),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               // color: Color(0xFF6497d3),
//               // color: Color(0xFF2580B3),
//               // color: Colors.deepPurpleAccent,
//               color: Colors.deepPurple[400],
//             ),
//           ),
//         ),
//         body:_children[_currentIndex],
//         bottomNavigationBar: CurvedNavigationBar(
//           height: 50,
//           backgroundColor: Colors.indigoAccent,
//           color: Colors.indigo.shade200,
//           animationDuration: Duration(milliseconds: 300),
//           // currentIndex: _currentIndex,
//           onTap: (index){
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           items: [
//             Icon(
//               Icons.home,
//               color: _currentIndex == 0 ? Colors.white : Colors.blueGrey.shade700,
//             ),
//             Icon(
//               Icons.image,
//               color: _currentIndex == 1 ? Colors.white : Colors.blueGrey.shade700,
//             ),
//             Icon(
//               Icons.history,
//               color: _currentIndex == 2 ? Colors.white : Colors.blueGrey.shade700,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class Home extends StatelessWidget {
//
//   late CameraController _cameraController;
//   late List<CameraDescription> _cameras;
//   bool _isCameraReady = false;
//   bool _isFlashOn = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple[100],
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
//
//
// class Files extends StatefulWidget {
//   @override
//   _FilesState createState() => _FilesState();
// }
//
// class _FilesState extends State<Files> {
// // class Files extends StatelessWidget {
//   int _currentIndex = 0;
//
//   List<String> items = [
//     "All",
//     "Video",
//     "Photos",
//   ];
//
//   /// List of body icon
//   List<IconData> icons = [
//     Icons.home,
//     Icons.video_file,
//     Icons.photo,
//   ];
//   int current = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple[100],
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         margin: const EdgeInsets.all(45),
//         child: Column(
//           children: [
//             /// CUSTOM TABBAR
//             SizedBox(
//               width: double.infinity,
//               height: 60,
//               child: ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: items.length,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (ctx, index) {
//                     return Column(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               current = index;
//                             });
//                           },
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             margin: const EdgeInsets.all(5),
//                             width: 90,
//                             height: 45,
//                             decoration: BoxDecoration(
//                               color: current == index
//                                   ? Colors.white70
//                                   : Colors.white54,
//                               borderRadius: current == index
//                                   ? BorderRadius.circular(15)
//                                   : BorderRadius.circular(10),
//                               border: current == index
//                                   ? Border.all(
//                                   color: Colors.deepPurpleAccent, width: 2)
//                                   : null,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 items[index],
//                                 style: GoogleFonts.laila(
//                                     fontWeight: FontWeight.w500,
//                                     color: current == index
//                                         ? Colors.black
//                                         : Colors.grey),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Visibility(
//                             visible: current == index,
//                             child: Container(
//                               width: 5,
//                               height: 5,
//                               decoration: const BoxDecoration(
//                                   color: Colors.deepPurpleAccent,
//                                   shape: BoxShape.circle),
//                             ))
//                       ],
//                     );
//                   }),
//             ),
//
//             /// MAIN BODY
//             // Container(
//             //   margin: const EdgeInsets.only(top: 30),
//             //   width: double.infinity,
//             //   height: 350,
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       Icon(
//             //         icons[current],
//             //         size: 200,
//             //         color: Colors.deepPurple,
//             //       ),
//             //       const SizedBox(
//             //         height: 10,
//             //       ),
//             //       Text(
//             //         items[current],
//             //         style: GoogleFonts.laila(
//             //             fontWeight: FontWeight.w500,
//             //             fontSize: 30,
//             //             color: Colors.deepPurple),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 30),
//                   width: double.infinity,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         icons[current],
//                         size: 200,
//                         color: Colors.deepPurple,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         items[current],
//                         style: GoogleFonts.laila(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 30,
//                             color: Colors.deepPurple),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
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
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:lamaradar/mode/dashCamDetails.dart';
// import 'package:lamaradar/mode/dashCamFIles.dart';
// import 'bleScreen.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:wifi_iot/wifi_iot.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
//
//
// class DashCam extends StatefulWidget {
//   const DashCam({Key? key}) : super(key: key);
//
//   @override
//   _DashCamState createState() => _DashCamState();
// }
//
//
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
//
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }
//
//   int _currentIndex = 0;
//
//
//   final List<Widget> _children = [
//     Home(),
//     Files(),
//     About(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFFa8caba), Color(0xFF517fa4)],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           centerTitle: true,
//           foregroundColor: Colors.black,
//           title: const Text('Dash Cam'),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.settings),
//               onPressed: () {
//
//
//               },
//             ),
//           ],
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                     builder: (context) => BleScreen(title: '')
//                 ),
//               );// Navigate to previous screen
//             },
//           ),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               // color: Color(0xFF6497d3),
//               // color: Color(0xFF2580B3),
//               // color: Colors.deepPurpleAccent,
//               color: Colors.deepPurple[400],
//             ),
//           ),
//         ),
//         body:_children[_currentIndex],
//         bottomNavigationBar: CurvedNavigationBar(
//           height: 50,
//           backgroundColor: Colors.indigoAccent,
//           color: Colors.indigo.shade200,
//           animationDuration: Duration(milliseconds: 300),
//           // currentIndex: _currentIndex,
//           onTap: (index){
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           items: [
//             Icon(
//               Icons.home,
//               color: _currentIndex == 0 ? Colors.white : Colors.blueGrey.shade700,
//             ),
//             Icon(
//               Icons.image,
//               color: _currentIndex == 1 ? Colors.white : Colors.blueGrey.shade700,
//             ),
//             Icon(
//               Icons.history,
//               color: _currentIndex == 2 ? Colors.white : Colors.blueGrey.shade700,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class Home extends StatelessWidget {
//
//   //WIFI
//   final String ssid = 'CAMERA';
//   final  password = '12345678';
//
//   //IP Address
//   final String ipAddress = '192.168.1.254';
//
//   //files
//   final String url = 'http://192.168.1.254';
//
//   Future<String> getFileData() async {
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       return response.body;
//     } else {
//       throw Exception('file not');
//     }
//   }
//
//
//
//
//   Future<void> connectToWiFi() async {
//
//     //bool isConnected = await WiFiForIoTPlugin.connect(ssid: ssid, password: password);
//     bool isConnected = await WiFiForIoTPlugin.connect(ssid, password: password);
//
//     if (isConnected) {
//       // Wi-Fi connection successful
//       print('Connected to $ssid');
//     } else {
//       // Wi-Fi connection failed
//       print('Failed to connect to $ssid');
//     }
//   }
//
//
//
//   // function will be here
//   final VlcPlayerController _videoPlayerController = VlcPlayerController.network(
//     'rtsp://192.168.1.254/xxxx.mov',
//     hwAcc: HwAcc.full,
//     autoPlay: true,
//     options: VlcPlayerOptions(),
//   );
//
//   void playVlc() {
//     VlcPlayer(
//       controller: _videoPlayerController,
//       aspectRatio: 16 / 9,
//       placeholder: Center(child: CircularProgressIndicator()),
//     );
//   }
//
//
//   late CameraController _cameraController;
//   late List<CameraDescription> _cameras;
//   bool _isCameraReady = false;
//   bool _isFlashOn = false;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: Colors.deepPurple[100],
//       body: Center(
//
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _isCameraReady
//                 ? AspectRatio(
//               aspectRatio: _cameraController.value.aspectRatio,
//               child: CameraPreview(_cameraController),
//             )
//                 : VlcPlayer(
//               controller: _videoPlayerController,
//               aspectRatio: 16 / 9,
//               placeholder: Center(child: CircularProgressIndicator()),
//             ),
//
//
//             ElevatedButton(
//               onPressed: () {
//                 _videoPlayerController.play();
//               },
//               child: Text('Open Camera'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.deepPurpleAccent.shade200, // Change button color here
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _videoPlayerController.stop();
//                 Image.asset('images/new_lama.jpg');
//                 //showImage();
//               },
//               child: Text('Stop Camera'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.deepPurpleAccent.shade200, // Change button color here
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 _videoPlayerController.stop();
//               },
//               child: Text('Get Files'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.deepPurpleAccent.shade200, // Change button color here
//               ),
//             ),
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.deepPurpleAccent.shade200,
//               ),
//               child: InkWell(
//                 onTap: () {
//                   //connectToWifi('wifi_name', 'wifi_pass');
//                   // _connectToWifi();
//                   connectToWiFi();
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
//
//
//
// class Files extends StatefulWidget {
//   @override
//   _FilesState createState() => _FilesState();
// }
//
// class _FilesState extends State<Files> {
// // class Files extends StatelessWidget {
//   int _currentIndex = 0;
//
//   List<String> items = [
//     "All",
//     "Video",
//     "Photos",
//   ];
//
//   /// List of body icon
//   List<IconData> icons = [
//     Icons.home,
//     Icons.video_file,
//     Icons.photo,
//   ];
//   int current = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple[100],
//       body: Container(
//
//         width: double.infinity,
//         height: double.infinity,
//         margin: const EdgeInsets.all(45),
//         child: Column(
//           children: [
//             /// CUSTOM TABBAR
//             SizedBox(
//               width: double.infinity,
//               height: 60,
//               child: ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: items.length,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (ctx, index) {
//                     return Column(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               current = index;
//                             });
//                           },
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             margin: const EdgeInsets.all(5),
//                             width: 90,
//                             height: 45,
//                             decoration: BoxDecoration(
//                               color: current == index
//                                   ? Colors.white70
//                                   : Colors.white54,
//                               borderRadius: current == index
//                                   ? BorderRadius.circular(15)
//                                   : BorderRadius.circular(10),
//                               border: current == index
//                                   ? Border.all(
//                                   color: Colors.deepPurpleAccent, width: 2)
//                                   : null,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 items[index],
//                                 style: GoogleFonts.laila(
//                                     fontWeight: FontWeight.w500,
//                                     color: current == index
//                                         ? Colors.black
//                                         : Colors.grey),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Visibility(
//                             visible: current == index,
//                             child: Container(
//                               width: 5,
//                               height: 5,
//                               decoration: const BoxDecoration(
//                                   color: Colors.deepPurpleAccent,
//                                   shape: BoxShape.circle),
//                             ))
//                       ],
//                     );
//                   }),
//             ),
//
//             /// MAIN BODY
//             // Container(
//             //   margin: const EdgeInsets.only(top: 30),
//             //   width: double.infinity,
//             //   height: 350,
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       Icon(
//             //         icons[current],
//             //         size: 200,
//             //         color: Colors.deepPurple,
//             //       ),
//             //       const SizedBox(
//             //         height: 10,
//             //       ),
//             //       Text(
//             //         items[current],
//             //         style: GoogleFonts.laila(
//             //             fontWeight: FontWeight.w500,
//             //             fontSize: 30,
//             //             color: Colors.deepPurple),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 30),
//                   width: double.infinity,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         icons[current],
//                         size: 200,
//                         color: Colors.deepPurple,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         items[current],
//                         style: GoogleFonts.laila(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 30,
//                             color: Colors.deepPurple),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
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


// FINAL DASHCAM PART
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
  // final String ssid = 'CAMERA';
  final String ssid = 'CARDV'; //CARDV-8c8b Mahmudur @ SF Networking
  final  password = '12345678';

  //IP Address
  final String ipAddress = '192.168.1.254';

  //files
  final String url = 'http://192.168.1.254';
  bool isConnected = false;

  // wifi connection
  Future<bool> _checkPermissions() async {
    if (Platform.isIOS || await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }

  void _connect(BuildContext context) async {
    if (await _checkPermissions()) {
      if (isConnected) {
        FlutterIotWifi.disconnect().then((value) {
          setState(() {
            isConnected = false;
          });
          print("Disconnect initiated: $value");
        });
      } else {
        FlutterIotWifi.connect(ssid, password, prefix: true).then((value) {
          setState(() {
            isConnected = true;
          });
          print("Connect initiated: $value");
        });
      }
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

  Future<String> getFileData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('file not');
    }
  }

  Future<void> connectToWiFi() async {

    //bool isConnected = await WiFiForIoTPlugin.connect(ssid: ssid, password: password);
    bool isConnected = await WiFiForIoTPlugin.connect(ssid, password: password);

    if (isConnected) {
      // Wi-Fi connection successful
      print('Connected to $ssid');
    } else {
      // Wi-Fi connection failed
      print('Failed to connect to $ssid');
    }


  }

  Future<void> connectToNewWiFi() async {
    bool isConnected = await WiFiForIoTPlugin.connect(new_ssid, password: password);

    if (isConnected) {
      // Wi-Fi connection successful
      print('Connected to $new_ssid');
    } else {
      // Wi-Fi connection failed
      print('Failed to connect to $new_ssid');
    }

  }

  // function will be here
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


  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraReady = false;
  bool _isFlashOn = false;


  final String new_ssid = 'LLAMATEST';
  final String new_ssidpass ='12345678';

  Future<void> changeSSID() async {
    String url = 'http://192.168.1.254/ ?custom=1&cmd=3003&str=$new_ssid';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('SSID changed to. $new_ssid');
      } else {
        print('Error occured: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  Future<void> changeSSIDPASS() async {
    String url = 'http://192.168.1.254/ ?custom=1&cmd=3004&str=$new_ssidpass';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('SSID Pass changed to. $new_ssidpass');
      } else {
        print('Error occured: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  final _ssidnamecontroller = TextEditingController();
  final _ssidpasscontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isCameraReady
                  ? AspectRatio(
                aspectRatio: _cameraController.value.aspectRatio,
                child: CameraPreview(_cameraController),
              )
                  : VlcPlayer(
                controller: _videoPlayerController,
                aspectRatio: 16 / 9,
                placeholder: Center(child: CircularProgressIndicator()),
              ),
              SizedBox(height: 15),
              // ElevatedButton(
              //   onPressed: () {
              //     _videoPlayerController.play();
              //     playVlc();
              //     VlcPlayer(
              //       controller: _videoPlayerController,
              //       aspectRatio: 16 / 9,
              //       placeholder: Center(child: CircularProgressIndicator()),
              //     );
              //   },
              //   child: Text('Open Camera'),
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.deepPurpleAccent.shade200, // Change button color here
              //   ),
              // ),
              GlowingButton2(
                text: "Open Camera",
                onPressed: () {
                  _videoPlayerController.play();
                  playVlc();
                  VlcPlayer(
                    controller: _videoPlayerController,
                    aspectRatio: 16 / 9,
                    placeholder: Center(child: CircularProgressIndicator()),
                  );
                },
                color1: Color(0xFF517fa4),
                color2: Colors.deepPurpleAccent,
              ),
              SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () {
              //     _videoPlayerController.stop();
              //     Image.asset('images/new_lama.jpg');
              //     //showImage();
              //   },
              //   child: Text('Stop Camera'),
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.deepPurpleAccent.shade200, // Change button color here
              //   ),
              // ),
              GlowingButton2(
                text: "Stop Camera",
                onPressed: () {
                  _videoPlayerController.stop();
                  Image.asset('images/new_lama.jpg');
                },
                color1: Color(0xFF517fa4),
                color2: Colors.deepPurple,
              ),
              SizedBox(height: 100),
              InkWell(
                onTap: () {
                  _connect(context);
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
              // ElevatedButton(
              //   onPressed: () {
              //     changeSSID();
              //   },
              //   child: Text('Change SSID to LLAMATEST'),
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.deepPurpleAccent.shade200, // Change button color here
              //   ),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     changeSSIDPASS();
              //   },
              //   child: Text('Change PASS to 12345678'),
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.deepPurpleAccent.shade200, // Change button color here
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(1.0),
              //   child: TextFormField(
              //     controller: _ssidnamecontroller,
              //     decoration: const InputDecoration(hintText: 'SSID NAME'),
              //   ),
              // ),



              // Container(
              //   width: 100,
              //   height: 100,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.deepPurpleAccent.shade200,
              //   ),
              //   child: InkWell(
              //     onTap: () {
              //       //connectToWifi('wifi_name', 'wifi_pass');
              //      // _connectToWifi();
              //       connectToWiFi();
              //       // Do something when the button is pressed
              //     },
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.wifi,
              //           color: Colors.white,
              //         ),
              //         Text(
              //           'Connect WIFI',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 12,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // )
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