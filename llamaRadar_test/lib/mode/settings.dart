import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaradar/mode/dash_cam.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:xml/xml.dart' as xml;
import 'package:shared_preferences/shared_preferences.dart';


class DashSettings extends StatefulWidget {
  @override
  _DashSettingsState createState() => _DashSettingsState();
}



class _DashSettingsState extends State<DashSettings> {
  Map<String, bool> settings = {};

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

  @override
  void initState() {
    super.initState();
    startContinuousFunction();
    batteryChecker();
    ssidAndPassChecker();
    currentModeChecker();
    loadSettings();

  }

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


  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      setval1 = prefs.getBool('setval1') ?? false;
      setval2 = prefs.getBool('setval2') ?? false;
      setval3 = prefs.getBool('setval3') ?? false;
      setval4 = prefs.getBool('setval4') ?? false;
      setval5 = prefs.getBool('setval5') ?? false;
      setval6 = prefs.getBool('setval6') ?? false;
      setval7 = prefs.getBool('setval7') ?? false;
      setval8 = prefs.getBool('setval8') ?? false;

    });
  }


  Future<void> addBoolToSF(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }


  onChangeFunction1(bool newValue1) {
    autoPowerOff();
    setState(() {
      setval1 = newValue1;
      addBoolToSF('setval1',newValue1);
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
      addBoolToSF('setval2',newValue2);

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
      addBoolToSF('setval3',newValue3);

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
      addBoolToSF('setval4',newValue4);

    });
  }

  onChangeFunction5(bool newValue5) {
    gSensorSens();
    setState(() {
      setval5 = newValue5;
      addBoolToSF('setval5',newValue5);

    });
  }

  onChangeFunction6(bool newValue6) {
    exposureChange();

    setState(() {
      setval6 = newValue6;
      addBoolToSF('setval6',newValue6);

    });
  }

  onChangeFunction7(bool newValue7) {
    dashCamReset();

    setState(() {
      setval7 = newValue7;
      addBoolToSF('setval7',newValue7);

    });
  }

  onChangeFunction8(bool newValue8) {
    dashCamReset();

    setState(() {
      setval8 = newValue8;
      addBoolToSF('setval8',newValue8);

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

            SizedBox(height: 10),
            Divider(height: 20, thickness: 1),

            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20.0),
              ),
              onPressed: () {
                dashCamReset();
              },
              child: const Text('System Reset'),
            ),
            Divider(height: 20, thickness: 1),

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
