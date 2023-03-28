import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/CheckWifiInfo.dart';
import 'package:lamaApp/llama_web_menu.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({Key? key}) : super(key: key);

  @override
  _WifiScreenState createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  final _formKey = GlobalKey<FormState>();
  final ssidController = TextEditingController();
  final passController = TextEditingController();

  Future<CheckWifiInfo> getProductApi () async{

    final response = await http.get(Uri.parse('http://192.168.0.109/api/v1/wifi/settings'));
    var data = jsonDecode(response.body.toString());


    if (response.statusCode == 200){
      return CheckWifiInfo.fromJson(data);
    }else{
      return CheckWifiInfo.fromJson(data);
    }
  }

  Future<void> submitForm() async {
    final url = Uri.parse('http://192.168.0.109/api/v1/custom=4&cmd=4001');
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('WiFi'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            Container(
              width: 200,
              child: TextField(
                controller: ssidController,
                decoration: InputDecoration(
                  labelText: "SSID",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 200,
              child: TextField(
                controller: passController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Do something with the data
                  final ssid = ssidController.text;
                  final password = passController.text;
                  print('SSID: $ssid, Password: $password');
                }
              },
              child: Text('Submit'),
            ),
            Center(
              child: FutureBuilder<CheckWifiInfo>(
                future: getProductApi(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return DataTable(
                        border: TableBorder.symmetric(

                        ),
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
                          DataRow(
                            cells: [
                              DataCell(Text("ip")),
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
                              DataCell(Text(snapshot.data!.ip.toString())),
                            ],
                            color: MaterialStateProperty.all<Color>(Colors.black12),
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("mask")),
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
                              DataCell(Text(snapshot.data!.mask.toString())),
                            ],
                            color: MaterialStateProperty.all<Color>(Colors.black12),
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("gtw")),
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
                              DataCell(Text(snapshot.data!.gtw.toString())),
                            ],
                            color: MaterialStateProperty.all<Color>(Colors.black12),
                          ),
                        ]
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
