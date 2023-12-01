// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
//
//
// class TestGps extends StatefulWidget {
//   @override
//   _TestGpsState createState() => _TestGpsState();
// }
//
// class _TestGpsState extends State<TestGps> {
//   Location location = Location();
//   LocationData? _currentLocation;
//   StreamSubscription<LocationData>? _locationSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeLocation();
//   }
//
//   void _initializeLocation() {
//     // Check if location service is enabled
//     location.serviceEnabled().then((enabled) {
//       if (!enabled) {
//         location.requestService();
//       }
//     });
//
//     // Request location permissions
//     location.requestPermission().then((granted) {
//       if (granted == PermissionStatus.granted) {
//         // Start listening for location updates
//         _locationSubscription = location.onLocationChanged.listen((LocationData locationData) {
//           setState(() {
//             _currentLocation = locationData;
//           });
//         });
//       } else {
//         print('Location permission denied');
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _locationSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _currentLocation != null
//               ? Text('Latitude: ${_currentLocation!.latitude}, Longitude: ${_currentLocation!.longitude}')
//               : Text('Location data not available.'),
//         ],
//       ),
//     );
//   }
// }