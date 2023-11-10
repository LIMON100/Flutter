import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'saved_coordinates_screen.dart';

class LocationPageSharedPreference extends StatefulWidget {
  const LocationPageSharedPreference({Key? key}) : super(key: key);

  @override
  State<LocationPageSharedPreference> createState() => _LocationPageSharedPreferenceState();
}

class _LocationPageSharedPreferenceState extends State<LocationPageSharedPreference> {
  String? _currentAddress;
  Position? _currentPosition;
  late Timer _timer;
  List<Map<String, double>> _savedCoordinatesList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCoordinates();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _getCurrentPosition();
    });
  }

  // Future<void> _loadSavedCoordinates() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final double? savedLatitude = prefs.getDouble('latitude');
  //   final double? savedLongitude = prefs.getDouble('longitude');
  //
  //   if (savedLatitude != null && savedLongitude != null) {
  //     setState(() {
  //       _currentPosition = Position(
  //         latitude: savedLatitude,
  //         longitude: savedLongitude,
  //         altitude: 0.0,
  //         accuracy: 0.0,
  //         heading: 0.0,
  //         speed: 0.0,
  //         speedAccuracy: 0.0,
  //         altitudeAccuracy: 0.0,
  //         headingAccuracy: 0.0,
  //         timestamp: DateTime.now(),
  //       );
  //     });
  //     _getAddressFromLatLng(_currentPosition!);
  //   }
  // }
  Future<void> _loadSavedCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedCoordinatesJsonList =
    prefs.getStringList('coordinatesList');

    if (savedCoordinatesJsonList != null) {
      _savedCoordinatesList = savedCoordinatesJsonList
          .map((jsonString) => Map<String, double>.from(json.decode(jsonString)))
          .toList();
    }
  }

  Future<void> _saveCoordinatesList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> coordinatesJsonList = _savedCoordinatesList
        .map((coordinates) => json.encode(coordinates))
        .toList();

    prefs.setStringList('coordinatesList', coordinatesJsonList);
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _savedCoordinatesList.add({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      });
      _getAddressFromLatLng(_currentPosition!);
      _saveCoordinates(_currentPosition!);
      _saveCoordinatesList();
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

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();
  //
  //   if (!hasPermission) return;
  //
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() => _currentPosition = position);
  //     _getAddressFromLatLng(_currentPosition!);
  //     _saveCoordinates(_currentPosition!);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

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

  Future<void> _saveCoordinates(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', position.latitude);
    prefs.setDouble('longitude', position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SavedCoordinatesScreen()),
                  );
                },
                child: const Text("Check Saved Coordinates"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
