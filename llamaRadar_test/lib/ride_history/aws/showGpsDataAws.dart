import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:lamaradar/ride_history/DateDetailsPage.dart';
import 'package:lamaradar/ride_history/aws/mapViewAws.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/History.dart';
import '../../sqflite/sqlite.dart';
import 'package:lamaradar/ride_history/mapView.dart';

class ShowGpsDataAws extends StatefulWidget {
  const ShowGpsDataAws({Key? key}) : super(key: key);

  @override
  State<ShowGpsDataAws> createState() => _ShowGpsDataAwsState();
}

class _ShowGpsDataAwsState extends State<ShowGpsDataAws> {
  List<Map<String, dynamic>> _uniqueDates = [];
  bool _isLoading = true;

  GlobalKey globalKey = GlobalKey();
  String name = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String date = "";
  String time = "";

  String fileKeyFinal = "";
  late final History newHistory;
  String uniqueUser = "";

  @override
  void initState() {
    super.initState();
    // _fetchGpsCoordinates();
    getCurrentUserID();
    initializeData();
  }

  Future<void> getCurrentUserID() async {
    final currentUser = await Amplify.Auth.getCurrentUser();
    Map<String, dynamic> signInDetails = currentUser.signInDetails.toJson();
    uniqueUser = signInDetails['username'];
    setState(() {});
  }

  Future<void> initializeData() async {
    // await Future.delayed(Duration(seconds: 2));
    await queryListItems();
  }


  // Query data
  late List<History?> historyList = [];
  late List<History?> historyList2 = []; // Initialize with an empty list
  Set<String> uniqueDates2 = Set();

  List<History?> getUniqueDates(List<History?> historyList) {
    List<Map<String, dynamic>> uniqueGpsCoordinates = [];
    for (var history in historyList) {
      if (history != null && history.date != null) {
        uniqueDates2.add(history.date.toString());
        historyList2.add(history);
      }
    }

    setState(() {
      historyList = historyList2;
    });

    return historyList2;
  }


  late List uniqueDates = [];
  Future<List<History?>> queryListItems() async {
    try {
      final request = ModelQueries.list(History.classType);
      final response = await Amplify.API.query(request: request).response;

      await Future.delayed(Duration(seconds: 2));

      final items = response.data?.items;

      historyList = items?.where((history) => history?.userUniqueId == uniqueUser)?.toList() ?? [];

      if (historyList.isNotEmpty) {
        newHistory = historyList[0]!; // Assuming you want the first item
      }

      uniqueDates = historyList.map((history) => history!.date).toSet().toList();
      uniqueDates.sort((a, b) => b.compareTo(a));

      setState(() {
        _isLoading = false;
      });

      print(uniqueDates);

      if (items == null) {
        print('errors: ${response.errors}');
        return <History?>[];
      }
      return historyList;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return <History?>[];
  }

  // Future<void> _fetchGpsCoordinates() async {
  //   final Database db = await GpsDatabaseHelper().initDatabase();
  //   final gpsCoordinates = await db.query('gps_coordinates_A', orderBy: 'date DESC');
  //
  //   // Use a set to store unique dates
  //   Set<String> uniqueDates = Set();
  //
  //   // Filter out duplicates based on date
  //   List<Map<String, dynamic>> uniqueGpsCoordinates = [];
  //   for (var gpsCoordinate in gpsCoordinates) {
  //     if (uniqueDates.add(gpsCoordinate['date'].toString())) {
  //       uniqueGpsCoordinates.add(gpsCoordinate);
  //     }
  //   }
  //
  //   setState(() {
  //     _gpsCoordinates = uniqueGpsCoordinates;
  //     _isLoading = false;
  //   });
  //
  //   if (_gpsCoordinates.isEmpty) {
  //     // Delay the "No data found" message for 3-4 seconds
  //     Future.delayed(const Duration(seconds: 3), () {
  //       if (_gpsCoordinates.isEmpty) {
  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: const Text('No data found'),
  //             content: const Text('There are no GPS coordinates recorded.'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Date'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press to navigate to a specific page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BleScreen(title: ''),
              ),
            );
          },
        ),
      ),
      body: _isLoading
          ? Center(
        child: SpinKitFadingCube(
          color: Colors.deepPurple,
          size: 150.0, // Adjust the size as needed
        ),
      )
          : historyList.isEmpty
          ? Center(
        child: SpinKitFadingCube(
          color: Colors.deepPurple,
          size: 150.0, // Adjust the size as needed
        ),
      )
          :
      ListView.builder(
        itemCount: uniqueDates.length,
        itemBuilder: (context, index) {
          // final gpsCoordinate = historyList[index];
          final uniqueDate = uniqueDates[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapViewAws(date: uniqueDate.toString(), historyList: historyList),
                ),
              );
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${uniqueDate.toString()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Add this line for bold text
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
