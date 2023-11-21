import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testgpss/final/Screens/LogInScreen.dart';
import 'package:testgpss/temp/LocationPageSharedPreference.dart';

import '../final/model/UserLogInStatus.dart';
import '../final/sqflite/sqlite.dart';

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
    await db.query('gps_coordinates');

    setState(() {
      _gpsCoordinates = gpsCoordinates;
    });
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

          return ListTile(
            title: Text(
              '${gpsCoordinate['latitude']}, ${gpsCoordinate['longitude']}',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${gpsCoordinate['date']} Time: ${gpsCoordinate['time']}',
                ),
                SizedBox(height: 8.0),
                // Display the image if it exists
                if (gpsCoordinate['image'] != null)
                  Image.asset(
                    gpsCoordinate['image'], // use the asset name directly
                    height: 100.0,
                    width: 100.0,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
