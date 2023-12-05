import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DemoGPSCoordinatesPage extends StatefulWidget {
  @override
  _DemoGPSCoordinatesPageState createState() => _DemoGPSCoordinatesPageState();
}

class _DemoGPSCoordinatesPageState extends State<DemoGPSCoordinatesPage> {
  List<LatLng> _demoGPSCoordinates = [
    LatLng(37.7749, -122.4194), // San Francisco, USA
    LatLng(-33.8688, 151.2093), // Sydney, Australia
    LatLng(35.6895, 139.6917), // Tokyo, Japan
    LatLng(51.5072, -0.1275), // London, UK
    LatLng(48.8566, 2.3522), // Paris, France
    LatLng(40.7128, -74.0060), // New York City, USA
    LatLng(-22.9069, -43.1729), // Rio de Janeiro, Brazil
    LatLng(41.8933, 12.4828), // Rome, Italy
    LatLng(37.9104, 23.7225), // Athens, Greece
    LatLng(31.2304, 121.4737), // Shanghai, China
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo GPS Coordinates'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: _demoGPSCoordinates.map((latLng) {
          return Marker(
            markerId: MarkerId(latLng.toString()),
            position: latLng,
          );
        }).toSet(),
      ),
    );
  }
}