<<<<<<< HEAD
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFCBBACC), Color(0xFF2580B3)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text("CAMERA"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF2580B3),
            ),
          ),
        ),
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
                height: 150,
                width: 200,
                child: Image.asset('',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                height: 150,
                width: 200,
                child: Image.asset('',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
=======
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text("CAMERA"),
        ),
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
                height: 150,
                width: 200,
                child: Image.asset('',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                height: 150,
                width: 200,
                child: Image.asset('',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
>>>>>>> a8776f8116c317b8a4629530ef06c600a63434ce
}