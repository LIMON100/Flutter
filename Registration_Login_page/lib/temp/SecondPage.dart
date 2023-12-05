import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};
  List<LatLng> _coordinates = [
    LatLng(51.5074, -0.1278), // London
    LatLng(40.7128, -74.0060), // New York
    // Add more coordinates here
  ];

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    for (int i = 0; i < _coordinates.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _coordinates[i],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordinates Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _coordinates[0], // Show the first coordinate
          zoom: 5.0,
        ),
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your logic to display the warning sign
        },
        child: SvgPicture.asset(
          'assets/warning_sign.png', // Add the path to your SVG asset
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
