import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../../../sqflite/sqlite.dart';
import 'dart:ui' as ui;


class GpsMapScreen extends StatefulWidget {
  final String date;

  const GpsMapScreen({required this.date});

  @override
  _GpsMapScreenState createState() => _GpsMapScreenState();
}

class _GpsMapScreenState extends State<GpsMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  // LatLng _center = LatLng(24.7513077, 90.3962165);
  static const LatLng _center = const LatLng(24.7471, 90.4203);
  List<Marker> _markers = [];
  List<Map<String, dynamic>> _gpsCoordinates = [];
  late ImagePicker _imagePicker;
  XFile? _imageFile;
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
          zoom: 5.0,
        ),

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_markers),
      ),
    );
  }
}
