import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../../sqflite/sqlite.dart';


class MarkerWithImage extends StatefulWidget {
  final String date;
  MarkerWithImage({required this.date});

  @override
  _MarkerWithImageState createState() => _MarkerWithImageState();
}


class _MarkerWithImageState extends State<MarkerWithImage> {

  late GoogleMapController _controller;
  final Set<Marker> _markers = {};

  List<Map<String, dynamic>> _gpsCoordinates = [];
  List<Uint8List?> _imageList = [];

  @override
  void initState() {
    super.initState();
    _fetchGpsCoordinates();
  }

  Future<void> _fetchGpsCoordinates() async {
    final Database db = await GpsDatabaseHelper().initDatabase();
    final List<Map<String, dynamic>> gpsCoordinates = await db.query(
      'gps_coordinates',
      where: 'date = ?',
      whereArgs: [widget.date],
    );

    setState(() {
      _gpsCoordinates = gpsCoordinates;
      _imageList = _gpsCoordinates
          .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
          .toList();
      _addMarkers();
    });
  }

  Uint8List? _getImageBytes(dynamic imageData) {
    if (imageData is Uint8List) {
      return imageData;
    } else if (imageData is String) {
      // Convert the base64-encoded string to Uint8List
      return Uint8List.fromList(base64Decode(imageData));
    }
    return null;
  }

  Future<void> _addMarkers() async {
    for (int i = 0; i < _gpsCoordinates.length; i++) {
      final gpsCoordinate = _gpsCoordinates[i];
      final Uint8List? image = _imageList[i];

      if (gpsCoordinate['latitude'] != null && gpsCoordinate['longitude'] != null) {
        final Marker marker = Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(gpsCoordinate['latitude'], gpsCoordinate['longitude']),
          // icon: image != null
          //     ? BitmapDescriptor.fromBytes(image)
          //     : BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: 'Marker $i',
            snippet: 'Time: ${gpsCoordinate['time']}',
          ),
        );

        _markers.add(marker);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS Coordinates Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0.0, 0.0), // Initial camera position (center of the map)
          zoom: 2.0, // Initial zoom level
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: _markers,
      ),
    );
  }

  // List<Map<String, dynamic>> _gpsCoordinates = [];
  // late ImagePicker _imagePicker;
  // XFile? _imageFile;
  // List<Uint8List?> _imageList = [];
  //
  // GoogleMapController? _controller;
  // final Set<Marker> _markers = {};
  //
  // @override
  // void initState() {
  //   super.initState();
  //   loadData();
  //   // _fetchGpsCoordinates();
  // }
  //
  // Future<void> _fetchGpsCoordinates() async {
  //   final Database db = await GpsDatabaseHelper().initDatabase();
  //   final List<Map<String, dynamic>> gpsCoordinates = await db.query(
  //     'gps_coordinates',
  //     where: 'date = ?',
  //     whereArgs: [widget.date],
  //   );
  //
  //   setState(() {
  //     _gpsCoordinates = gpsCoordinates;
  //     //Extra
  //     _imageList = _gpsCoordinates
  //         .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
  //         .toList();
  //   });
  // }
  //
  // Uint8List? _getImageBytes(dynamic imageData) {
  //   if (imageData is Uint8List) {
  //     return imageData;
  //   } else if (imageData is String) {
  //     // Convert the base64-encoded string to Uint8List
  //     return Uint8List.fromList(base64Decode(imageData));
  //   }
  //   return null;
  // }
  //
  // List<LatLng> _latLang = [
  //   LatLng(34.0522, -118.2437),
  //   LatLng(34.0776, -118.2654),
  //   LatLng(34.0522, -118.3086),
  //   LatLng(34.0619, -118.3090),
  //   LatLng(34.0521, -118.2637),
  //   LatLng(34.0610, -118.3007),
  //   LatLng(34.0983, -118.3267),
  //   LatLng(34.0975, -118.3614),
  //   LatLng(34.0522, -118.2437),
  //   LatLng(34.0604, -118.4198),
  // ];
  //
  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(33.6941, 72.9734),
  //   zoom: 15,
  // );
  //
  //
  // loadData() async {
  //   for (int i = 0; i < _latLang.length; i++) {
  //     Uint8List? image = await _loadAssetImage('assets/images/startup2.png');
  //
  //     final ui.Codec markerImageCodec = await instantiateImageCodec(
  //       image!.buffer.asUint8List(),
  //       targetHeight: 150,
  //       targetWidth: 150,
  //     );
  //     final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
  //     final ByteData? byteData = await frameInfo.image.toByteData(
  //       format: ImageByteFormat.png,
  //     );
  //
  //     final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId(i.toString()),
  //         position: _latLang[i],
  //         icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
  //         anchor: Offset(.1, .1),
  //         infoWindow: InfoWindow(
  //           title: 'This is title marker: ' + i.toString(),
  //           snippet: 'Latitude: ${_latLang[i].latitude}, Longitude: ${_latLang[i].longitude}',
  //         ),
  //       ),
  //     );
  //     setState(() {});
  //   }
  //
  //   // Move the camera to fit all markers
  //   _fitAllMarkers();
  // }
  //
  // void _fitAllMarkers() {
  //   if (_markers.isNotEmpty && _controller != null) {
  //     LatLngBounds bounds = _getBounds(_markers);
  //     _controller!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
  //   }
  // }
  //
  // LatLngBounds _getBounds(Set<Marker> markers) {
  //   double minLat = markers.first.position.latitude;
  //   double minLng = markers.first.position.longitude;
  //   double maxLat = markers.first.position.latitude;
  //   double maxLng = markers.first.position.longitude;
  //
  //   for (Marker marker in markers) {
  //     minLat = min(minLat, marker.position.latitude);
  //     minLng = min(minLng, marker.position.longitude);
  //     maxLat = max(maxLat, marker.position.latitude);
  //     maxLng = max(maxLng, marker.position.longitude);
  //   }
  //
  //   return LatLngBounds(
  //     southwest: LatLng(minLat, minLng),
  //     northeast: LatLng(maxLat, maxLng),
  //   );
  // }
  //
  // Future<Uint8List?> _loadAssetImage(String assetPath) async {
  //   ByteData data = await rootBundle.load(assetPath);
  //   return data.buffer.asUint8List();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: GoogleMap(
  //         initialCameraPosition: _kGooglePlex,
  //         mapType: MapType.normal,
  //         myLocationButtonEnabled: true,
  //         myLocationEnabled: true,
  //         markers: Set<Marker>.of(_markers),
  //         onMapCreated: (GoogleMapController controller) {
  //           _controller = controller;
  //         },
  //         onTap: (LatLng latLng) {
  //           // Handle map tap if needed
  //         },
  //       ),
  //     ),
  //   );
  // }
}

