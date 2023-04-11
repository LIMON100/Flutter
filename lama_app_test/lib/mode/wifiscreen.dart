import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaAppR/Models/CheckWifiInfo.dart';
import 'package:lamaAppR/llama_web_menu.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({Key? key}) : super(key: key);

  @override
  _WifiScreenState createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {

  final _formKey = GlobalKey<FormState>();
  final ssidController = TextEditingController();
  final passController = TextEditingController();
  final responseData = '';

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
        title: Text('WiFi Info'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            ElevatedButton(
              // onPressed: () {
              //   if (_formKey.currentState!.validate()) {
              //     // Do something with the data
              //     final ssid = ssidController.text;
              //     final password = passController.text;
              //     print('SSID: $ssid, Password: $password');
              //   }
              // },
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

            // Show ssid and pass in table
            Expanded(
              child: Center(
                child: DataTable(
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
                            DataCell(Text(ssidController.text)),
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
                            DataCell(Text(passController.text)),
                          ],
                          color: MaterialStateProperty.all<Color>(Colors.black12),
                        ),
                      ]
                  ),
              ),
            ),

            // 6 row for value input
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  child: TextField(
                    controller: ssidController,
                    decoration: InputDecoration(
                      labelText: "dhcp",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  child: TextField(
                    controller: passController,
                    decoration: InputDecoration(
                      labelText: "ip",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  child: TextField(
                    controller: ssidController,
                    decoration: InputDecoration(
                      labelText: "gw",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                Container(
                  width: 150,
                  child: TextField(
                    controller: passController,
                    decoration: InputDecoration(
                      labelText: "mask",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
