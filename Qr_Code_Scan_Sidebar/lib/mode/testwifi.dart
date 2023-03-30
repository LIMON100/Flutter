import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/CheckWifiInfo.dart';
import 'package:lamaApp/llama_web_menu.dart';
import 'package:lamaApp/Models/model.dart';

class TestWifi extends StatefulWidget {
  const TestWifi({Key? key}) : super(key: key);

  @override
  _TestWifiState createState() => _TestWifiState();
}

class _TestWifiState extends State<TestWifi> {

  final _formKey = GlobalKey<FormState>();
  final ssidController = TextEditingController();
  final passController = TextEditingController();
  final responseData = '';

  String _ssid = '';
  String _password = '';
  Model model = Model();

  Future<CheckWifiInfo> getProductApi () async{
    final response = await http.get(Uri.parse('http://192.168.0.106/api/v1/wifi/settings'));
    var data = jsonDecode(response.body.toString());


    if (response.statusCode == 200){
      return CheckWifiInfo.fromJson(data);
    }else{
      return CheckWifiInfo.fromJson(data);
    }
  }

  Future<void> submitForm() async {
    final url = Uri.parse('http://192.168.0.106/api/v1/custom=4&cmd=4001');
    final response = await http.post(url, body: {
      'ssid': ssidController.text,
      'password': passController.text,
    });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // do something with responseData
    } else {
      // handle error
    }
  }

  Future<String> send() async {
    model = Model(ssid: ssidController.text, pass: passController.text);
    final url = Uri.parse('http://192.168.0.109/api/v1/custom=4&cmd=4001');
    final response = await http.post(url, body: json.encode(model.toJson()));
    print(response.body);

    final decodedJson = jsonDecode(response.body);
    final ssid = decodedJson['request']['ssid'];
    final password = decodedJson['request']['pass'];

    setState(() {
      _ssid = ssid;
      _password = password;
    });

    return response.body;
  }

  @override
  void dispose() {
    ssidController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responseData = '';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('WiFi'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8.0),
            Container(
              width: 200,
              height: 50,
              child: TextField(
                controller: ssidController,
                decoration: InputDecoration(
                  labelText: "SSID",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: 200,
              height: 50,
              child: TextField(
                controller: passController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Button for send ssid and password
            Column(
                children:[
                  SizedBox(height: 1.0),
                  ElevatedButton(
                    onPressed: send,
                    child: Text("Send"),
                    // color: Colors.teal,
                  ),
                  // ElevatedButton(
                  //   child: Text('Send'),
                  //   onPressed: () async {
                  //     // Define the POST request body
                  //     final postData = {
                  //       "ssid": ssidController.text,
                  //       "pass": passController.text
                  //     };
                  //
                  //     // Encode the request body as JSON
                  //     final jsonBody = jsonEncode(postData);
                  //     print(jsonBody);
                  //
                  //     // Make the POST request
                  //     final response = await http.post(
                  //       Uri.parse('http://192.168.0.106/api/v1/custom=4&cmd=4001'),
                  //       headers: {
                  //         'Content-Type': 'application/json',
                  //       },
                  //       body: jsonBody,
                  //     );
                  //
                  //     // Decode the response JSON
                  //     final responseData = jsonDecode(response.body);
                  //     print("response Data ..............");
                  //     print(responseData["request"]["pass"]);
                  //
                  //     // Build the output JSON
                  //     final outputData = {
                  //       "funtion": [
                  //         {
                  //           "cmd": 4001,
                  //           "status": 0
                  //         }
                  //       ],
                  //       "request": postData
                  //     };
                  //     // Encode the output JSON as a string
                  //     final outputJson = jsonEncode(outputData);
                  //
                  //   },
                  // ),
                  SizedBox(height: 0.0),
                  DataTable(
                        border: TableBorder.symmetric(),
                        columns: [
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text("ssid")),
                              DataCell(
                                Container(
                                  width: 1,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.black45,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(_ssid)),
                            ],
                            color: MaterialStateProperty.all<Color>(Colors.black12), // set the background color to yellow
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("pass")),
                              DataCell(
                                Container(
                                  width: 1,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.black45,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(_password)),
                            ],
                            color: MaterialStateProperty.all<Color>(Colors.black12),
                          ),
                        ]
                    ),
                ],
              ),

            // Dhcp status
            SizedBox(height: 15.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    height: 65,
                    child: ElevatedButton(
                      child: Text('DHCP'),
                      onPressed: () async {
                        // Define the POST request body
                        final postData = {
                          "ssid": ssidController.text,
                          "pass": passController.text
                        };

                        // Encode the request body as JSON
                        final jsonBody = jsonEncode(postData);
                        print(jsonBody);

                        // Make the POST request
                        final response = await http.post(
                          Uri.parse('http://192.168.0.106/api/v1/custom=4&cmd=4001'),
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: jsonBody,
                        );

                        // Decode the response JSON
                        final responseData = jsonDecode(response.body);
                        print("response Data ..............");
                        print(responseData["request"]["pass"]);

                        // Build the output JSON
                        final outputData = {
                          "funtion": [
                            {
                              "cmd": 4001,
                              "status": 0
                            }
                          ],
                          "request": postData
                        };
                        // Encode the output JSON as a string
                        final outputJson = jsonEncode(outputData);

                      },
                    ),
                  ),
                  Container(
                    width: 150,
                    child: TextField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: "status",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

            // 6 row for value input
            SizedBox(height: 10.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child: TextField(
                      controller: ssidController,
                      decoration: InputDecoration(
                        labelText: "dhcp",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                      width: 100,
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        controller: passController,
                        decoration: InputDecoration(
                          labelText: "ip",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: TextField(
                        controller: ssidController,
                        decoration: InputDecoration(
                          labelText: "gw",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        controller: passController,
                        decoration: InputDecoration(
                          labelText: "mask",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: TextField(
                        controller: ssidController,
                        decoration: InputDecoration(
                          labelText: "dns1",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: TextField(
                        controller: passController,
                        decoration: InputDecoration(
                          labelText: "dns2",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            ElevatedButton(
              child: Text('Send'),
              onPressed: () async {
                // Define the POST request body
                final postData = {
                  "ssid": ssidController.text,
                  "pass": passController.text
                };

                // Encode the request body as JSON
                final jsonBody = jsonEncode(postData);
                print(jsonBody);

                // Make the POST request
                final response = await http.post(
                  Uri.parse('http://192.168.0.106/api/v1/custom=4&cmd=4001'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonBody,
                );

                // Decode the response JSON
                final responseData = jsonDecode(response.body);
                print("response Data ..............");
                print(responseData["request"]["pass"]);

                // Build the output JSON
                final outputData = {
                  "funtion": [
                    {
                      "cmd": 4001,
                      "status": 0
                    }
                  ],
                  "request": postData
                };
                // Encode the output JSON as a string
                final outputJson = jsonEncode(outputData);
              },
            ),

            // Display dhcp, ip, mask, dns
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dhcp')),
                  DataColumn(label: Text('ip')),
                  DataColumn(label: Text('gw')),
                  DataColumn(label: Text('mask')),
                  DataColumn(label: Text('dns1')),
                  DataColumn(label: Text('dns2')),

                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('xxx.xxx.xxx.xxx')),
                    DataCell(Text('xxx.xxx.xxx.xxx')),
                    DataCell(Text('xxx.xxx.xxx.xxx')),
                    DataCell(Text('xxx.xxx.xxx.xxx')),
                    DataCell(Text('xxx.xxx.xxx.xxx')),
                    DataCell(Text('xxx.xxx.xxx.xxx')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
















//
// Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children:[
// SizedBox(height: 1.0),
// ElevatedButton(
// child: Text('Send'),
// onPressed: () async {
// // Define the POST request body
// final postData = {
// "ssid": ssidController.text,
// "pass": passController.text
// };
//
// // Encode the request body as JSON
// final jsonBody = jsonEncode(postData);
// print(jsonBody);
//
// // Make the POST request
// final response = await http.post(
// Uri.parse('http://192.168.0.106/api/v1/custom=4&cmd=4001'),
// headers: {
// 'Content-Type': 'application/json',
// },
// body: jsonBody,
// );
//
// // Decode the response JSON
// final responseData = jsonDecode(response.body);
// print("response Data ..............");
// print(responseData["request"]["pass"]);
//
// // Build the output JSON
// final outputData = {
// "funtion": [
// {
// "cmd": 4001,
// "status": 0
// }
// ],
// "request": postData
// };
// // Encode the output JSON as a string
// final outputJson = jsonEncode(outputData);
//
// },
// ),
// SizedBox(height: 0.0),
// Center(
// child: DataTable(
// border: TableBorder.symmetric(),
// columns: [
// DataColumn(label: Text('')),
// DataColumn(label: Text('')),
// DataColumn(label: Text('')),
// ],
// rows: [
// DataRow(
// cells: [
// DataCell(Text("ssid")),
// DataCell(
// Container(
// width: 1,
// height: double.infinity,
// decoration: BoxDecoration(
// border: Border(
// left: BorderSide(
// color: Colors.black45,
// width: 1,
// ),
// ),
// ),
// ),
// ),
// DataCell(Text(ssidController.text)),
// ],
// color: MaterialStateProperty.all<Color>(Colors.black12), // set the background color to yellow
// ),
// DataRow(
// cells: [
// DataCell(Text("pass")),
// DataCell(
// Container(
// width: 1,
// height: double.infinity,
// decoration: BoxDecoration(
// border: Border(
// left: BorderSide(
// color: Colors.black45,
// width: 1,
// ),
// ),
// ),
// ),
// ),
// DataCell(Text(passController.text)),
// ],
// color: MaterialStateProperty.all<Color>(Colors.black12),
// ),
// ]
// ),
// ),
// ],
// ),
// ),