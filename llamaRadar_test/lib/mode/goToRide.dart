import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lamaradar/temp/CollisionWarningPage.dart';
import 'package:lamaradar/temp/glowing_button.dart';
import 'package:lamaradar/temp/BLEDevicePage.dart';

class GoToRide extends StatefulWidget {
  final BluetoothDevice device;

  const GoToRide({Key? key, required this.device}) : super(key: key);

  @override
  _GoToRideState createState() => _GoToRideState();
}

class _GoToRideState extends State<GoToRide> {

  BluetoothDevice? _connectedDevice;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFa8caba), Color(0xFF517fa4)],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.black,
          title: Text('Ride'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2580B3),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: 500.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: GlowingButton2(
                  text: "Go to ride",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BLEDevicePage(device: widget.device)),
                    );
                  },
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}