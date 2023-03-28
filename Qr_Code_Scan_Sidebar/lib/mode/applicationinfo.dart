import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApplicationInfo extends StatefulWidget {

  const ApplicationInfo({Key? key}) : super(key: key);

  @override
  _ApplicationInfoState createState() => _ApplicationInfoState();
}

class _ApplicationInfoState extends State<ApplicationInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Application"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start and stop app button and field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Start App code'),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 50,
                  child: TextField(
                    //controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Close App code'),
                ),
              ],
            ),

            //Restart button and text field
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {},
              child: Text('Restart app'),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 50,
              child: TextField(
                //controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 35.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Data Collection'),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Main application'),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Data Upload'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              width: 80,
              child: TextField(

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),

          //  Play Audio
            SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Play Audio'),
                ),
                Container(
                  width: 50,
                  child: TextField(
                    //controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
             ),
          ],
        ),
      ),
    );
  }
}