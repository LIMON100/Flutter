import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import '../sqflite/sqlite.dart';

class DateDetailsPage extends StatefulWidget  {
  final String date;
  DateDetailsPage({required this.date});

  @override
  _DateDetailsPageState createState() => _DateDetailsPageState();
}

class _DateDetailsPageState extends State<DateDetailsPage> {
  List<Map<String, dynamic>> _gpsCoordinates = [];
  late ImagePicker _imagePicker;
  XFile? _imageFile;
  List<Uint8List?> _imageList = [];

  @override
  void initState() {
    super.initState();
    _fetchGpsCoordinates();
    // _fetchImages();
  }

  // Fetch all data based on date
  Future<void> _fetchGpsCoordinates() async {
    final Database db = await GpsDatabaseHelper().initDatabase();
    final List<Map<String, dynamic>> gpsCoordinates = await db.query(
      'gps_coordinates',
      where: 'date = ?',
      whereArgs: [widget.date],
    );

    setState(() {
      _gpsCoordinates = gpsCoordinates;
      print("GPS");
      print(_gpsCoordinates);
      //Extra
      _imageList = _gpsCoordinates
          .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
          .toList();
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

  bool isValidImage(Uint8List? imageData) {
    return imageData != null && imageData.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(widget.date),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _gpsCoordinates.length,
        itemBuilder: (context, index) {
          final gpsCoordinate = _gpsCoordinates[index];
          if (gpsCoordinate['latitude'] != null &&
              gpsCoordinate['longitude'] != null) {
            return GestureDetector(
              onTap: () {
                // Navigate to details page for the selected gps coordinate
              },
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latitude: ${gpsCoordinate['latitude']}, Longitude: ${gpsCoordinate['longitude']}',
                    ),
                    Text(
                      'Time: ${gpsCoordinate['time']}',
                    ),
                    SizedBox(height: 8.0),
                    // Display the image if it exists and is valid
                    if (_imageList[index] != null)
                      Image.memory(
                        _imageList[index]!,
                        height: 100.0,
                        width: 100.0,
                      ),
                  ],
                ),
              ),
            );
          } else {
            // If latitude or longitude is null, return an empty container
            return Container();
          }
        },
      ),
    );
  }
}