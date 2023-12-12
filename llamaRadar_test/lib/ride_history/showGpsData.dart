import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:lamaradar/ride_history/DateDetailsPage.dart';
import 'package:sqflite/sqflite.dart';
import '../sqflite/sqlite.dart';
import 'package:lamaradar/ride_history/mapView.dart';

class ShowGpsData extends StatefulWidget {
  const ShowGpsData({Key? key}) : super(key: key);

  @override
  State<ShowGpsData> createState() => _ShowGpsDataState();
}

class _ShowGpsDataState extends State<ShowGpsData> {
  List<Map<String, dynamic>> _gpsCoordinates = [];
  bool _isLoading = true;

  Future<void> _fetchGpsCoordinates() async {
    final Database db = await GpsDatabaseHelper().initDatabase();
    final gpsCoordinates = await db.query('gps_coordinates', orderBy: 'date DESC');

    // Use a set to store unique dates
    Set<String> uniqueDates = Set();

    // Filter out duplicates based on date
    List<Map<String, dynamic>> uniqueGpsCoordinates = [];
    for (var gpsCoordinate in gpsCoordinates) {
      if (uniqueDates.add(gpsCoordinate['date'].toString())) {
        uniqueGpsCoordinates.add(gpsCoordinate);
      }
    }

    setState(() {
      _gpsCoordinates = uniqueGpsCoordinates;
      _isLoading = false;
    });

    if (_gpsCoordinates.isEmpty) {
      // Delay the "No data found" message for 3-4 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (_gpsCoordinates.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('No data found'),
              content: const Text('There are no GPS coordinates recorded.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGpsCoordinates();
  }

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
          : _gpsCoordinates.isEmpty
          ? Center(
        child: SpinKitFadingCube(
          color: Colors.deepPurple,
          size: 150.0, // Adjust the size as needed
        ),
      )
          : ListView.builder(
        itemCount: _gpsCoordinates.length,
        itemBuilder: (context, index) {
          final gpsCoordinate = _gpsCoordinates[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapView(date: gpsCoordinate['date']),
                ),
              );
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${gpsCoordinate['date']}',
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

// workable
// class _ShowGpsDataState extends State<ShowGpsData> {
//   List<Map<String, dynamic>> _gpsCoordinates = [];
//   bool _isLoading = true;
//
//   Future<void> _fetchGpsCoordinates() async {
//     final Database db = await GpsDatabaseHelper().initDatabase();
//     final gpsCoordinates = await db.query('gps_coordinates', orderBy: 'date DESC');
//
//     // Use a set to store unique dates
//     Set<String> uniqueDates = Set();
//
//     // Filter out duplicates based on date
//     List<Map<String, dynamic>> uniqueGpsCoordinates = [];
//     for (var gpsCoordinate in gpsCoordinates) {
//       if (uniqueDates.add(gpsCoordinate['date'].toString())) {
//         uniqueGpsCoordinates.add(gpsCoordinate);
//       }
//     }
//
//     setState(() {
//       _gpsCoordinates = uniqueGpsCoordinates;
//       _isLoading = false;
//     });
//
//     if (_gpsCoordinates.isEmpty) {
//       // Delay the "No data found" message for 3-4 seconds
//       Future.delayed(const Duration(seconds: 5), () {
//         if (_gpsCoordinates.isEmpty) {
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: const Text('No data found'),
//               content: const Text('There are no GPS coordinates recorded.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('OK'),
//                 ),
//               ],
//             ),
//           );
//         }
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchGpsCoordinates();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Date'),
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       body: _isLoading
//           ? Center(
//             child: SpinKitFadingCube
//               (
//               color: Colors.deepPurple,
//               size: 150.0,
//             ),
//           )
//           : _gpsCoordinates.isEmpty
//           ? Center(
//         child: Text(
//           'No data found',
//           style: const TextStyle(fontSize: 20),
//         ),
//       )
//           : ListView.builder(
//         itemCount: _gpsCoordinates.length,
//         itemBuilder: (context, index) {
//           final gpsCoordinate = _gpsCoordinates[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DateDetailsPage(
//                     date: gpsCoordinate['date'],
//                   ),
//                 ),
//               );
//             },
//             child: ListTile(
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${gpsCoordinate['date']}',
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }