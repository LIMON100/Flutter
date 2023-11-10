import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';

import 'SavedCoordinatesImageScreen.dart';
import 'package:path_provider/path_provider.dart';


class LocationwithScreenShot extends StatefulWidget {
  const LocationwithScreenShot({Key? key}) : super(key: key);

  @override
  State<LocationwithScreenShot> createState() => _LocationwithScreenShotState();
}

class _LocationwithScreenShotState extends State<LocationwithScreenShot> {
  String? _currentAddress;
  Position? _currentPosition;
  late Timer _timer;
  final ScreenshotController _screenshotController = ScreenshotController();

  List<Map<String, dynamic>> _savedDataList = [];

  @override
  void initState() {
    super.initState();
    _loadSavedDataList();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _getCurrentPosition();
      _captureAndSaveScreenshot();
    });
  }

  Future<void> _loadSavedDataList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedDataJsonList =
    prefs.getStringList('savedDataList');

    if (savedDataJsonList != null) {
      _savedDataList = savedDataJsonList
          .map((jsonString) => Map<String, dynamic>.from(json.decode(jsonString)))
          .toList();
    }
  }

  Future<void> _saveDataList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dataJsonList = _savedDataList
        .map((data) => json.encode(data))
        .toList();

    prefs.setStringList('savedDataList', dataJsonList);
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _savedDataList.add({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
      _getAddressFromLatLng(_currentPosition!);
      _saveCoordinates(_currentPosition!);
      _saveDataList();
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

  Future<void> _saveCoordinates(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', position.latitude);
    prefs.setDouble('longitude', position.longitude);
  }

  Future<void> _captureAndSaveScreenshot() async {
    try {
      Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes != null) {
        final String timestamp = DateTime.now().toIso8601String();
        final String fileName = 'screenshot_$timestamp.png';
        final String imagePath = await _saveImageToFile(imageBytes, fileName);

        setState(() {
          _savedDataList.last['screenshot'] = imagePath;
        });
        _saveDataList();
      }
    } catch (e) {
      debugPrint("Error capturing and saving screenshot: $e");
    }
  }

  Future<String> _saveImageToFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
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
                    MaterialPageRoute(builder: (context) => SavedCoordinatesImageScreen()),
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
}
