import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaAppR/Models/SystemsInfo.dart';
import 'package:lamaAppR/Models/VersionInfo.dart';
import 'package:lamaAppR/Models/RestartInfo.dart';
import 'package:lamaAppR/llama_web_menu.dart';

class SystemInfo extends StatefulWidget {

  const SystemInfo({Key? key}) : super(key: key);

  @override
  _SystemInfoState createState() => _SystemInfoState();
}

class _SystemInfoState extends State<SystemInfo> {

  final _formKey = GlobalKey<FormState>();
  final devRestart = TextEditingController();

  //System Info
  Future<SystemsInfo> getProductApi () async{

    final response = await http.get(Uri.parse('http://192.168.0.104/api/v1/system/info'));
    var data = jsonDecode(response.body.toString());


    if (response.statusCode == 200){
      return SystemsInfo.fromJson(data);
    }else{
      return SystemsInfo.fromJson(data);
    }
  }


  //Restart check
  Future<RestartInfo> getRestartInfoApi() async {
    final response = await http.get(Uri.parse('http://192.168.0.104/api/v1/custom=3&cmd=3001'));
    if (response.statusCode == 200) {
      return RestartInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Test combine api
  Future<VersionInfo> getDeviceApi(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return VersionInfo.fromJson(json);
    } else {
      throw Exception('Failed to fetch API response');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color shadowColor = Colors.blueGrey;
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
            flexibleSpace: Container(
              decoration: BoxDecoration(
                // color: Color(0xFF6497d3),
                color: Color(0xFF2580B3),
              ),
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15.0),

                //Device Restart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 115.0),
                    Container(
                      // width: 150,
                      // height: 65,
                      child:
                      Text('Device Restart',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            shadows: [
                              for (double i = 1; i < 10; i++)
                                Shadow(
                                  color: shadowColor,
                                  blurRadius: 3 * i,
                                )
                            ]
                        ),),
                    ),

                    Center(
                      child: FutureBuilder<RestartInfo>(
                        future: getRestartInfoApi(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final request = snapshot.data!.request;
                            TextEditingController controller = TextEditingController(
                              text: '${request.restartCounter}',
                            );
                            return SizedBox(
                              width: 105,
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: '',
                                  border: OutlineInputBorder(),
                                ),
                                controller: controller,
                                enabled: false,
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    )
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  "Version Info",
                  style: TextStyle(fontSize: 25),),

                // Version
                Container(
                  margin: EdgeInsets.zero,
                  child: Center(
                    child: FutureBuilder<VersionInfo>(
                      future: getDeviceApi('http://192.168.0.104/api/v1/custom=3&cmd=3002'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final request = snapshot.data!.request;
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
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
                                    DataCell(Text('Firmware Version')),
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
                                    DataCell(Text(request.reselase)),
                                  ],
                                  color: MaterialStateProperty.all<Color>(Colors.black12),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.zero,
                  child: Center(
                    child: FutureBuilder<VersionInfo>(
                      future: getDeviceApi('http://192.168.0.104/api/v1/custom=3&cmd=3003'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final request = snapshot.data!.request;
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
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
                                    DataCell(Text('App Version')),
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
                                    DataCell(Text(request.reselase)),
                                  ],
                                  color: MaterialStateProperty.all<Color>(Colors.black12),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),

                Center(
                  child: FutureBuilder<VersionInfo>(
                    future: getDeviceApi('http://192.168.0.104/api/v1/custom=3&cmd=3004'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final request = snapshot.data!.request;
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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
                                  DataCell(Text('Esp Version')),
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
                                  DataCell(Text(request.reselase)),
                                ],
                                color: MaterialStateProperty.all<Color>(Colors.black12),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),

                // System info
                SizedBox(height: 40.0),
                Text(
                  "System Info",
                  style: TextStyle(fontSize: 25),),
                SizedBox(height: 1.0),

                Center(
                child: FutureBuilder<SystemsInfo>(
                  future: getProductApi(),
                  builder: (context, snapshot) {
                  if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
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
                        ),
                      );
                      } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                      }
                      // By default, show a loading spinner
                      return CircularProgressIndicator();
                   }
                ),
              ),
            ]
            ),
          ),
      ),
    );
  }
}
