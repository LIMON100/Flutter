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

  // postData() async{
  //   var response = await http.post(
  //     Uri.parse("http://192.168.0.105/api/v1/custom=1&cmd=1001"),
  //     body: {
  //       "id": "1",
  //     }
  //   );
  //   print(response.body);
  // }
  Future<void> postData() async {
    final url = Uri.parse('http://192.168.0.105/api/v1/custom=4&cmd=4001');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'ssid': 'Efty @ SF Networking', 'pass': '01723089'});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('POST request successful');
        print(response.body);
      } else {
        print('Error during POST request: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during POST request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CAMERA"),
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.redAccent,
          onPressed: () async{
            print("POSTING DATA CHECK");
            await postData();
          },
          child: Text(
            "post",
            style: TextStyle(color:Colors.white70),
          ),
        ),
      ),

    );
  }
  
}