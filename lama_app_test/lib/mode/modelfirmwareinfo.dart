import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

class ModelFirmwareInfo extends StatefulWidget {

  const ModelFirmwareInfo({Key? key}) : super(key: key);

  @override
  _ModelFirmwareInfoState createState() => _ModelFirmwareInfoState();
}

class _ModelFirmwareInfoState extends State<ModelFirmwareInfo> {


  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Models & Firmware"),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           if (_fileName != null)
  //             Text(
  //               "Selected file: $_fileName",
  //               style: TextStyle(fontSize: 16),
  //             ),
  //           if (_fileContent != null)
  //             Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Text(
  //                 _fileContent!,
  //                 style: TextStyle(fontSize: 14),
  //               ),
  //             ),
  //           SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: _pickFile,
  //             child: Text("Select Ai model"),
  //           ),
  //           SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: _pickFile,
  //             child: Text("Update Llamak210"),
  //           ),
  //           SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: _pickFile,
  //             child: Text("Update LlamaEsp"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // String outputText = '';
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Button Output Example'),
  //     ),
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         TextField(
  //           decoration: InputDecoration(
  //             labelText: '',
  //             border: OutlineInputBorder(),
  //           ),
  //           readOnly: true,
  //           controller: TextEditingController(text: outputText),
  //         ),
  //         SizedBox(height: 20),
  //         ElevatedButton(
  //           onPressed: _handleButtonClick,
  //           child: Text('Click me!'),
  //         ),
  //
  //         TextField(
  //           decoration: InputDecoration(
  //             labelText: '',
  //             border: OutlineInputBorder(),
  //           ),
  //           readOnly: true,
  //           controller: TextEditingController(text: outputText),
  //         ),
  //         SizedBox(height: 20),
  //         ElevatedButton(
  //           onPressed: _pickFile,
  //           child: Text('Update LlamaEsp'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  List<String> _selectedFiles = ['', '', ''];

  Future<void> _pickFile(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _selectedFiles[index] = result.files.single.name!;
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker Demo'),
      ),
      body: Column(
        children: [
          SizedBox(height: 50.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _pickFile(0),
                child: Text('Update Ai model'),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),

                  ),
                  controller: TextEditingController(text: _selectedFiles[0]),
                  readOnly: true,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _pickFile(1),
                child: Text('Update Llamak210'),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),

                  ),
                  controller: TextEditingController(text: _selectedFiles[1]),
                  readOnly: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _pickFile(2),
                child: Text('Update LLamaEsp'),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),

                  ),
                  controller: TextEditingController(text: _selectedFiles[2]),
                  readOnly: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}