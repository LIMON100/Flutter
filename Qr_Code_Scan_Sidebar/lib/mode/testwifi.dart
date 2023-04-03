<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/CheckWifiInfo.dart';
import 'package:lamaApp/llama_web_menu.dart';
import 'package:lamaApp/Models/model.dart';
import 'package:lamaApp/Models/Checkwifistat.dart';
import 'package:lamaApp/Models/WifiStat.dart';

class TestWifi extends StatefulWidget {
  const TestWifi({Key? key}) : super(key: key);

  @override
  _TestWifiState createState() => _TestWifiState();
}

class _TestWifiState extends State<TestWifi> {

  final _formKey = GlobalKey<FormState>();
  final ssidController = TextEditingController();
  final passController = TextEditingController();
  final dhController = TextEditingController();

  final dhcpController = TextEditingController();
  final ipController = TextEditingController();
  final gwController = TextEditingController();
  final maskController = TextEditingController();
  final dns1Controller = TextEditingController();
  final dns2Controller = TextEditingController();

  final responseData = '';

  String _ssid = '';
  String _password = '';
  String _dhcp = '';
  String _ip = '';
  String _gw = '';
  String _mask = '';
  String _dns1 = '';
  String _dns2 = '';

  Model model = Model();
  Checkwifistat wifiStatic = Checkwifistat();

  // For wifistatic
  Future<String> send2() async {
    wifiStatic = Checkwifistat(dhcp: dhcpController.text, ip: ipController.text, gw: gwController.text, mask: maskController.text, dns1: dns1Controller.text, dns2: dns2Controller.text,);
    final url = Uri.parse('http://192.168.0.105/api/v1/custom=4&cmd=4002');
    final response = await http.post(url, body: json.encode(wifiStatic.toJson()));
    print(response.body);

    final decodedJson = jsonDecode(response.body);

    final dhcp = decodedJson['request']['dhcp'];
    final ip = decodedJson['request']['ip'];
    final gw = decodedJson['request']['gw'];
    final mask = decodedJson['request']['mask'];
    final dns1 = decodedJson['request']['dns1'];
    final dns2 = decodedJson['request']['dns2'];

    setState(() {
      _dhcp = dhcp;
      _ip = ip;
      _gw = gw;
      _mask = mask;
      _dns1 = dns1;
      _dns2 = dns2;
    });

    return response.body;
  }



  // for ssid and password
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
          title: Text('WiFi'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF2580B3),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                Container(
                  width: 200,
                  height: 50,
                  child: TextField(
                    controller: ssidController,
                    decoration: InputDecoration(
                      // labelText: "SSID",
                      hintText: "SSID",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
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
                      hintText: "PASSWORD",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
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
                              "dhcp": dhController.text,
                            };

                            // Encode the request body as JSON
                            final jsonBody = jsonEncode(postData);
                            print(jsonBody);

                            // Make the POST request
                            final response = await http.post(
                              Uri.parse('http://192.168.0.106/api/v1/custom=4&cmd=4002'),
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
                          controller: dhController,
                          decoration: InputDecoration(
                            labelText: "1",
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
                          controller: dhcpController,
                          decoration: InputDecoration(
                            hintText: "dhcp",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                          width: 100,
                          margin: EdgeInsets.all(8),
                          child: TextField(
                            controller: ipController,
                            decoration: InputDecoration(
                              hintText: "ip",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: TextField(
                            controller: gwController,
                            decoration: InputDecoration(
                              hintText: "gw",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.all(8),
                          child: TextField(
                            controller: maskController,
                            decoration: InputDecoration(
                              hintText: "mask",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            controller: dns1Controller,
                            decoration: InputDecoration(
                              hintText: "dns1",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            controller: dns2Controller,
                            decoration: InputDecoration(
                              hintText: "dns2",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: send2,
                  child: Text("Send"),
                  // color: Colors.teal,
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
                        DataCell(Text(_dhcp)),
                        DataCell(Text(_ip)),
                        DataCell(Text(_gw)),
                        DataCell(Text(_mask)),
                        DataCell(Text(_dns1)),
                        DataCell(Text(_dns2)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/CheckWifiInfo.dart';
import 'package:lamaApp/llama_web_menu.dart';
import 'package:lamaApp/Models/model.dart';
import 'package:lamaApp/Models/Checkwifistat.dart';
import 'package:lamaApp/Models/WifiStat.dart';

class TestWifi extends StatefulWidget {
  const TestWifi({Key? key}) : super(key: key);

  @override
  _TestWifiState createState() => _TestWifiState();
}

class _TestWifiState extends State<TestWifi> {

  final _formKey = GlobalKey<FormState>();
  final ssidController = TextEditingController();
  final passController = TextEditingController();
  final dhController = TextEditingController();

  final dhcpController = TextEditingController();
  final ipController = TextEditingController();
  final gwController = TextEditingController();
  final maskController = TextEditingController();
  final dns1Controller = TextEditingController();
  final dns2Controller = TextEditingController();

  final responseData = '';

  String _ssid = '';
  String _password = '';
  String _dhcp = '';
  String _ip = '';
  String _gw = '';
  String _mask = '';
  String _dns1 = '';
  String _dns2 = '';

  Model model = Model();
  Checkwifistat wifiStatic = Checkwifistat();

  // For wifistatic
  Future<String> send2() async {
    wifiStatic = Checkwifistat(dhcp: dhcpController.text, ip: ipController.text, gw: gwController.text, mask: maskController.text, dns1: dns1Controller.text, dns2: dns2Controller.text,);
    final url = Uri.parse('http://192.168.0.105/api/v1/custom=4&cmd=4002');
    final response = await http.post(url, body: json.encode(wifiStatic.toJson()));
    print(response.body);

    final decodedJson = jsonDecode(response.body);

    final dhcp = decodedJson['request']['dhcp'];
    final ip = decodedJson['request']['ip'];
    final gw = decodedJson['request']['gw'];
    final mask = decodedJson['request']['mask'];
    final dns1 = decodedJson['request']['dns1'];
    final dns2 = decodedJson['request']['dns2'];

    setState(() {
      _dhcp = dhcp;
      _ip = ip;
      _gw = gw;
      _mask = mask;
      _dns1 = dns1;
      _dns2 = dns2;
    });

    return response.body;
  }



  // for ssid and password
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
        child: ListView(
          children: [
            Column(
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
                        controller: dhController,
                        decoration: InputDecoration(
                          labelText: "1",
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
                        controller: dhcpController,
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
                          controller: ipController,
                          decoration: InputDecoration(
                            labelText: "ip",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: TextField(
                          controller: gwController,
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
                          controller: maskController,
                          decoration: InputDecoration(
                            labelText: "mask",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: TextField(
                          controller: dns1Controller,
                          decoration: InputDecoration(
                            labelText: "dns1",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: TextField(
                          controller: dns2Controller,
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
                onPressed: send2,
                child: Text("Send"),
                // color: Colors.teal,
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
                      DataCell(Text(_dhcp)),
                      DataCell(Text(_ip)),
                      DataCell(Text(_gw)),
                      DataCell(Text(_mask)),
                      DataCell(Text(_dns1)),
                      DataCell(Text(_dns2)),
                    ]),
                  ],
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
>>>>>>> a8776f8116c317b8a4629530ef06c600a63434ce
