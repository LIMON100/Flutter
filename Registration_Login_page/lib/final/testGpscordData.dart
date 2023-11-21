import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testgpss/final/Screens/LogInScreen.dart';
import 'package:testgpss/final/showGpsData.dart';
import 'package:testgpss/temp/LocationPageSharedPreference.dart';

import '../final/model/UserLogInStatus.dart';
import '../final/sqflite/sqlite.dart';

class TestGpscordData extends StatefulWidget {
  const TestGpscordData({Key? key}) : super(key: key);

  @override
  State<TestGpscordData> createState() => _TestGpscordDataState();
}

class _TestGpscordDataState extends State<TestGpscordData> {
  List<Map<String, dynamic>> demoData = [
    {
      "latitude": 34.710648,
      "longitude": 800.406969,
      "image": "assets/images/logo.png",
      "date": "2023-11-20",
      "time": "16:26"
    },
    {
      "latitude": 83.710648,
      "longitude": 0.406969,
      "image": "assets/images/land_tree_dark.png",
      "date": "2023-11-20",
      "time": "16:26"
    },
    {
      "latitude": 23.710648,
      "longitude": 800.406969,
      "image": "assets/images/land_tree_dark.png",
      "date": "2023-11-20",
      "time": "16:26"
    },
    {
      "latitude": 03.710648,
      "longitude": 90.406969,
      "image": "assets/images/logo.png",
      "date": "2023-11-20",
      "time": "16:26"
    },
    {
      "latitude": 1.710648,
      "longitude": 2.406969,
      "image": "assets/images/land_tree_light.png",
      "date": "2023-11-20",
      "time": "16:26"
    },
  ];

  GpsDatabaseHelper helper = GpsDatabaseHelper();
  Future<void> insertDemoData() async {
    for(Map<String, dynamic> row in demoData) {
      await helper.insertCoordinates(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPS COORD DATA")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: insertDemoData,
                child: const Text("Save Data"),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowGpsData()));
                },
                child: const Text("CHECK GPS DATA"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
