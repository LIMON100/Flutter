import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaradar/mode/dash_cam.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:xml/xml.dart' as xml;


class DashSettings extends StatefulWidget {
  @override
  _DashSettingsState createState() => _DashSettingsState();
}



class _DashSettingsState extends State<DashSettings> {

  @override
  void initState() {
    super.initState();
    startContinuousFunction();
    batteryChecker();
    ssidAndPassChecker();
    currentModeChecker();
  }

  bool isFront = false;
  bool isSensor = false;
  bool isAutoOn = false;
  bool isExposure = false;
  bool setval1 = false;
  bool setval2 = false;
  bool setval3 = false;
  bool setval4 = false;
  bool setval5 = false;
  bool setval6 = false;
  bool setval7 = false;
  bool setval8 = false;
  String firmVer = '';
  String batteryLevel='';
  String ssidVal ='';
  String passVal ='';
  String modeVal ='';
  void startContinuousFunction() {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final response = await http.get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3012'));

      if (response.statusCode == 200) {
        String result = response.body;
        final document = xml.XmlDocument.parse(result);
        final newFirmVer = document.findAllElements('String').first.text;
        setState(() {
          firmVer = newFirmVer;
        });
      }

    });
  }

  void batteryChecker() {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final response = await http.get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3019'));

      if(response.statusCode == 200){
        String result = response.body;
        final document = xml.XmlDocument.parse(result);
        final newbatteryLevel = document.findAllElements('Value').first.text;
        setState(() {
          batteryLevel = newbatteryLevel;
        });
      }

    });
  }

  void ssidAndPassChecker() {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final response = await http.get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3029'));

      if(response.statusCode == 200){
        String result = response.body;
        final document = xml.XmlDocument.parse(result);
        final newSSIDVAL = document.findAllElements('SSID').first.text;
        final newPASSVAL = document.findAllElements('PASSPHRASE').first.text;

        setState(() {
          ssidVal = newSSIDVAL;
          passVal = newPASSVAL;
        });
      }

    });
  }


  void currentModeChecker() {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      final response = await http.get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3037'));

      if(response.statusCode == 200){
        String result = response.body;
        final document = xml.XmlDocument.parse(result);
        final newModeVal = document.findAllElements('Value').first.text;
        setState(() {
          if (newModeVal=="0"){
            modeVal ="preview start";

          }else if(newModeVal=="1"){
            modeVal ="Recording";

          }else if(newModeVal=="2"){
            modeVal ="preview stop";

          }else if(newModeVal=="3"){
            modeVal ="Playback mode";

          }else if(newModeVal=="4"){
            modeVal ="Photo Mode";

          }else{
            modeVal ="None";

          }
        });
      }

    });
  }


  Future<void> camFront() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3028&par=2'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('Cam changed');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  Future<void> camBehind() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3028&par=3'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('Cam changed');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  Future<void> dashCamReset() async {
    final response =
    await http.get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3011'));
    if (response.statusCode == 200) {
      print('Restore factory settings');
    } else {
      print('System reset Error: ${response.statusCode}');
    }
  }
  Future<void> gSensorSens() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2011&par=2'));
    if (response.statusCode == 200) {
      print('sensor activated');
    } else {
      print('G sensor Error: ${response.statusCode}');
    }
  }


  Future<void> autoPowerOff() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3007&par=1'));
    if (response.statusCode == 200) {
      print('Auto Power is on');
    } else {
      print('Auto Power Error: ${response.statusCode}');
    }
  }

  Future<void> exposureChange() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2005&par=6'));
    if (response.statusCode == 200) {
      print('Exposure on');
    } else {
      print('Exposure Error: ${response.statusCode}');
    }
  }

  Future<void> changeSSID(String ssid) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3003&str=$ssid'));
    if (response.statusCode == 200) {
      print('SSID Changed to $ssid');
    } else {
      print('SSID SET Error: ${response.statusCode}');
    }
  }

  Future<void> changePASS(String pass) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3004&str=$pass'));
    if (response.statusCode == 200) {
      print('Pass Changed to $pass');
    } else {
      print('Password SET Error: ${response.statusCode}');
    }
  }

  Future<void> dateStamp(String param) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2008&par=$param'));
    if (response.statusCode == 200) {
      print('Date stamp changed $param');
    } else {
      print('Date stamp Error: ${response.statusCode}');
    }
  }
  Future<void> autoRecording(String param) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2012&par=$param'));
    if (response.statusCode == 200) {
      print('Auto recording changed to $param');
    } else {
      print('Auto recording  Error: ${response.statusCode}');
    }
  }


  // Future<String> pullFirmware() async {
  //   final response = await http.get(Uri.parse('http://192.168.1.254/?custom=1&cmd=3012'));
  //   if (response.statusCode == 200) {
  //     print('Auto recording changed to ');
  //     final xmlDoc = xml.XmlDocument.parse(response.body);
  //     print(xmlDoc);
  //     return "Firm";
  // final fileElements = xmlDoc.findAllElements('File');
  //   } else {
  //     return "";
  //     print('Auto recording  Error: ${response.statusCode}');
  //   }
  // }

  // Future<String> pullFirmware() async {
  //   var url = Uri.parse("http://192.168.1.254/?custom=1&cmd=3012");
  //   var response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception('Firmware error.');
  //   }
  // }
  onChangeFunction1(bool newValue1) {
    autoPowerOff();
    setState(() {
      setval1 = newValue1;
    });
  }

  onChangeFunction2(bool newValue2) {
    if (newValue2 != true) {
      dateStamp("1");
    } else {
      dateStamp("0");
    }
    setState(() {
      setval2 = newValue2;
    });
  }

  onChangeFunction3(bool newValue3) {
    if (newValue3 != true) {
      autoRecording("1");
    } else {
      autoRecording("0");
    }
    setState(() {
      setval3 = newValue3;
    });
  }

  onChangeFunction4(bool newValue4) {
    if (newValue4 != true) {
      camBehind();
    } else {
      camFront();
    }
    setState(() {
      setval4 = newValue4;
    });
  }

  onChangeFunction5(bool newValue5) {
    gSensorSens();
    setState(() {
      setval5 = newValue5;
    });
  }

  onChangeFunction6(bool newValue6) {
    exposureChange();

    setState(() {
      setval6 = newValue6;
    });
  }

  onChangeFunction7(bool newValue7) {
    dashCamReset();

    setState(() {
      setval7 = newValue7;
    });
  }

  onChangeFunction8(bool newValue8) {
    dashCamReset();

    setState(() {
      setval8 = newValue8;
    });
  }

  TextEditingController ssidController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('LLama'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xFF2580B3),
          ),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.camera,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text("Settings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ],
            ),
            Divider(height: 10, thickness: 1),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: TextField(
                    controller: ssidController,
                    decoration: InputDecoration(
                      labelText: 'SSID: $ssidVal',
                    ),
                  ),
                ),
                SizedBox(height: 1),
                Container(
                  child: ElevatedButton(
                    child: Text('Change SSID'),
                    onPressed: () {
                      String ssid = ssidController.text.trim();
                      changeSSID(ssid);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: TextField(

                    controller: passController,
                    decoration: InputDecoration(
                      labelText: 'Pass: $passVal',
                    ),
                  ),
                ),
                SizedBox(height: 1),
                Container(
                  child: ElevatedButton(
                    child: Text('Change WiFi Pass'),
                    onPressed: () {
                      String pass = passController.text.trim();
                      changePASS(pass);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 1),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Firmware :  $firmVer",
                      //labelText: firmVer,

                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 1),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Battery Level:   $batteryLevel",
                      //labelText: firmVer,

                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 1),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Current Mode:   $modeVal",
                      //labelText: firmVer,

                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 2),


            // Column(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         startContinuousFunction();
            //       },
            //       child: Text('Check data Test'),
            //     ),
            //     // Diğer widget'lar
            //   ],
            // ),
            // SizedBox(height: 10),
            // buildAccountOption(context, "Change WIFI Name"),
            // buildAccountOption(context, "Change WIFI Password"),
            // buildAccountOption(context, "Firmware Version"),
            SizedBox(height: 10),
            Row(
              children: [

                Icon(Icons.camera_alt, color: Colors.blue),
                SizedBox(width: 10),
                Text("Other Settings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            buildOtherSettings("Auto Power Off", setval1, onChangeFunction1),
            buildOtherSettings("Date Stamp", setval2, onChangeFunction2),
            buildOtherSettings("Auto Recording ", setval3, onChangeFunction3),
            buildOtherSettings("Change Camera ", setval4, onChangeFunction4),
            buildOtherSettings("G Sensor ", setval5, onChangeFunction5),
            buildOtherSettings("Exposure ", setval6, onChangeFunction6),
            buildOtherSettings("System Reset ", setval7, onChangeFunction7),
            //buildOtherSettings("Auto Recording ", setval8, onChangeFunction8),
            SizedBox(height: 10),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),


      //second body
      // body: Column(
      //   children: [
      //     SizedBox(height: 60),
      //     SizedBox(height: 5),
      //     Container(
      //       width: 350,
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //
      //
      //             SizedBox(height: 10),
      //             CircleButton(
      //               onPressed: () async {
      //                 if (isFront) {
      //                   camBehind();
      //                 } else {
      //                   camFront();
      //                 }
      //                 setState(() {
      //                   isFront = !isFront;
      //                 });
      //               },
      //               color: isFront ? Color(0xFF517fa4) : Colors.deepPurpleAccent,
      //               text: isFront ? 'Front Camera' : 'Back Camera',
      //             ),
      //             SizedBox(height: 10),
      //             CircleButton(
      //               onPressed: () async {
      //                 if (isSensor) {
      //                   gSensorSens();
      //                 } else {
      //                   gSensorSens();
      //                 }
      //                 setState(() {
      //                   isSensor = !isSensor;
      //                 });
      //               },
      //               color: isSensor ? Color(0xFF517fa4) : Colors.deepPurpleAccent,
      //               text: isSensor ? 'G Sensor sensitivity' : ' g sensor off',
      //             ),
      //             SizedBox(height: 10),
      //             CircleButton(
      //               onPressed: () async {
      //                 if (isAutoOn) {
      //                   autoPowerOff();
      //                 } else {
      //                   autoPowerOff();
      //                 }
      //                 setState(() {
      //                   isAutoOn = !isAutoOn;
      //                 });
      //               },
      //               color: isAutoOn ? Color(0xFF517fa4) : Colors.deepPurpleAccent,
      //               text: isAutoOn ? 'Auto Power Off' : ' Auto Power On',
      //             ),
      //
      //             SizedBox(height: 10),
      //
      //             CircleButton(
      //               onPressed: () async {
      //                 if (isExposure) {
      //                   exposureChange();
      //                 } else {
      //                   exposureChange();
      //                 }
      //                 setState(() {
      //                   isExposure = !isExposure;
      //                 });
      //               },
      //               color: isExposure ? Color(0xFF517fa4) : Colors.deepPurpleAccent,
      //               text: isExposure ? 'Exposure Off' : ' Exposure On +6',
      //             ),
      //
      //             SizedBox(height: 10),
      //
      //             CircleButton(
      //               onPressed: () async {
      //                 dashCamReset();
      //
      //               },
      //               color:Colors.deepPurpleAccent ,
      //               text: 'Restore factory settings',
      //             ),
      //             SizedBox(height: 10),
      //           ],
      //
      //     ),
      //     ),
      //   ],
      // ),
    );
  }

  Padding buildOtherSettings(
      String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600])),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Will be Added"), Text("Will be Added")],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close"))
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600])),
            Icon(Icons.arrow_forward_ios, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}
