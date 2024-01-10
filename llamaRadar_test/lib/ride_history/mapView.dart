import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lamaradar/ride_history/maps/maker_with_image.dart';
import 'package:lamaradar/ride_history/maps/marker_info.dart';
import 'package:lamaradar/ride_history/showGpsData.dart';
import 'package:sqflite/sqflite.dart';
import '../models/History.dart';
import '../sqflite/sqlite.dart';
import 'maps/MapScreen.dart';

class MapView extends StatefulWidget {
  final String date;
  MapView({required this.date});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<Map<String, dynamic>> _gpsCoordinates = [];
  late ImagePicker _imagePicker;
  XFile? _imageFile;
  List<Uint8List?> _imageList = [];

  @override
  void initState() {
    super.initState();
    _fetchGpsCoordinates();
  }

  // Data in decending order
  Future<void> _fetchGpsCoordinates() async {
    final Database db = await GpsDatabaseHelper().initDatabase();
    final List<Map<String, dynamic>> gpsCoordinates = await db.query(
      'gps_coordinates_A',
      where: 'date = ?',
      whereArgs: [widget.date],
      orderBy: 'time DESC', // Added this line to sort by time in descending order
    );

    setState(() {
      // Sort the GPS coordinates by time in descending order
      _gpsCoordinates = gpsCoordinates.toList()..sort((a, b) => b['time'].compareTo(a['time']));
      _imageList = _gpsCoordinates
          .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
          .toList();
    });
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Map View'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press to navigate to a specific page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowGpsData(),
                ),
              );
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'List View Map',
                icon: Icon(Icons.list),
              ),
              Tab(
                text: 'Single View Map',
                icon: Icon(Icons.map),
              ),
            ],
            labelColor: Colors.indigo,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarkerWithImage(date: widget.date),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  primary: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                child: Text(
                  "OPEN MAP",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: _gpsCoordinates.length,
              itemBuilder: (context, index) {
                final gpsCoordinate = _gpsCoordinates[index];
                if (gpsCoordinate['latitude'] != null &&
                    gpsCoordinate['longitude'] != null) {
                  return GestureDetector(
                    onTap: () {},
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
                                onPressed: () {
                                  // Check if latitude and longitude are not null
                                  if (gpsCoordinate['latitude'] != null &&
                                      gpsCoordinate['longitude'] != null) {
                                    // Navigate to the map page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapScreen(
                                          latitude: gpsCoordinate['latitude'],
                                          longitude: gpsCoordinate['longitude'],
                                          image: _imageList[index],
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Show a message if latitude or longitude is null
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('No data found for this location.'),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                  primary: Colors.blueGrey,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white70),
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                                child: Text(
                                  "MAP",
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
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: 2,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         foregroundColor: Colors.black,
  //         backgroundColor: Colors.transparent,
  //         centerTitle: true,
  //         title: Text('Map View'),
  //         leading: IconButton(
  //           icon: Icon(Icons.arrow_back),
  //           onPressed: () {
  //             // Handle back button press to navigate to a specific page
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ShowGpsData(),
  //               ),
  //             );
  //           },
  //         ),
  //         bottom: TabBar(
  //           tabs: [
  //             Tab(
  //               text: 'List View Map',
  //               icon: Icon(Icons.list),
  //             ),
  //             Tab(
  //               text: 'Single View Map',
  //               icon: Icon(Icons.map),
  //             ),
  //           ],
  //           labelColor: Colors.indigo,
  //           unselectedLabelColor: Colors.grey,
  //         ),
  //       ),
  //       body: TabBarView(
  //         children: [
  //           Container(
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => MarkerWithImage(date: widget.date),
  //                   ),
  //                 );
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 elevation: 3,
  //                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
  //                 primary: Colors.transparent,
  //                 shape: RoundedRectangleBorder(
  //                   side: BorderSide(color: Colors.white70),
  //                   borderRadius: BorderRadius.all(Radius.circular(30)),
  //                 ),
  //               ),
  //               child: Text(
  //                 "OPEN MAP",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           ListView.builder(
  //             itemCount: _gpsCoordinates.length,
  //             itemBuilder: (context, index) {
  //               final gpsCoordinate = _gpsCoordinates[index];
  //               if (gpsCoordinate['latitude'] != null &&
  //                   gpsCoordinate['longitude'] != null) {
  //                 return GestureDetector(
  //                   onTap: () {},
  //                   child: ListTile(
  //                     title: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Latitude: ${gpsCoordinate['latitude']}, Longitude: ${gpsCoordinate['longitude']}',
  //                         ),
  //                         Text(
  //                           'Time: ${gpsCoordinate['time']}',
  //                         ),
  //                         SizedBox(height: 8.0),
  //                         Row(
  //                           children: [
  //                             if (_imageList[index] != null)
  //                               Image.memory(
  //                                 _imageList[index]!,
  //                                 height: 100.0,
  //                                 width: 100.0,
  //                               ),
  //                             SizedBox(width: 80),
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Check if latitude and longitude are not null
  //                                 if (gpsCoordinate['latitude'] != null &&
  //                                     gpsCoordinate['longitude'] != null) {
  //                                   // Navigate to the map page
  //                                   Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                       builder: (context) => MapScreen(
  //                                         latitude: gpsCoordinate['latitude'],
  //                                         longitude: gpsCoordinate['longitude'],
  //                                         image: _imageList[index],
  //                                       ),
  //                                     ),
  //                                   );
  //                                 } else {
  //                                   // Show a message if latitude or longitude is null
  //                                   ScaffoldMessenger.of(context).showSnackBar(
  //                                     SnackBar(
  //                                       content: Text('No data found for this location.'),
  //                                     ),
  //                                   );
  //                                 }
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 elevation: 3,
  //                                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
  //                                 primary: Colors.blueGrey,
  //                                 shape: RoundedRectangleBorder(
  //                                   side: BorderSide(color: Colors.white70),
  //                                   borderRadius: BorderRadius.all(Radius.circular(30)),
  //                                 ),
  //                               ),
  //                               child: Text(
  //                                 "MAP",
  //                                 style: TextStyle(
  //                                   fontSize: 20,
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               } else {
  //                 return Container();
  //               }
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}