// class _MarkerWithImageState extends State<MarkerWithImage> {
//
//   List<Map<String, dynamic>> _gpsCoordinates = [];
//   late ImagePicker _imagePicker;
//   XFile? _imageFile;
//   List<Uint8List?> _imageList = [];
//
//   GoogleMapController? _controller;
//   final Set<Marker> _markers = {};
//
//   List<LatLng> _latLang = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//     _fetchGpsCoordinates();
//   }
//
//   Future<void> _fetchGpsCoordinates() async {
//     final Database db = await GpsDatabaseHelper().initDatabase();
//     final List<Map<String, dynamic>> gpsCoordinates = await db.query(
//       'gps_coordinates',
//       where: 'date = ?',
//       whereArgs: [widget.date],
//     );
//
//     setState(() {
//       _gpsCoordinates = gpsCoordinates;
//       // Extra
//       _imageList = _gpsCoordinates
//           .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
//           .toList();
//
//       // Update _latLang based on gpsCoordinates with null checks
//       _latLang = _gpsCoordinates
//           .map((coordinate) {
//         final double? latitude = coordinate['latitude'] as double?;
//         final double? longitude = coordinate['longitude'] as double?;
//
//         if (latitude != null && longitude != null) {
//           return LatLng(latitude, longitude);
//         } else {
//           // Handle the case where latitude or longitude is null
//           // You can return a default LatLng or skip this coordinate
//           return LatLng(0.0, 0.0);
//         }
//       })
//           .toList();
//     });
//   }
//
//
//   Uint8List? _getImageBytes(dynamic imageData) {
//     if (imageData is Uint8List) {
//       return imageData;
//     }
//     else if (imageData is String) {
//       return Uint8List.fromList(base64Decode(imageData));
//     }
//     return null;
//   }
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(34, 90),
//     zoom: 15,
//   );
//
//
//   loadData() async {
//     for (int i = 0; i < _latLang.length; i++) {
//       Uint8List? image = await _loadAssetImage('assets/images/startup2.png');
//
//       final ui.Codec markerImageCodec = await instantiateImageCodec(
//         image!.buffer.asUint8List(),
//         targetHeight: 150,
//         targetWidth: 150,
//       );
//       final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
//       final ByteData? byteData = await frameInfo.image.toByteData(
//         format: ImageByteFormat.png,
//       );
//
//       final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
//       _markers.add(
//         Marker(
//           markerId: MarkerId(i.toString()),
//           position: _latLang[i],
//           icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
//           anchor: Offset(.1, .1),
//           infoWindow: InfoWindow(
//             title: 'This is title marker: ' + i.toString(),
//             snippet: 'Latitude: ${_latLang[i].latitude}, Longitude: ${_latLang[i].longitude}',
//           ),
//         ),
//       );
//       setState(() {});
//     }
//     // Move the camera to fit all markers
//     _fitAllMarkers();
//   }
//
//
//   void _fitAllMarkers() {
//     if (_markers.isNotEmpty && _controller != null) {
//       LatLngBounds bounds = _getBounds(_markers);
//       _controller!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
//     }
//   }
//
//   LatLngBounds _getBounds(Set<Marker> markers) {
//     double minLat = markers.first.position.latitude;
//     double minLng = markers.first.position.longitude;
//     double maxLat = markers.first.position.latitude;
//     double maxLng = markers.first.position.longitude;
//
//     for (Marker marker in markers) {
//       minLat = min(minLat, marker.position.latitude);
//       minLng = min(minLng, marker.position.longitude);
//       maxLat = max(maxLat, marker.position.latitude);
//       maxLng = max(maxLng, marker.position.longitude);
//     }
//
//     return LatLngBounds(
//       southwest: LatLng(minLat, minLng),
//       northeast: LatLng(maxLat, maxLng),
//     );
//   }
//
//   Future<Uint8List?> _loadAssetImage(String assetPath) async {
//     ByteData data = await rootBundle.load(assetPath);
//     return data.buffer.asUint8List();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: GoogleMap(
//           initialCameraPosition: _kGooglePlex,
//           mapType: MapType.normal,
//           myLocationButtonEnabled: true,
//           myLocationEnabled: true,
//           markers: Set<Marker>.of(_markers),
//           onMapCreated: (GoogleMapController controller) {
//             _controller = controller;
//           },
//           onTap: (LatLng latLng) {
//             // Handle map tap if needed
//           },
//         ),
//       ),
//     );
//   }
// }
