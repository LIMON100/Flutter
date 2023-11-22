import 'package:flutter/material.dart';
import 'sqflite/sqlite.dart';
import 'package:sqflite/sqflite.dart';

class DateDetailsPage extends StatefulWidget  {
  final String date;
  DateDetailsPage({required this.date});

  @override
  _DateDetailsPageState createState() => _DateDetailsPageState();
}

class _DateDetailsPageState extends State<DateDetailsPage> {
  List<Map<String, dynamic>> _gpsCoordinates = [];

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for $widget.date'),
      ),
      body: ListView.builder(
        itemCount: _gpsCoordinates.length,
        itemBuilder: (context, index) {
          final gpsCoordinate = _gpsCoordinates[index];
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
                  // Display the image if it exists
                  if (gpsCoordinate['image'] != null)
                    Image.asset(
                      gpsCoordinate['image'], // use the asset name directly
                      height: 100.0,
                      width: 100.0,
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
