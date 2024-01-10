import 'dart:convert';
import 'dart:typed_data';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lamaradar/ride_history/maps/maker_with_image.dart';
import 'package:sqflite/sqflite.dart';
import '../models/History.dart';
import '../sqflite/sqlite.dart';

class DateDetailsPageTestLocal extends StatefulWidget  {
  final String email;
  DateDetailsPageTestLocal({required this.email});

  @override
  _DateDetailsPageTestLocalState createState() => _DateDetailsPageTestLocalState();
}

class _DateDetailsPageTestLocalState extends State<DateDetailsPageTestLocal> {
  List<Map<String, dynamic>> _gpsCoordinates = [];
  late ImagePicker _imagePicker;
  XFile? _imageFile;
  List<Uint8List?> _imageList = [];
  String userUniqueName = "";
  String currentUniqueUser = "";

  @override
  void initState() {
    super.initState();
    getCurrentUserID();
    _fetchGpsCoordinates();
  }

  Future<void> getCurrentUserID() async {
    final currentUser = await Amplify.Auth.getCurrentUser();
    Map<String, dynamic> signInDetails = currentUser.signInDetails.toJson();
    currentUniqueUser = currentUser.userId;
    userUniqueName = signInDetails['username'];
    setState(() {});
  }

  // Fetch all data based on date
  Future<void> _fetchGpsCoordinates() async {
    final Database db = await GpsDatabaseHelper().initDatabase();
    final List<Map<String, dynamic>> gpsCoordinates = await db.query(
      'gps_coordinates_A',
      where: 'email = ?',
      whereArgs: [widget.email.toString()],
    );

    setState(() {
      _gpsCoordinates = gpsCoordinates;
      //Extra
      _imageList = _gpsCoordinates
          .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
          .toList();
    });
    print("GPSLENGHTH");
    print(_gpsCoordinates.length);
  }

  Uint8List? _getImageBytes(dynamic imageData) {
    if (imageData is Uint8List) {
      return imageData;
    }
    else if (imageData is String) {
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
        title: Text("TEST LOCAL"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await GpsDatabaseHelper().deleteAllCoordinates();
            },
            style: ElevatedButton.styleFrom(
              elevation: 3,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              primary: Colors.blueGrey, // Change to your preferred color
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
            child: Text(
              "Delete ALL",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              itemCount: _gpsCoordinates.length,
              itemBuilder: (context, index) {
                final gpsCoordinate = _gpsCoordinates[index];
                if (gpsCoordinate['latitude'] != null &&
                    gpsCoordinate['longitude'] != null) {
                  return GestureDetector(
                    onTap: () {

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
                          Text(
                            'Position: ${gpsCoordinate['position']}',
                          ),
                          Text(
                            'email: ${gpsCoordinate['email']}',
                          ),
                          SizedBox(height: 8.0),
                          // Display the image if it exists and is valid
                          Row(
                            children: [
                              if (_imageList[index] != null)
                                Image.memory(
                                  _imageList[index]!,
                                  height: 100.0,
                                  width: 100.0,
                                ),
                              SizedBox(width: 80),
                              ElevatedButton(
                                onPressed: () async {
                                  await GpsDatabaseHelper().deleteCoordinate(index);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                  primary: Colors.blueGrey, // Change to your preferred color
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white70),
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
                else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}