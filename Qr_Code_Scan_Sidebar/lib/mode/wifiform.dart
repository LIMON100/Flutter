import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WifiInfo {
  final String ssid;
  final String pass;

  WifiInfo({required this.ssid, required this.pass});

  factory WifiInfo.fromJson(Map<String, dynamic> json) {
    return WifiInfo(ssid: json['ssid'], pass: json['pass']);
  }
}

class ResponseData {
  final int cmd;
  final int status;

  ResponseData({required this.cmd, required this.status});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(cmd: json['cmd'], status: json['status']);
  }
}

class WifiForm extends StatefulWidget {
  const WifiForm({Key? key}) : super(key: key);
  @override
  _WifiFormState createState() => _WifiFormState();
}

class _WifiFormState extends State<WifiForm> {
  final _formKey = GlobalKey<FormState>();
  final _ssidController = TextEditingController();
  final _passController = TextEditingController();
  WifiInfo? _wifiInfo;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final ssid = _ssidController.text.trim();
      final pass = _passController.text.trim();
      final url = Uri.parse('http://192.168.0.106/api/v1/custom=4&cmd=4001');
      final body = json.encode({'ssid': ssid, 'pass': pass});
      final response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        final responseData = ResponseData.fromJson(json.decode(response.body)['funtion'][0]);
        final requestJson = json.decode(response.body)['request'];
        setState(() {
          _wifiInfo = WifiInfo.fromJson(requestJson);
        });
      } else {
        // handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WiFi Info Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _ssidController,
                decoration: InputDecoration(labelText: 'SSID'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a SSID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
              SizedBox(height: 16.0),
              if (_wifiInfo != null)
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(children: [
                      TableCell(child: Text('SSID')),
                      TableCell(child: Text(_wifiInfo!.ssid)),
                    ]),
                    TableRow(children: [
                      TableCell(child: Text('Password')),
                      TableCell(child: Text(_wifiInfo!.pass)),
                    ]),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
