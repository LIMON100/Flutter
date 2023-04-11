import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class TestFw extends StatefulWidget {

  const TestFw({Key? key}) : super(key: key);

  @override
  _TestFwState createState() => _TestFwState();
}

class _TestFwState extends State<TestFw> with SingleTickerProviderStateMixin{
  // final _urlController = TextEditingController();
  TextEditingController _outputController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  Future<void> _submitPostRequest() async {
    final url = Uri.parse('http://192.168.0.103/api/v1/custom=7&cmd=7002');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'url': _urlController.text.trim()});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = json.decode(response.body);
      // Do something with the response data
    } catch (error) {
      print('Error making post request: $error');
    }
  }

  Future<String> makePostRequest() async {
    String url = 'http://192.168.0.103/api/v1/custom=7&cmd=7002';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"url": "${_urlController.text}"}';
    http.Response response =
    await http.post(Uri.parse(url), headers: headers, body: json);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['message'];
    } else {
      throw Exception('Failed to make post request.');
    }
  }

  AnimationController? controller;
  Animation<Color>? animation;
  double progress = 0;
  Widget buildLinearProgress() => Text(
    '${(progress * 100).toStringAsFixed(1)}',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  );

  Widget buildProgress() {
    if (progress == 1) {
      return Icon(
        Icons.done,
        color: Colors.green,
        size: 56,
      );
    } else {
      return Text(
        '${(progress * 100).toStringAsFixed(1)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
      );
    }
  }

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
          title: Text('Model & Firmware'),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'Enter ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                alignment: Alignment.center,
                height: 100,
                width: 10,
                child: LiquidCircularProgressIndicator(
                  value: 0.5, // Defaults to 0.5.
                  // value: progress,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF2580B3)), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.black38,
                  borderWidth: 5.0,
                  direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: Text("Loading..."),
                  // center: Text('${(progress * 100).toStringAsFixed(0)}%'),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 100,
                height: 30,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      valueColor: AlwaysStoppedAnimation(Colors.green),
                      backgroundColor: Colors.white,
                    ),
                    Center(child: buildLinearProgress()),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Update LlamaEsp'),
                onPressed: () async {
                  String response = await makePostRequest();
                  setState(() {
                    _outputController.text = response;
                  });
                },
              ),
              TextField(
                controller: _outputController,
                maxLines: null,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Post Request Output',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitPostRequest,
                child: Text('Update Llamak210'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitPostRequest,
                child: Text('Update AI Model'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
