import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lamaradar/temp/CollisionWarningPage.dart';
import 'package:lamaradar/temp/glowing_button.dart';
import 'package:lamaradar/temp/BLEDevicePage.dart';
import 'package:lamaradar/temp/CollisionWarningPage2.dart';

class GoToRide extends StatefulWidget {
  final BluetoothDevice device;

  const GoToRide({Key? key, required this.device}) : super(key: key);

  @override
  _GoToRideState createState() => _GoToRideState();
}


class _GoToRideState extends State<GoToRide> {
  BluetoothDevice? _connectedDevice;
  bool _isConnected = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _connectToDevice();
  // }
  //
  // Future<void> _connectToDevice() async {
  //   // Connect to the device
  //   try {
  //     await widget.device.connect();
  //     setState(() {
  //       _isConnected = true;
  //       _connectedDevice = widget.device;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isConnected = false;
  //       _connectedDevice = null;
  //     });
  //     print('Error connecting to device: $e');
  //   }
  // }

  // void _disconnectFromDevice() async {
  //   if (_isConnected && _connectedDevice != null) {
  //     try {
  //       await _connectedDevice!.disconnect();
  //       setState(() {
  //         _isConnected = false;
  //         _connectedDevice = null;
  //       });
  //     } catch (e) {
  //       print('Error disconnecting from device: $e');
  //     }
  //   }
  // }
  Future<void> _disconnectFromDevice() async {
    // if (!_isConnected || widget.device == null) {
    //   print('Not connected to a device');
    //   return;
    // }

    await widget.device.disconnect();
    print('Disconnected from ${widget.device.name}');

    setState(() {
      _isConnected = false;
      // widget.device = null;
    });
  }

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
          actions: [
            // IconButton(
            //   icon: Icon(Icons.bluetooth_connected),
            //   onPressed: _disconnectFromDevice,
            // ),
            SizedBox(height: 1),
            GlowingButton2(
              text: "Disconnect",
              onPressed: _disconnectFromDevice,
              color1: Color(0xFF2580B3),
              color2: Color(0xFF2580B3),
            ),
          ],
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
                      MaterialPageRoute(builder: (context) => CollisionWarningPage2(device: widget.device)),
                    );
                  },
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
