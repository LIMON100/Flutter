import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/model.dart';
import 'dart:convert';
import 'package:lamaApp/mode/testmode.dart';

class BleInfo extends StatefulWidget {
  final Function(File)? onImageSelected;
  const BleInfo({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _BleInfoState createState() => _BleInfoState();
}

class _BleInfoState extends State<BleInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      home: Scaffold(
        appBar: AppBar(
          title: Text("My App"),
        ),
        drawer: TestMode(), // Add the MyDrawer widget here
        body: Center(
          child: Text("Hello, World!"),
        ),
      ),
    );
  }
}
