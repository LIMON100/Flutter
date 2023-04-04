import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/CheckWifiInfo.dart';
import 'package:lamaApp/llama_web_menu.dart';

class WifiInfo extends StatefulWidget {

  const WifiInfo({Key? key}) : super(key: key);

  @override
  _WifiInfoState createState() => _WifiInfoState();
}

class _WifiInfoState extends State<WifiInfo> {

  // List<CheckVersion> postList = [];
  Future<CheckWifiInfo> getProductApi () async{

    final response = await http.get(Uri.parse('http://192.168.0.109/api/v1/wifi/settings'));
    var data = jsonDecode(response.body.toString());


    if (response.statusCode == 200){
      return CheckWifiInfo.fromJson(data);
    }else{
      return CheckWifiInfo.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LlamaWebMenu(),
                ),
              );
            },
          ),
          centerTitle: true,
          title: Text('WIFI information'),
        ),
        body: Column(
          children: [
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
                            DataCell(Text(snapshot.data!.ssid.toString())),
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
                            DataCell(Text(snapshot.data!.pass.toString())),
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
          ]
        ));
  }
}


