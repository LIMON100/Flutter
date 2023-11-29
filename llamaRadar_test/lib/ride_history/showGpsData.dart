import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lamaradar/ride_history/DateDetailsPage.dart';
import 'package:sqflite/sqflite.dart';
import '../sqflite/sqlite.dart';


class ShowGpsData extends StatefulWidget {
  const ShowGpsData({Key? key}) : super(key: key);

  @override
  State<ShowGpsData> createState() => _ShowGpsDataState();
}

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
        centerTitle: true,
        title: const Text('Date'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
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

