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

  String? _currentAddress;
  Position? _currentPosition;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // _loadSavedCoordinates();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _getCurrentPosition();
    });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }


  List<Map<String, dynamic>> getDemoData() {
    return [
      {
        "latitude": _currentPosition?.latitude,
        "longitude": _currentPosition?.longitude,
        "image": "assets/images/logo.png",
        "date": "2023-11-11",
        "time": "16:26",
      },
      {
        "latitude": _currentPosition?.latitude,
        "longitude": _currentPosition?.longitude,
        "image": "assets/images/logo.png",
        "date": "2023-11-11",
        "time": "16:26",
      },
      {
        "latitude": 83.710648,
        "longitude": 0.406969,
        "image": "assets/images/land_tree_dark.png",
        "date": "2023-11-11",
        "time": "16:26"
      },
      {
        "latitude": 23.710648,
        "longitude": 800.406969,
        "image": "assets/images/land_tree_dark.png",
        "date": "2023-11-21",
        "time": "16:26"
      },
      {
        "latitude": 03.710648,
        "longitude": 90.406969,
        "image": "assets/images/logo.png",
        "date": "2023-11-10",
        "time": "16:26"
      },
      {
        "latitude": 1.710648,
        "longitude": 2.406969,
        "image": "assets/images/land_tree_light.png",
        "date": "2023-11-05",
        "time": "16:26"
      },
      {
        "latitude": 1232.710648,
        "longitude": 22.406969,
        "image": "assets/images/land_tree_light.png",
        "date": "2023-11-05",
        "time": "16:26"
      },
      {
        "latitude": 0.710648,
        "longitude": 02.406969,
        "image": "assets/images/land_tree_light.png",
        "date": "2023-09-05",
        "time": "16:26"
      },
    ];
  }

  // List<Map<String, dynamic>> demoData = [
  //   {
  //     "latitude": _currentPosition!.latitude,
  //     "longitude": _currentPosition!.longitude,
  //     "image": "assets/images/logo.png",
  //     "date": "2023-11-11",
  //     "time": "16:26"
  //   },
  //   {
  //     "latitude": 83.710648,
  //     "longitude": 0.406969,
  //     "image": "assets/images/land_tree_dark.png",
  //     "date": "2023-11-11",
  //     "time": "16:26"
  //   },
  //   {
  //     "latitude": 23.710648,
  //     "longitude": 800.406969,
  //     "image": "assets/images/land_tree_dark.png",
  //     "date": "2023-11-21",
  //     "time": "16:26"
  //   },
  //   {
  //     "latitude": 03.710648,
  //     "longitude": 90.406969,
  //     "image": "assets/images/logo.png",
  //     "date": "2023-11-10",
  //     "time": "16:26"
  //   },
  //   {
  //     "latitude": 1.710648,
  //     "longitude": 2.406969,
  //     "image": "assets/images/land_tree_light.png",
  //     "date": "2023-11-05",
  //     "time": "16:26"
  //   },
  //   {
  //     "latitude": 1232.710648,
  //     "longitude": 22.406969,
  //     "image": "assets/images/land_tree_light.png",
  //     "date": "2023-11-05",
  //     "time": "16:26"
  //   },
  //   {
  //     "latitude": 0.710648,
  //     "longitude": 02.406969,
  //     "image": "assets/images/land_tree_light.png",
  //     "date": "2023-09-05",
  //     "time": "16:26"
  //   },
  // ];

  GpsDatabaseHelper helper = GpsDatabaseHelper();
  Future<void> insertDemoData() async {
    for(Map<String, dynamic> row in getDemoData()) {
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
