import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaAppR/Models/model.dart';
import 'package:lamaAppR/Models/Checkwifistat.dart';
import 'package:lamaAppR/temp/glowing_button2.dart';
import 'package:lamaAppR/Models/DhcpInfo.dart';
import 'package:lamaAppR/temp/customtextfield.dart';

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
    final url = Uri.parse('http://192.168.0.104/api/v1/custom=4&cmd=4002');
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
    final url = Uri.parse('http://192.168.0.104/api/v1/custom=4&cmd=4001');
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

  // For dhcp
  DhcpInfo dhcpinfo = DhcpInfo();
  int _dhcp2 = 0;

  Future<String> getDhcpApi() async {
    dhcpinfo = DhcpInfo(dhcp: int.parse(dhController.text));
    final url = Uri.parse('http://192.168.0.104/api/v1/custom=4&cmd=4002');
    final response = await http.post(url, body: json.encode(dhcpinfo.toJson()));
    print(response.body);

    final decodedJson = jsonDecode(response.body);
    final dhcp = decodedJson['request']['dhcp'];

    setState(() {
      _dhcp2 = dhcp;
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      bottom: MediaQuery.of(context).size.height * 0.005),
                  child: GlowingButton2(
                    text: "Send",
                    onPressed: send,
                    color1: Colors.blueAccent,
                    color2: Colors.indigo,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.000009),
                Container(
                  margin: EdgeInsets.only(top: 1.0,bottom: 5.0),
                  child: Column(
                      children:[
                        SizedBox(height: MediaQuery.of(context).size.height * 0.007),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.001),
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
                ),

                // Dhcp status
                SizedBox(height: 35.0),
                Container(
                  margin: EdgeInsets.only(top: 1.0,bottom: 0.9),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          height: 65,
                          child: Container(
                            margin: EdgeInsets.only(top: 15.0,bottom: 0.5),
                            child: GlowingButton2(
                              text: "DHCP",
                              onPressed: getDhcpApi,
                              color1: Colors.blueAccent,
                              color2: Colors.indigo,
                            ),
                          ),
                        ),

                        Container(
                          width: 100,
                          height: 55,
                          child: TextField(
                            controller: dhController,
                            decoration: InputDecoration(
                              labelText: "dhcp",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                Container(
                  margin: EdgeInsets.only(top: 1.0,bottom: 5.0),
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
                            DataCell(Text("DHCP")),
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
                            DataCell(Text(_dhcp2.toString())),
                          ],
                          color: MaterialStateProperty.all<Color>(Colors.black12), // set the background color to yellow
                        ),
                      ]
                  ),
                ),

                // 6 row for value input
                SizedBox(height: 30.0),

                Center(
                  child: CustomTextField(
                    dhcpController: dhcpController,
                    ipController: ipController,
                    gwController: gwController,
                    maskController: maskController,
                    dns1Controller: dns1Controller,
                    dns2Controller: dns2Controller,
                  ),
                ),

                GlowingButton2(
                  text: "Send",
                  onPressed: send2,
                  color1: Colors.blueAccent,
                  color2: Colors.indigo,
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
