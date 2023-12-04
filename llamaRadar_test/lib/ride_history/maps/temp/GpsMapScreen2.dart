import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../../../sqflite/sqlite.dart';
import 'dart:ui' as ui;


class GpsMapScreen2 extends StatefulWidget {
  final String date;

  const GpsMapScreen2({required this.date});

  @override
  _GpsMapScreen2State createState() => _GpsMapScreen2State();
}

class _GpsMapScreen2State extends State<GpsMapScreen2> {
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(34.0522, -118.2437);
  List<Marker> _markers = [];
  List<Map<String, dynamic>> _gpsCoordinates = [];
  late ImagePicker _imagePicker;
  XFile? _imageFile;
  List<Uint8List?> _imageList = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  Future<void> _loadMarkers() async {
  // You can replace this with your logic to fetch places near Los Angeles
  // For demonstration, I'm using static coordinates
    List<LatLng> places = [
      LatLng(34.0522, -118.2437),
      LatLng(34.0619, -118.3086),
      LatLng(34.0776, -118.2654),
      LatLng(34.0521, -118.2637),
      LatLng(34.0610, -118.3007),
      LatLng(34.0983, -118.3267),
      LatLng(34.0975, -118.3614),
      LatLng(34.0604, -118.4198),
      LatLng(34.0522, -118.2437),
      LatLng(34.0992, -118.3666),
    ];
    for (int i = 0; i < places.length; i++) {
      _markers.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: places[i],
            icon: BitmapDescriptor.fromBytes(
              await getBytesFromAsset('assets/images/startup2.png', 180),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        // Display the GPS coordinates
                        Text('Coordinats: ${places[i]}'),
                      ],
                    ),
                  );
                },
              );
            }
        ),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_markers),
      ),
    );
  }
}



// Completer<GoogleMapController> _controller = Completer();
// static const LatLng _center = const LatLng(34.0522, -118.2437);
// List<Marker> _markers = [];
//
// @override
// void initState() {
//   super.initState();
//   _loadMarkers();
// }
//
// Future<void> _loadMarkers() async {
//   // You can replace this with your logic to fetch places near Los Angeles
//   // For demonstration, I'm using static coordinates
//   List<LatLng> places = [
//     LatLng(34.0522, -118.2437),
//     LatLng(34.0619, -118.3086),
//     LatLng(34.0776, -118.2654),
//     LatLng(34.0521, -118.2637),
//     LatLng(34.0610, -118.3007),
//     LatLng(34.0983, -118.3267),
//     LatLng(34.0975, -118.3614),
//     LatLng(34.0604, -118.4198),
//     LatLng(34.0522, -118.2437),
//     LatLng(34.0992, -118.3666),
//   ];
//
//   for (int i = 0; i < places.length; i++) {
//     _markers.add(
//       Marker(
//         markerId: MarkerId(i.toString()),
//         position: places[i],
//         infoWindow: InfoWindow(
//           title: 'Place $i',
//           snippet: 'Near Los Angeles',
//         ),
//       ),
//     );
//   }
//
//   if (mounted) {
//     setState(() {});
//   }
// }
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Google Maps Sample'),
//     ),
//     body: GoogleMap(
//       mapType: MapType.normal,
//       initialCameraPosition: CameraPosition(
//         target: _center,
//         zoom: 10.0,
//       ),
//       onMapCreated: (GoogleMapController controller) {
//         _controller.complete(controller);
//       },
//       markers: Set<Marker>.of(_markers),
//     ),
//   );
// }

// Future<void> _loadMarkers() async {
//   List<LatLng> places = [
//     LatLng(34.0522, -118.2437),
//     LatLng(34.0619, -118.3086),
//     LatLng(34.0776, -118.2654),
//     LatLng(34.0521, -118.2637),
//     LatLng(34.0610, -118.3007),
//     LatLng(34.0983, -118.3267),
//     LatLng(34.0975, -118.3614),
//     LatLng(34.0604, -118.4198),
//     LatLng(34.0522, -118.2437),
//     LatLng(34.0992, -118.3666),
//   ];
//
//   for (int i = 0; i < places.length; i++) {
//     _markers.add(
//       Marker(
//         markerId: MarkerId(i.toString()),
//         position: places[i],
//         icon: BitmapDescriptor.fromBytes(
//           await getBytesFromAsset('assets/images/startup2.png', 180),
//         ),
//         onTap: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Display the image with BoxFit.width if available
//                     // if (widget.image != null)
//                     //   Container(
//                     //     width: double.infinity, // Set width to maximum available width
//                     //     child: FittedBox(
//                     //       fit: BoxFit.fitWidth,
//                     //       child: Image.memory(
//                     //         widget.image!,
//                     //       ),
//                     //     ),
//                     //   ),
//                     SizedBox(height: 20),
//                     // Display the GPS coordinates
//                     Text('Coordinats: ${places[i]}'),
//                   ],
//                 ),
//               );
//             },
//           );
//         }
//       ),
//     );
//   }
//   if (mounted) {
//     setState(() {});
//   }
// }
