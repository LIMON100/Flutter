import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCoordinatesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Coordinates'),
      ),
      body: FutureBuilder<List<Map<String, double>>>(
        future: _loadSavedCoordinatesList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final coordinatesList = snapshot.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Number of Coordinates: ${coordinatesList.length}'),
                ),
                if (coordinatesList.isEmpty)
                  Text('No saved coordinates.')
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: coordinatesList.length,
                      itemBuilder: (context, index) {
                        final coordinates = coordinatesList[index];
                        return ListTile(
                          title: Text('Latitude: ${coordinates['latitude']}'),
                          subtitle: Text('Longitude: ${coordinates['longitude']}'),
                        );
                      },
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, double>>> _loadSavedCoordinatesList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedCoordinatesJsonList =
    prefs.getStringList('coordinatesList');

    if (savedCoordinatesJsonList != null) {
      return savedCoordinatesJsonList
          .map((jsonString) => Map<String, double>.from(json.decode(jsonString)))
          .toList();
    } else {
      return [];
    }
  }
}
