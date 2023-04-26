import 'package:flutter/material.dart';
import 'package:lamaradar/mode/rideInfo.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:lamaradar/temp/glowing_button.dart';
import 'package:lamaradar/mode/reviewRide.dart';
import 'package:lamaradar/mode/rideVideos.dart';

class StartRide extends StatefulWidget {
  @override
  _StartRideState createState() => _StartRideState();
}

class _StartRideState extends State<StartRide> {

  String _selectedButton = '';

  void _incrementCounter1() {
    setState(() {
      _selectedButton = 'New York';
    });
  }

  void _incrementCounter2() {
    setState(() {
      _selectedButton = 'America';
    });
  }

  void _incrementCounter3() {
    setState(() {
      _selectedButton = '12/8';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('Ride Info'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xFF2580B3),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.speed, size: 48, color: Colors.red),
                    SizedBox(height: 8),
                    Text('50 km/h',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87
                      ),),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.timer, size: 48, color: Colors.green),
                    SizedBox(height: 8),
                    Text('15Min',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87
                      ),),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.add_road, size: 48, color: Colors.black),
                    SizedBox(height: 8),
                    Text('13M',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87
                      ),),
                  ],
                ),
              ],
            ),

            //Switch button
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Light', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    LiteRollingSwitch(
                      width: 100,
                      value: false,
                      textOn: 'On',
                      textOff: 'Off',
                      colorOn: Colors.greenAccent,
                      colorOff: Colors.redAccent,
                      iconOn: Icons.done,
                      iconOff: Icons.alarm_off,
                      textSize: 16.0,
                      onChanged: (bool state) {
                        //Use it to manage the different states
                        print('Current State of SWITCH IS: $state');
                      },
                      onDoubleTap: () {
                        // Handle the double tap event here
                      },
                      onSwipe: () {
                        // Handle the swipe event here
                      },
                      onTap: (){},
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Sound', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    LiteRollingSwitch(
                      width: 100,
                      value: false,
                      textOn: 'On',
                      textOff: 'Off',
                      colorOn: Colors.greenAccent,
                      colorOff: Colors.redAccent,
                      iconOn: Icons.done,
                      iconOff: Icons.alarm_off,
                      textSize: 16.0,
                      onChanged: (bool state) {
                        //Use it to manage the different states
                        print('Current State of SWITCH IS: $state');
                      },
                      onDoubleTap: () {
                        // Handle the double tap event here
                      },
                      onSwipe: () {
                        // Handle the swipe event here
                      },
                      onTap: (){},
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Vibration', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    LiteRollingSwitch(
                      width: 100,
                      value: false,
                      textOn: 'On',
                      textOff: 'Off',
                      colorOn: Colors.greenAccent,
                      colorOff: Colors.redAccent,
                      iconOn: Icons.done,
                      iconOff: Icons.alarm_off,
                      textSize: 16.0,
                      onChanged: (bool state) {
                        //Use it to manage the different states
                        print('Current State of SWITCH IS: $state');
                      },
                      onDoubleTap: () {
                        // Handle the double tap event here
                      },
                      onSwipe: () {
                        // Handle the swipe event here
                      },
                      onTap: (){},
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter1,
                  child: Text('City'),
                ),
                ElevatedButton(
                  onPressed: _incrementCounter2,
                  child: Text('Country'),
                ),
                ElevatedButton(
                  onPressed: _incrementCounter3,
                  child: Text('Road'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '$_selectedButton',
              style: TextStyle(fontSize: 20),
            ),

            SizedBox(height: 16),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.005),
              child: GlowingButton2(
                text: "Stop Ride",
                onPressed: (){},
                color1: Colors.blueAccent,
                color2: Colors.indigo,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.005),
              child: GlowingButton2(
                text: "Review Ride",
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewRide()),
                  );
                },
                color1: Colors.blueAccent,
                color2: Colors.indigo,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.005),
              child: GlowingButton2(
                text: "Watch ride videos",
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RideVideos()),
                  );
                },
                color1: Colors.blueAccent,
                color2: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}