<<<<<<< HEAD
import 'dart:convert';
import 'dart:typed_data';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lamaradar/ride_history/aws/showGpsDataAws.dart';
import 'package:lamaradar/ride_history/maps/maker_with_image.dart';
import 'package:lamaradar/ride_history/maps/marker_info.dart';
import 'package:lamaradar/ride_history/showGpsData.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/History.dart';
import '../../sqflite/sqlite.dart';
import '../maps/MapScreen.dart';
import 'maker_with_image_aws.dart';
import 'mapScreenAws.dart';


class MapViewAws extends StatefulWidget {
  final String date;
  final List<History?> historyList;
  MapViewAws({required this.date, required this.historyList});

  @override
  _MapViewAwsState createState() => _MapViewAwsState();
}

class _MapViewAwsState extends State<MapViewAws> {
  // List<Map<String, dynamic>> _gpsCoordinates = [];
  // late ImagePicker _imagePicker;
  // XFile? _imageFile;
  // List<Uint8List?> _imageList = [];

  @override
  void initState() {
    super.initState();
    // _fetchGpsCoordinates();
    // queryListItems();
    checkHistory();
  }

  late List<History?> historyList = [];
  late final History newHistory;

  Future<List<History?>> queryListItems() async {
    try {
      print("CHEDATE;");

      final request = ModelQueries.list(History.classType);
      final response = await Amplify.API.query(request: request).response;

      await Future.delayed(Duration(seconds: 2));

      final items = response.data?.items;

      historyList = items?.where((history) => history?.date == "2024-01-04")?.toList() ?? [];

      if (historyList.isNotEmpty) {
        newHistory = historyList[0]!; // Assuming you want the first item
      }

      if (items == null) {
        print('errors: ${response.errors}');
        return <History?>[];
      }
      print("HISTPPP");
      print(historyList.length);
      print(historyList);

      return historyList;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return <History?>[];
  }

  Future<void> checkHistory() async {

    // List<History?> filteredList = await widget.historyList.where((history) => history?.date == widget.date).toList();

    historyList = widget.historyList?.where((history) => history?.date == widget.date)?.toList() ?? [];

    // List<History?> filteredAndSortedHistory = widget.historyList
    //     .where((history) => history?.date == widget.date)
    //     .toList()
    //   ..sort((a, b) => a!.time!.compareTo(b!.time!));

    print("HISTORYLENGITH");
    print(widget.date);
    print(widget.historyList.length);
    print(historyList.length);
    print(historyList);
  }

  // Data in decending order
  // Future<void> _fetchGpsCoordinates() async {
  //   print(widget.historyList.length);
  //   final Database db = await GpsDatabaseHelper().initDatabase();
  //   final List<Map<String, dynamic>> gpsCoordinates = await db.query(
  //     'gps_coordinates_A',
  //     where: 'date = ?',
  //     whereArgs: [widget.date],
  //     orderBy: 'time DESC', // Added this line to sort by time in descending order
  //   );
  //
  //   setState(() {
  //     _gpsCoordinates = gpsCoordinates.toList()..sort((a, b) => b['time'].compareTo(a['time']));
  //     _imageList = _gpsCoordinates
  //         .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
  //         .toList();
  //   });
  // }

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
                  builder: (context) => ShowGpsDataAws(),
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
                      builder: (context) => MarkerWithImageAws(date: widget.date, historyList: widget.historyList,),
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
              itemCount: widget.historyList.length,
              itemBuilder: (context, index) {
                final history = widget.historyList[index];
                if (history!.latitude != null && history!.longitude  != null && history!.date.toString() == widget.date.toString()) {
                  return GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latitude: ${history!.latitude}, Longitude: ${history!.longitude}',
                          ),
                          Text(
                            'Time: ${history!.time}',
                          ),
                          Text(
                            'Position: ${history!.position}',
                          ),
                          Text(
                            'Date: ${history!.date}',
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              if (history.imageUrl == null)
                                const Center(child: CircularProgressIndicator()),
                              if (history.imageUrl != null)
                                Expanded(
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, dynamic error) =>
                                    const Icon(Icons.error_outline_outlined),
                                    imageUrl: history!.imageUrl!,
                                    cacheKey: history!.imagekey,
                                    width: double.maxFinite,
                                    height: 120.0,
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              SizedBox(width: 40),
                              ElevatedButton(
                                onPressed: () {
                                  // Check if latitude and longitude are not null
                                  if (history!.latitude != null &&
                                      history!.longitude != null) {
                                    // Navigate to the map page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapScreenAws(
                                          latitude: history!.latitude!.toDouble(),
                                          longitude: history!.longitude!.toDouble(),
                                          imageUrl: history!.imageUrl.toString(),
                                          imageKey: history!.imagekey.toString(),
                                          position: history!.position.toString(),
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
=======
import 'dart:convert';
import 'dart:typed_data';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lamaradar/ride_history/aws/showGpsDataAws.dart';
import 'package:lamaradar/ride_history/maps/maker_with_image.dart';
import 'package:lamaradar/ride_history/maps/marker_info.dart';
import 'package:lamaradar/ride_history/showGpsData.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/History.dart';
import '../../sqflite/sqlite.dart';
import '../maps/MapScreen.dart';
import 'maker_with_image_aws.dart';
import 'mapScreenAws.dart';


class MapViewAws extends StatefulWidget {
  final String date;
  final List<History?> historyList;
  MapViewAws({required this.date, required this.historyList});

  @override
  _MapViewAwsState createState() => _MapViewAwsState();
}

class _MapViewAwsState extends State<MapViewAws> {
  // List<Map<String, dynamic>> _gpsCoordinates = [];
  // late ImagePicker _imagePicker;
  // XFile? _imageFile;
  // List<Uint8List?> _imageList = [];

  @override
  void initState() {
    super.initState();
    // _fetchGpsCoordinates();
    // queryListItems();
    checkHistory();
  }

  late List<History?> historyList = [];
  late final History newHistory;

  Future<List<History?>> queryListItems() async {
    try {
      print("CHEDATE;");

      final request = ModelQueries.list(History.classType);
      final response = await Amplify.API.query(request: request).response;

      await Future.delayed(Duration(seconds: 2));

      final items = response.data?.items;

      historyList = items?.where((history) => history?.date == "2024-01-04")?.toList() ?? [];

      if (historyList.isNotEmpty) {
        newHistory = historyList[0]!; // Assuming you want the first item
      }

      if (items == null) {
        print('errors: ${response.errors}');
        return <History?>[];
      }
      print("HISTPPP");
      print(historyList.length);
      print(historyList);

      return historyList;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return <History?>[];
  }

  Future<void> checkHistory() async {

    // List<History?> filteredList = await widget.historyList.where((history) => history?.date == widget.date).toList();

    historyList = widget.historyList?.where((history) => history?.date == widget.date)?.toList() ?? [];

    // List<History?> filteredAndSortedHistory = widget.historyList
    //     .where((history) => history?.date == widget.date)
    //     .toList()
    //   ..sort((a, b) => a!.time!.compareTo(b!.time!));

    print("HISTORYLENGITH");
    print(widget.date);
    print(widget.historyList.length);
    print(historyList.length);
    print(historyList);
  }

  // Data in decending order
  // Future<void> _fetchGpsCoordinates() async {
  //   print(widget.historyList.length);
  //   final Database db = await GpsDatabaseHelper().initDatabase();
  //   final List<Map<String, dynamic>> gpsCoordinates = await db.query(
  //     'gps_coordinates',
  //     where: 'date = ?',
  //     whereArgs: [widget.date],
  //     orderBy: 'time DESC', // Added this line to sort by time in descending order
  //   );
  //
  //   setState(() {
  //     _gpsCoordinates = gpsCoordinates.toList()..sort((a, b) => b['time'].compareTo(a['time']));
  //     _imageList = _gpsCoordinates
  //         .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
  //         .toList();
  //   });
  // }

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
                  builder: (context) => ShowGpsDataAws(),
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
                      builder: (context) => MarkerWithImageAws(date: widget.date, historyList: widget.historyList,),
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
              itemCount: widget.historyList.length,
              itemBuilder: (context, index) {
                final history = widget.historyList[index];
                if (history!.latitude != null && history!.longitude  != null && history!.date.toString() == widget.date.toString()) {
                  return GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latitude: ${history!.latitude}, Longitude: ${history!.longitude}',
                          ),
                          Text(
                            'Time: ${history!.time}',
                          ),
                          Text(
                            'Position: ${history!.position}',
                          ),
                          Text(
                            'Date: ${history!.date}',
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              if (history.imageUrl == null)
                                const Center(child: CircularProgressIndicator()),
                              if (history.imageUrl != null)
                                Expanded(
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, dynamic error) =>
                                    const Icon(Icons.error_outline_outlined),
                                    imageUrl: history!.imageUrl!,
                                    cacheKey: history!.imagekey,
                                    width: double.maxFinite,
                                    height: 120.0,
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              SizedBox(width: 40),
                              ElevatedButton(
                                onPressed: () {
                                  // Check if latitude and longitude are not null
                                  if (history!.latitude != null &&
                                      history!.longitude != null) {
                                    // Navigate to the map page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapScreenAws(
                                          latitude: history!.latitude!.toDouble(),
                                          longitude: history!.longitude!.toDouble(),
                                          imageUrl: history!.imageUrl.toString(),
                                          imageKey: history!.imagekey.toString(),
                                          position: history!.position.toString(),
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
>>>>>>> 8088986bef8fdca0eba5fdf4204b910b018ef49a
}