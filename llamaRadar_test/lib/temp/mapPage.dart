import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  MapPage({required this.startLat,required this.startLng,required this.endLat,required this.endLng});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;

  LatLng? _start;
  LatLng? _end;

  @override
  void initState() {
    super.initState();
    _start = LatLng(widget.startLat, widget.startLng);
    _end = LatLng(widget.endLat, widget.endLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start and End Distance Map"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _start!,
          zoom: 10.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId("start"),
            position: _start!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(title: "Start"),
          ),
          Marker(
            markerId: MarkerId("end"),
            position: _end!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: "End"),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            color: Colors.blue,
            width: 4,
            points: [
              _start!,
              _end!,
            ],
          ),
        },
      ),
    );
  }
}
