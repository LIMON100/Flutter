import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Uint8List? image;

  MapScreen({required this.latitude, required this.longitude, this.image});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
                        if (widget.image != null)
                          Container(
                            width: double.infinity, // Set width to maximum available width
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Image.memory(
                                widget.image!,
                              ),
                            ),
                          ),
                        SizedBox(height: 20),
                        // Display the GPS coordinates
                        Text('Latitude: ${widget.latitude}, Longitude: ${widget.longitude}'),
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
      // else {
      //   _markers.add( Marker(
      //       markerId: MarkerId(i.toString()),
      //       position: LatLng(widget.latitude,  widget.longitude),
      //       icon: BitmapDescriptor.fromBytes(markerIcon),
      //       onTap: () {
      //         _customInfoWindowController.addInfoWindow!(
      //           Container(
      //             width: 300,
      //             height: 200,
      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               border: Border.all(color: Colors.grey),
      //               borderRadius: BorderRadius.circular(10.0),
      //             ),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   width: 300,
      //                   height: 100,
      //                   decoration: BoxDecoration(
      //                     image: DecorationImage(
      //                         image: NetworkImage('https://images.pexels.com/photos/1566837/pexels-photo-1566837.jpeg?cs=srgb&dl=pexels-narda-yescas-1566837.jpg&fm=jpg'),
      //                         fit: BoxFit.fitWidth,
      //                         filterQuality: FilterQuality.high),
      //                     borderRadius: const BorderRadius.all(
      //                       Radius.circular(10.0),
      //                     ),
      //                     color: Colors.red,
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.only(top: 10 , left: 10 , right: 10),
      //                   child: Row(
      //                     children: [
      //                       SizedBox(
      //                         width: 100,
      //                         child: Text(
      //                           'Beef Tacos',
      //                           maxLines: 1,
      //                           overflow: TextOverflow.fade,
      //                           softWrap: false,
      //                         ),
      //                       ),
      //                       const Spacer(),
      //                       Text(
      //                         '.3 mi.',
      //                         // widget.data!.date!,
      //
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.only(top: 10 , left: 10 , right: 10),
      //                   child: Text(
      //                     'Help me finish these tacos! I got a platter from Costco and it’s too much.',
      //                     maxLines: 2,
      //
      //                   ),
      //                 ),
      //
      //               ],
      //             ),
      //           ),
      //           LatLng(33.6844, 73.0479),
      //         );
      //       }
      //   ));
      // }
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
        // {
        //   Marker(
        //     markerId: MarkerId('location_marker'),
        //     position: LatLng(widget.latitude, widget.longitude),
        //     icon: BitmapDescriptor.fromBytes(markerIcon),
        //     onTap: () {
        //       // Show a dialog with GPS coordinates and image
        //       showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             title: Text('Marker Details'),
        //             content: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 Text('Latitude: ${widget.latitude}, Longitude: ${widget.longitude}'),
        //                 SizedBox(height: 8.0),
        //                 if (widget.image != null)
        //                   Image.memory(
        //                     widget.image!,
        //                     height: 100.0,
        //                     width: 100.0,
        //                   ),
        //               ],
        //             ),
        //             actions: [
        //               ElevatedButton(
        //                 onPressed: () {
        //                   Navigator.of(context).pop();
        //                 },
        //                 child: Text('Close'),
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     },
        //   ),
        // },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
