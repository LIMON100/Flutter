import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:lamaAppR/Models/DhcpInfo.dart';
import 'package:lamaAppR/temp/glowing_button2.dart';
import 'package:lamaAppR/temp/customtextfield.dart';
import 'package:lamaAppR/Models/checkwifistat.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:lamaAppR/temp/UploadFilePage.dart';
import 'package:path_provider/path_provider.dart';

class BleInfo extends StatefulWidget {

  const BleInfo({Key? key}) : super(key: key);

  @override
  _BleInfoState createState() => _BleInfoState();
}

class _BleInfoState extends State<BleInfo> with SingleTickerProviderStateMixin{

  // final _formKey = GlobalKey<FormState>();
  // DhcpInfo dhcpinfo = DhcpInfo();
  //
  // // int _dhcp = 0;
  //
  // final ssidController = TextEditingController();
  // final passController = TextEditingController();
  // final dhController = TextEditingController();
  //
  // final dhcpController = TextEditingController();
  // final ipController = TextEditingController();
  // final gwController = TextEditingController();
  // final maskController = TextEditingController();
  // final dns1Controller = TextEditingController();
  // final dns2Controller = TextEditingController();
  //
  // final responseData = '';
  //
  // String _dhcp = '';
  // String _ip = '';
  // String _gw = '';
  // String _mask = '';
  // String _dns1 = '';
  // String _dns2 = '';
  //
  // Checkwifistat wifiStatic = Checkwifistat();
  //
  // // For wifistatic
  // Future<String> send2() async {
  //   wifiStatic = Checkwifistat(dhcp: dhcpController.text, ip: ipController.text, gw: gwController.text, mask: maskController.text, dns1: dns1Controller.text, dns2: dns2Controller.text,);
  //   final url = Uri.parse('http://192.168.0.104/api/v1/custom=4&cmd=4002');
  //   final response = await http.post(url, body: json.encode(wifiStatic.toJson()));
  //   print(response.body);
  //
  //   final decodedJson = jsonDecode(response.body);
  //
  //   final dhcp = decodedJson['request']['dhcp'];
  //   final ip = decodedJson['request']['ip'];
  //   final gw = decodedJson['request']['gw'];
  //   final mask = decodedJson['request']['mask'];
  //   final dns1 = decodedJson['request']['dns1'];
  //   final dns2 = decodedJson['request']['dns2'];
  //
  //   setState(() {
  //     _dhcp = dhcp;
  //     _ip = ip;
  //     _gw = gw;
  //     _mask = mask;
  //     _dns1 = dns1;
  //     _dns2 = dns2;
  //   });
  //
  //   return response.body;
  // }
  //
  //
  // Future<String> send() async {
  //   dhcpinfo = DhcpInfo(dhcp: int.parse(dhcpController.text));
  //   final url = Uri.parse('http://192.168.0.105/api/v1/custom=4&cmd=4002');
  //   final response = await http.post(url, body: json.encode(dhcpinfo.toJson()));
  //   print(response.body);
  //
  //   final decodedJson = jsonDecode(response.body);
  //   final dhcp = decodedJson['request']['dhcp'];
  //
  //   setState(() {
  //     _dhcp = dhcp;
  //   });
  //
  //   return response.body;
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Fetch DHCP Value'),
  //     ),
  //     body: Form(
  //       key: _formKey,
  //       child: Column(
  //         children: [
  //           SizedBox(height: 20.0),
  //           Center(
  //             child: CustomTextField(
  //             dhcpController: dhcpController,
  //             ipController: ipController,
  //             gwController: gwController,
  //             maskController: maskController,
  //             dns1Controller: dns1Controller,
  //             dns2Controller: dns2Controller,
  //           ),
  //           ),
  //           SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: send2,
  //             child: Text("Send"),
  //             // color: Colors.teal,
  //           ),
  //           SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: DataTable(
  //               columns: [
  //                 DataColumn(label: Text('dhcp')),
  //                 DataColumn(label: Text('ip')),
  //                 DataColumn(label: Text('gw')),
  //                 DataColumn(label: Text('mask')),
  //                 DataColumn(label: Text('dns1')),
  //                 DataColumn(label: Text('dns2')),
  //
  //               ],
  //               rows: [
  //                 DataRow(cells: [
  //                   DataCell(Text(_dhcp)),
  //                   DataCell(Text(_ip)),
  //                   DataCell(Text(_gw)),
  //                   DataCell(Text(_mask)),
  //                   DataCell(Text(_dns1)),
  //                   DataCell(Text(_dns2)),
  //                 ]),
  //               ],
  //             ),
  //           ),
  //           // ProgressBar(
  //           //   progress: 0.50,
  //           //   height: 24,
  //           //   color: Colors.redAccent,
  //           // )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  AnimationController? controller;
  Animation<Color>? animation;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    // controller = AnimationController(
    //   duration: Duration(seconds: 3),
    //   vsync: this,
    // );
    //
    // animation = controller.drive(ColorTween(begin: Colors.yellow, end: Colors.red));
    final controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    final tween = TweenSequence<Color>([
      TweenSequenceItem(
        tween: Tween(begin: Colors.yellow, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Colors.orange, end: Colors.red),
        weight: 1,
      ),
    ]);

    final animation = controller.drive(tween);
    controller.repeat();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future startDownload() async {
    final url =
        'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4';

    final request = Request('GET', Uri.parse(url));
    final response = await Client().send(request);
    final contentLength = response.contentLength;

    final file = await getFile('file.mp4');
    final bytes = <int>[];
    response.stream.listen(
          (newBytes) {
        bytes.addAll(newBytes);

        setState(() {
          progress = bytes.length / (contentLength ?? 1);
        });
      },
      onDone: () async {
        setState(() {
          progress = 1;
        });

        await file.writeAsBytes(bytes);
      },
      onError: print,
      cancelOnError: true,
    );
  }

  Future<File> getFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();

    return File('${dir.path}/$filename');
  }

  Widget buildProgress() {
    if (progress == 1) {
      return Icon(
        Icons.done,
        color: Colors.green,
        size: 56,
      );
    } else {
      return Text(
        '${(progress * 100).toStringAsFixed(1)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 24,
        ),
      );
    }
  }

  Widget buildLinearProgress() => Text(
    '${(progress * 100).toStringAsFixed(1)}',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  );

  Widget buildHeader(String text) => Container(
    padding: EdgeInsets.only(bottom: 32),
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text("ble"),
    ),
    body: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildHeader('Indeterminable'),
          CircularProgressIndicator(
            valueColor: animation,
            backgroundColor: Colors.white,
            strokeWidth: 8,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            height: 10,
            child: LinearProgressIndicator(
              valueColor: animation,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          buildHeader('Determinable'),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                  strokeWidth: 10,
                  backgroundColor: Colors.white,
                ),
                Center(child: buildProgress()),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            height: 30,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                  backgroundColor: Colors.white,
                ),
                Center(child: buildLinearProgress()),
              ],
            ),
          ),
          const SizedBox(height: 32),
          FloatingActionButton.extended(
            onPressed: () => startDownload(),
            label: Text('Download'),
            icon: Icon(Icons.file_download),
          ),
        ],
      ),
    ),
  );

}
