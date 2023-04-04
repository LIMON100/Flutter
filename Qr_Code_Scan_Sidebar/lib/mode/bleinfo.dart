import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/model.dart';
import 'dart:convert';
import 'package:lamaApp/mode/testmode.dart';
import 'package:lamaApp/temp/animatedbutton.dart';
import 'package:lamaApp/temp/glowing_button.dart';

class BleInfo extends StatefulWidget {

  const BleInfo({Key? key}) : super(key: key);

  @override
  _BleInfoState createState() => _BleInfoState();
}

class _BleInfoState extends State<BleInfo> {
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //       decoration: const BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //           colors: [Color(0xFFCBBACC), Color(0xFF2580B3)],
  //         ),
  //       ),
  //     child: MaterialApp(
  //       home: Scaffold(
  //         backgroundColor: Colors.transparent,
  //         appBar: AppBar(
  //           centerTitle: true,
  //           title: Text("BLE")
  //         ), // Add the MyDrawer widget here
  //         body: Center(
  //           child: AnimatedButton(
  //             text: 'Press me',
  //             onPressed: () {
  //               print('Button pressed!');
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Can change to any color you want.
            GlowingButton(
              color1: Colors.orange,
              color2: Colors.red,
            ),
            GlowingButton(
              color1: Colors.pinkAccent,
              color2: Colors.indigoAccent,
            ),
            GlowingButton(),
            // GlowingButton(
            //   text: 'GLOWING BUTTON',
            //   onPressed: () {
            //     print('Button pressed!');
            //   },
            // ),

          ],
        ),
      ),
    );
  }
}
