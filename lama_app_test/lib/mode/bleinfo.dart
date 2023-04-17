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
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class BleInfo extends StatefulWidget {

  const BleInfo({Key? key}) : super(key: key);

  @override
  _BleInfoState createState() => _BleInfoState();
}

class _BleInfoState extends State<BleInfo> with SingleTickerProviderStateMixin{

  AnimationController? controller;
  Animation<Color>? animation;
  double progress = 0;

  @override
  void initState() {
    super.initState();

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

  //Camera
  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage(_image!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage(File image) async {
    final url = Uri.parse('http://example.com/upload-image');
    final bytes = await image.readAsBytes();
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'image': base64.encode(bytes)}),
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully.');
    } else {
      print('Image upload failed.');
    }
  }

  void closeCamera() {
    setState(() {
      _image = null;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Future<File> get _localFile async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return File('${directory.path}/users.csv');
  // }
  Future<File> get _localFile async {
    final directory = Directory('J:/JumpWatts/Dataset/mobile_app/test_proj/qr_code_demo/0.New folder_test/lamaAppR/lib/temp').path;
    return File('$directory/users.csv');
  }

  Future<void> _writeUserToFile(String username, String password) async {
    final file = await _localFile;
    final csvLine = '${username.trim()},${password.trim()}\n';
    await file.writeAsString(csvLine, mode: FileMode.append);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      _writeUserToFile(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User created successfully')),
      );
      _usernameController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text("Ble"),
    ),
    body: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    ),
  );

}
