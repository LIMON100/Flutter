import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/CheckWifiInfo.dart';
import 'package:lamaApp/llama_web_menu.dart';

class CameraInfo extends StatefulWidget {

  const CameraInfo({Key? key}) : super(key: key);

  @override
  _CameraInfoState createState() => _CameraInfoState();
}

class _CameraInfoState extends State<CameraInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CAMERA"),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: <Widget>[
      //           ElevatedButton(
      //             onPressed: () {
      //               // handle button press
      //             },
      //             child: Text('Open Camera'),
      //           ),
      //           SizedBox(width: 20),
      //           ElevatedButton(
      //             onPressed: () {
      //               // handle button press
      //             },
      //             child: Text('Close Camera'),
      //           ),
      //         ],
      //       ),
      //       SizedBox(height: 20),
      //       Container(
      //         width: 200,
      //         child: TextField(
      //
      //           decoration: InputDecoration(
      //             border: OutlineInputBorder(),
      //             // labelText: 'Enter some text',
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       Text(
      //         'Snapshot take',
      //         style: TextStyle(fontSize: 24.0),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           // handle button press
      //         },
      //         child: Text('STOP'),
      //       ),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Open Camera'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Close Camera'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
                  width: 200,
                  child: TextField(
                    //controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
            SizedBox(height: 100),
            Text(
              'Snapshot take',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 35.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Front Camera'),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Rear Up Camera'),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Rear Down Camera'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // handle button press
              },
              child: Text('STOP'),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 200,
              child: TextField(

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}