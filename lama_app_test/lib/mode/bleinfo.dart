import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/model.dart';
import 'dart:convert';
import 'package:lamaApp/mode/testmode.dart';
import 'package:lamaApp/temp/animatedbutton.dart';
import 'package:lamaApp/temp/glowing_button.dart';
import 'package:lamaApp/Models/DhcpInfo.dart';
import 'package:lamaApp/temp/glowing_button2.dart';

class BleInfo extends StatefulWidget {

  const BleInfo({Key? key}) : super(key: key);

  @override
  _BleInfoState createState() => _BleInfoState();
}

class _BleInfoState extends State<BleInfo> {
  final dhcpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DhcpInfo dhcpinfo = DhcpInfo();

  int _dhcp = 0;

  Future<String> send() async {
    dhcpinfo = DhcpInfo(dhcp: int.parse(dhcpController.text));
    final url = Uri.parse('http://192.168.0.105/api/v1/custom=4&cmd=4002');
    final response = await http.post(url, body: json.encode(dhcpinfo.toJson()));
    print(response.body);

    final decodedJson = jsonDecode(response.body);
    final dhcp = decodedJson['request']['dhcp'];

    setState(() {
      _dhcp = dhcp;
    });

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch DHCP Value'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Container(
              width: 200,
              height: 50,
              child: TextField(
                controller: dhcpController,
                decoration: InputDecoration(
                  // labelText: "SSID",
                  hintText: "dhcp",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0,bottom: 0.5),
              child: GlowingButton2(
                text: "Send",
                onPressed: send,
                color1: Colors.blueAccent,
                color2: Colors.indigo,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 1.0,bottom: 5.0),
              child: Column(
                children:[
                  SizedBox(height: 7.0),
                  // ElevatedButton(
                  //   onPressed: send,
                  //   child: Text("Send"),
                  //   // color: Colors.teal,
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
                            DataCell(Text("dhcp")),
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
                            DataCell(Text(_dhcp.toString())),
                          ],
                          color: MaterialStateProperty.all<Color>(Colors.black12), // set the background color to yellow
                        ),
                  ],),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
