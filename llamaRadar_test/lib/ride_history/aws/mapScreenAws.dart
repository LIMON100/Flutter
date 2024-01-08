import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';

class MapScreenAws extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String position;
  // final Uint8List? image;
  final String imageUrl;
  final String imageKey;

  MapScreenAws({required this.latitude, required this.longitude, required this.imageUrl, required this.imageKey, required this.position});

  @override
  _MapScreenAwsState createState() => _MapScreenAwsState();
}

class _MapScreenAwsState extends State<MapScreenAws> {

  late GoogleMapController mapController;
  final LatLng _latLng = LatLng(33.6844, 73.0479);
  final double _zoom = 15.0;
  Set<Marker> _markers = {};
  List<String> images = ['assets/images/startup2.png' , 'assets/images/startup2.png'];
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    loadData() ;
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }


  loadData()async{
    for(int i = 0 ; i < images.length ; i++){
      final Uint8List markerIcon = await getBytesFromAsset(images[i].toString(), 180);
      if(i == 1 ){
        _markers.add(
            Marker(
                markerId: MarkerId('2'),
                position: LatLng(widget.latitude,  widget.longitude),
                icon: BitmapDescriptor.fromBytes(markerIcon),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // title: Text('Marker Details'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Display the image with BoxFit.width if available
                            if (widget.imageUrl != null)
                              CachedNetworkImage(
                                errorWidget: (context, url, dynamic error) =>
                                const Icon(Icons.error_outline_outlined),
                                imageUrl: widget.imageUrl,
                                cacheKey: widget.imageKey,
                                width: double.maxFinite,
                                height: 350,
                                alignment: Alignment.topCenter,
                                fit: BoxFit.fill,
                              ),
                            SizedBox(height: 20),
                            // Display the GPS coordinates
                            Text('Latitude: ${widget.latitude}, Longitude: ${widget.longitude}, Position: ${widget.position}'),
                          ],
                        ),
                      );
                    },
                  );
                  _customInfoWindowController.addInfoWindow!(
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    "I am here",
                                    style:
                                    Theme.of(context).textTheme.headline6!.copyWith(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ],
                    ),
                    LatLng(33.6992,  72.9744),
                  );
                }
            ));
      }
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
