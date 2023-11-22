import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testgpss/final/temp/DateDetailsPage.dart';
import '../final/sqflite/sqlite.dart';

class ShowGpsData extends StatefulWidget {
  const ShowGpsData({Key? key}) : super(key: key);

  @override
  State<ShowGpsData> createState() => _ShowGpsDataState();
}
//
// class _ShowGpsDataState extends State<ShowGpsData> {
//   List<Map<String, dynamic>> _gpsCoordinates = [];
//
//   Future<void> _fetchGpsCoordinates() async {
//     try {
//       final Database db = await GpsDatabaseHelper().initDatabase();
//       final List<Map<String, dynamic>> gpsCoordinates = await db.query('gps_coordinates');
//
//       setState(() {
//         _gpsCoordinates = gpsCoordinates;
//       });
//     } catch (e) {
//       print('Error fetching GPS coordinates: $e');
//     }
//   }
//
//
//   Map<String, List<Map<String, dynamic>>> _groupedGpsCoordinates = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchGpsCoordinates();
//     _groupedGpsCoordinates = _groupDataByDate(_gpsCoordinates);
//   }
//
//   Map<String, List<Map<String, dynamic>>> _groupDataByDate(
//       List<Map<String, dynamic>> data) {
//     Map<String, List<Map<String, dynamic>>> groupedData = {};
//
//     for (var item in data) {
//       String date = item['date'];
//       groupedData[date] ??= [];
//       groupedData[date]!.add(item);
//     }
//
//     return groupedData;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('GPS Coordinates'),
//       ),
//       body: ListView.builder(
//         itemCount: _groupedGpsCoordinates.keys.length,
//         itemBuilder: (context, dateIndex) {
//           String date = _groupedGpsCoordinates.keys.elementAt(dateIndex);
//
//           return ListTile(
//             title: Text(date),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       DateDetailsPage(date: date, details: _groupedGpsCoordinates[date]!),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// class _ShowGpsDataState extends State<ShowGpsData> {
//   List<Map<String, dynamic>> _gpsCoordinates = [];
//
//   Future<void> _fetchGpsCoordinates() async {
//     final Database db = await GpsDatabaseHelper().initDatabase();
//     final List<Map<String, dynamic>> gpsCoordinates =
//     await db.query('gps_coordinates', orderBy: 'date DESC'); // Sort by date in descending order
//
//     // Create a set to store unique dates
//     Set<String> uniqueDates = Set();
//
//     // Filter out duplicates based on date
//     List<Map<String, dynamic>> uniqueGpsCoordinates = [];
//     for (var gpsCoordinate in gpsCoordinates) {
//       if (uniqueDates.add(gpsCoordinate['date'])) {
//         uniqueGpsCoordinates.add(gpsCoordinate);
//       }
//     }
//
//     setState(() {
//       _gpsCoordinates = uniqueGpsCoordinates;
//     });
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
//         title: const Text('GPS Coordinates'),
//       ),
//       body: ListView.builder(
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
//                     details: _gpsCoordinates,
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


class _ShowGpsDataState extends State<ShowGpsData> {
  List<Map<String, dynamic>> _gpsCoordinates = [];

  Future<void> _fetchGpsCoordinates() async {
    final Database db = await GpsDatabaseHelper().initDatabase();
    final List<Map<String, dynamic>> gpsCoordinates =
    await db.query('gps_coordinates', orderBy: 'date DESC');

    // Use a set to store unique dates
    Set<String> uniqueDates = Set();

    // Filter out duplicates based on date
    List<Map<String, dynamic>> uniqueGpsCoordinates = [];
    for (var gpsCoordinate in gpsCoordinates) {
      if (uniqueDates.add(gpsCoordinate['date'])) {
        uniqueGpsCoordinates.add(gpsCoordinate);
      }
    }

    setState(() {
      _gpsCoordinates = uniqueGpsCoordinates;
    });
  }

  Future<List<String>?> getFilesByDate(String date) async {
    final database = await GpsDatabaseHelper().initDatabase();
    final results = await database.query('gps_coordinates',
      where: 'date == ?',
      whereArgs: [date],
    );

    final files = results.map((row) => row['image']).toList();
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
        title: const Text('GPS Coordinates'),
      ),
      body: ListView.builder(
        itemCount: _gpsCoordinates.length,
        itemBuilder: (context, index) {
          final gpsCoordinate = _gpsCoordinates[index];
          return GestureDetector(
            // onTap:()=> getFilesByDate,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DateDetailsPage(
                    date: gpsCoordinate['date'],
                  ),
                ),
              );
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${gpsCoordinate['date']}',
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

