import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/SystemsInfo.dart';
import 'package:lamaApp/llama_web_menu.dart';

class SystemInfo extends StatefulWidget {

  const SystemInfo({Key? key}) : super(key: key);

  @override
  _SystemInfoState createState() => _SystemInfoState();
}

class _SystemInfoState extends State<SystemInfo> {

  Future<SystemsInfo> getProductApi () async{

    final response = await http.get(Uri.parse('http://192.168.0.115/api/v1/system/info'));
    var data = jsonDecode(response.body.toString());


    if (response.statusCode == 200){
      return SystemsInfo.fromJson(data);
    }else{
      return SystemsInfo.fromJson(data);
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
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: Text('Device information'),
        ),
        body: Center(
          child: FutureBuilder<SystemsInfo>(
            future: getProductApi(),
            builder: (context, snapshot) {
            if (snapshot.hasData) {
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
                      DataCell(Text("fw")),
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
                      DataCell(Text(snapshot.data!.fw.toString())),
                    ],
                    color: MaterialStateProperty.all<Color>(Colors.black12), // set the background color to yellow
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("hw")),
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
                      DataCell(Text(snapshot.data!.hw.toString())),
                    ],
                    color: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("dt")),
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
                      DataCell(Text(snapshot.data!.dt.toString())),
                    ],
                    color: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("mac")),
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
                      DataCell(Text(snapshot.data!.mac.toString())),
                    ],
                    color: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("rssi")),
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
                      DataCell(Text(snapshot.data!.rssi.toString())),
                    ],
                    color: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("ram")),
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
                      DataCell(Text(snapshot.data!.ram.toString())),
                    ],
                    color: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("flash")),
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
                      DataCell(Text(snapshot.data!.flash.toString())),
                    ],
                    color: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("temp")),
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
                      DataCell(Text(snapshot.data!.temp.toString())),
                    ],
                    color: MaterialStateProperty.all<Color>(Colors.black12),
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text("time_up")),
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
                      DataCell(Text(snapshot.data!.timeUp.toString())),
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
             }
          ),
        ),
    );
  }
}
