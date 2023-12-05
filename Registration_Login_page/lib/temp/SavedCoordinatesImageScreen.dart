import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCoordinatesImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Data'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadSavedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved data.'));
          } else {
            final data = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latitude: ${data['latitude']}'),
                Text('Longitude: ${data['longitude']}'),
                if (data['screenshot'] != null)
                  Image.file(File(data['screenshot'])),
                // Add more widgets to display other data as needed
              ],
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final double? latitude = prefs.getDouble('latitude');
    final double? longitude = prefs.getDouble('longitude');
    final String? screenshotPath = prefs.getString('screenshot');
    print("SCREN");
    print(screenshotPath);

    return {
      'latitude': latitude,
      'longitude': longitude,
      'screenshot': screenshotPath,
      // Add more data keys as needed
    };
  }
}



