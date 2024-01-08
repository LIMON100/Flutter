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

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(24.7471, 90.4203);
  List<Marker> _markers = [];
  List<Map<String, dynamic>> _gpsCoordinates = [];
  late ImagePicker _imagePicker;
  XFile? _imageFile;
  List<Uint8List?> _imageList = [];

  static const CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(33.6941, 72.9734),
    zoom: 15,
  );


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
      //Extra
      _imageList = _gpsCoordinates
          .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
          .toList();
      _loadMarkers();
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> _loadMarkers() async {
    Completer<void> completer = Completer<void>();
    for (int i = 0; i < _gpsCoordinates.length; i++) {
      double? latitude = _gpsCoordinates[i]['latitude'] as double?;
      double? longitude = _gpsCoordinates[i]['longitude'] as double?;
      if (latitude != null && longitude != null) {
        _markers.add(
          Marker(
              markerId: MarkerId(i.toString()),
              position: LatLng(latitude, longitude),
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
                          // Display the image with BoxFit.width if available

                          if (_gpsCoordinates[i]['image'] != null)
                            Container(
                              width: double.infinity, // Set width to maximum available width
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Image.memory(
                                  _gpsCoordinates[i]['image'],
                                ),
                              ),
                            ),
                          SizedBox(height: 20),
                          // Display the GPS coordinates
                          Text('Coordinates: $latitude, $longitude'),
                        ],
                      ),
                    );
                  },
                );
              }
          ),
        );
      }
    }
    _fitAllMarkers();

    // Complete the completer
    completer.complete();

    // Trigger a rebuild of the widget
    setState(() {});

    return completer.future;
  }

  void _fitAllMarkers() async {
    if (_markers.isNotEmpty) {
      // Create a LatLngBounds that includes all markers
      LatLngBounds bounds = _getBounds(_markers);

      // Animate the camera to fit all markers
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    }
  }

  LatLngBounds _getBounds(List<Marker> markers) {
    double minLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLat = markers.first.position.latitude;
    double maxLng = markers.first.position.longitude;

    for (Marker marker in markers) {
      minLat = min(minLat, marker.position.latitude);
      minLng = min(minLng, marker.position.longitude);
      maxLat = max(maxLat, marker.position.latitude);
      maxLng = max(maxLng, marker.position.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        // myLocationButtonEnabled: true,
        // myLocationEnabled: true,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

