import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ride_history/maps/temp/custom_marker_with_network_image.dart';

class TestGps extends StatefulWidget {
  @override
  _TestGpsState createState() => _TestGpsState();
}

class _TestGpsState extends State<TestGps> {

  final String videoUrl = 'https://media.w3.org/2010/05/sintel/trailer.mp4';
  final VlcPlayerController _controller = VlcPlayerController.network(
    'https://media.w3.org/2010/05/sintel/trailer.mp4',
    options: VlcPlayerOptions(),
  );
  bool _isPlaying = false;
  Uint8List? _screenshot;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _takeScreenshot() async {
    try {
      final screenshot = await _controller.takeSnapshot();
      print("SCREEN");
      print(screenshot);
      setState(() {
        _screenshot = screenshot;
      });
    } catch (error) {
      print(error);

    // Show a specific place initially
    addMarker(23.8103, 90.4125, 'Initial Location');
  }

  void navigateToLocation(double latitude, double longitude, String title) async {
    String uri = 'geo:$latitude,$longitude?q=$latitude,$longitude($title)';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print('Could not launch $uri');
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> addMarker(double latitude, double longitude, String title) async {
    Completer<void> completer = Completer<void>();

    void updateMarkers() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('selected-location'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: title),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      completer.complete();
    }

    setState(() {
      updateMarkers();
    });

    await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Video Player'),
        actions: [
          ElevatedButton(
            onPressed: _takeScreenshot,
            child: Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: Column(
        children: [
          VlcPlayer(
            controller: _controller,
            placeholder: Center(child: CircularProgressIndicator()),
            aspectRatio: 16 / 9,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _togglePlay,
            child: _isPlaying ? Text('Pause') : Text('Play'),
          ),
          SizedBox(height: 16),
          if (_screenshot != null)
            Image.memory(
              _screenshot!,
              width: 300, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
        ],
      ),
    );
  }
  // TextEditingController latitudeController = TextEditingController();
  // TextEditingController longitudeController = TextEditingController();
  // Set<Marker> markers = {};
  // Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // Show a specific place initially
  //   addMarker(23.8103, 90.4125, 'Initial Location');
  // }
  //
  // void navigateToLocation(double latitude, double longitude, String title) async {
  //   String uri = 'geo:$latitude,$longitude?q=$latitude,$longitude($title)';
  //   if (await canLaunch(uri)) {
  //     await launch(uri);
  //   } else {
  //     print('Could not launch $uri');
  //   }
  // }
  //
  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  // }
  //
  // Future<void> addMarker(double latitude, double longitude, String title) async {
  //   Completer<void> completer = Completer<void>();
  //
  //   void updateMarkers() {
  //     markers.clear();
  //     markers.add(
  //       Marker(
  //         markerId: MarkerId('selected-location'),
  //         position: LatLng(latitude, longitude),
  //         infoWindow: InfoWindow(title: title),
  //         icon: BitmapDescriptor.defaultMarker,
  //       ),
  //     );
  //     completer.complete();
  //   }
  //
  //   setState(() {
  //     updateMarkers();
  //   });
  //
  //   await completer.future;
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Navigate to Location'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           ElevatedButton(
  //             onPressed: () async {
  //               Navigator.pop(context);
  //               Navigator.of(context).push(
  //                 MaterialPageRoute(
  //                   builder: (context) => CustomMarkerWithNetworkImage(), //ConnectWifiForDashCam
  //                 ),
  //               );
  //             },
  //             child: Text('Network Image'),
  //           ),
  //           SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () async {
  //               // Add 10 different locations near Basundhara Shopping Complex
  //               List<LatLng> dhakaLocations = [
  //                 LatLng(23.8134, 90.4125),
  //                 LatLng(23.8155, 90.4141),
  //                 LatLng(23.8113, 90.4085),
  //                 LatLng(23.8092, 90.4100),
  //                 LatLng(23.8073, 90.4120),
  //                 LatLng(23.8078, 90.4160),
  //                 LatLng(23.8119, 90.4165),
  //                 LatLng(23.8161, 90.4175),
  //                 LatLng(23.8169, 90.4140),
  //                 LatLng(23.8142, 90.4115),
  //               ];
  //
  //               for (int i = 0; i < dhakaLocations.length; i++) {
  //                 await Future.delayed(Duration(milliseconds: 500)); // Delay for better visualization
  //                 addMarker(dhakaLocations[i].latitude, dhakaLocations[i].longitude, 'Location $i');
  //               }
  //
  //               // Set camera position to fit all markers
  //               setCameraPosition(dhakaLocations);
  //             },
  //             child: Text('Navigate to New Location'),
  //           ),
  //           SizedBox(height: 20),
  //           Container(
  //             height: 300,
  //             child: GoogleMap(
  //               initialCameraPosition: CameraPosition(
  //                 target: LatLng(23.8103, 90.4125), // Initial location (Basundhara Shopping Complex)
  //                 zoom: 14,
  //               ),
  //               markers: markers,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // void setCameraPosition(List<LatLng> locations) async {
  //   double minLat = locations.first.latitude;
  //   double maxLat = locations.first.latitude;
  //   double minLng = locations.first.longitude;
  //   double maxLng = locations.first.longitude;
  //
  //   for (LatLng location in locations) {
  //     if (location.latitude < minLat) minLat = location.latitude;
  //     if (location.latitude > maxLat) maxLat = location.latitude;
  //     if (location.longitude < minLng) minLng = location.longitude;
  //     if (location.longitude > maxLng) maxLng = location.longitude;
  //   }
  //
  //   double centerLat = (minLat + maxLat) / 2;
  //   double centerLng = (minLng + maxLng) / 2;
  //
  //   double zoomLevel = getZoomLevel(minLat, maxLat, minLng, maxLng);
  //
  //   // Get the GoogleMapController
  //   GoogleMapController controller = await _controller.future;
  //
  //   // Update camera position
  //   CameraPosition newCameraPosition = CameraPosition(target: LatLng(centerLat, centerLng), zoom: zoomLevel);
  //   controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  // }
  //
  //
  // double getZoomLevel(double minLat, double maxLat, double minLng, double maxLng) {
  //   const double zoomConstant = 12.0;
  //   double zoomLevel = 12.0;
  //
  //   double deltaLat = maxLat - minLat;
  //   double deltaLng = maxLng - minLng;
  //
  //   double maxDelta = deltaLat > deltaLng ? deltaLat : deltaLng;
  //
  //   while ((maxDelta * zoomConstant) > 120) {
  //     zoomLevel--;
  //     maxDelta /= 2;
  //   }
  //
  //   return zoomLevel;
  // }

        title: Text('Navigate to Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CustomMarkerWithNetworkImage(), //ConnectWifiForDashCam
                  ),
                );
              },
              child: Text('Network Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Add 10 different locations near Basundhara Shopping Complex
                List<LatLng> dhakaLocations = [
                  LatLng(23.8134, 90.4125),
                  LatLng(23.8155, 90.4141),
                  LatLng(23.8113, 90.4085),
                  LatLng(23.8092, 90.4100),
                  LatLng(23.8073, 90.4120),
                  LatLng(23.8078, 90.4160),
                  LatLng(23.8119, 90.4165),
                  LatLng(23.8161, 90.4175),
                  LatLng(23.8169, 90.4140),
                  LatLng(23.8142, 90.4115),
                ];

                for (int i = 0; i < dhakaLocations.length; i++) {
                  await Future.delayed(Duration(milliseconds: 500)); // Delay for better visualization
                  addMarker(dhakaLocations[i].latitude, dhakaLocations[i].longitude, 'Location $i');
                }

                // Set camera position to fit all markers
                setCameraPosition(dhakaLocations);
              },
              child: Text('Navigate to New Location'),
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(23.8103, 90.4125), // Initial location (Basundhara Shopping Complex)
                  zoom: 14,
                ),
                markers: markers,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setCameraPosition(List<LatLng> locations) async {
    double minLat = locations.first.latitude;
    double maxLat = locations.first.latitude;
    double minLng = locations.first.longitude;
    double maxLng = locations.first.longitude;

    for (LatLng location in locations) {
      if (location.latitude < minLat) minLat = location.latitude;
      if (location.latitude > maxLat) maxLat = location.latitude;
      if (location.longitude < minLng) minLng = location.longitude;
      if (location.longitude > maxLng) maxLng = location.longitude;
    }

    double centerLat = (minLat + maxLat) / 2;
    double centerLng = (minLng + maxLng) / 2;

    double zoomLevel = getZoomLevel(minLat, maxLat, minLng, maxLng);

    // Get the GoogleMapController
    GoogleMapController controller = await _controller.future;

    // Update camera position
    CameraPosition newCameraPosition = CameraPosition(target: LatLng(centerLat, centerLng), zoom: zoomLevel);
    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }


  double getZoomLevel(double minLat, double maxLat, double minLng, double maxLng) {
    const double zoomConstant = 12.0;
    double zoomLevel = 12.0;

    double deltaLat = maxLat - minLat;
    double deltaLng = maxLng - minLng;

    double maxDelta = deltaLat > deltaLng ? deltaLat : deltaLng;

    while ((maxDelta * zoomConstant) > 120) {
      zoomLevel--;
      maxDelta /= 2;
    }

    return zoomLevel;
}