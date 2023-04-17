import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaAppR/temp/glowing_button2.dart';
import 'package:image_picker/image_picker.dart';

class CameraInfo extends StatefulWidget {
  const CameraInfo({Key? key}) : super(key: key);

  @override
  _CameraInfoState createState() => _CameraInfoState();
}

class _CameraInfoState extends State<CameraInfo> {

  File? _image;
  final picker = ImagePicker();

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> sendImage() async {
    if (_image != null) {
      final url = Uri.parse('https://example.com/api/upload');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        // Image uploaded successfully
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonResponse = jsonDecode(responseString);
        print(jsonResponse['message']);
      } else {
        // Error occurred while uploading the image
        print('Error: ${response.reasonPhrase}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
          title: Text("CAMERA"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2580B3),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GlowingButton2(
                      text: "Open Camera",
                      onPressed: () => getImage(ImageSource.camera),
                      color1: Colors.blue,
                      color2: Colors.cyan,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: GlowingButton2(
                      text: "Close Camera",
                      onPressed: () {},
                      color1: Colors.blue,
                      color2: Colors.cyan,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'images/llama_img_web.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Snapshot take',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              SizedBox(height: 35.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GlowingButton2(
                      text: "Front Camera",
                      onPressed: () {},
                      color1: Colors.blue,
                      color2: Colors.cyan,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: GlowingButton2(
                      text: "Rear Up Camera",
                      onPressed: () {},
                      color1: Colors.blue,
                      color2: Colors.cyan,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: 60.0,
                child: GlowingButton2(
                    text: "Rear Down Camera",
                    onPressed: () {},
                    color1: Colors.blue,
                    color2: Colors.cyan,
                  ),
              ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(18.0),
              //       ),
              //     ),
              //   ),
              //   child: SizedBox(
              //     width: 200.0,
              //     height: 50.0,
              //     child: Center(
              //       child: Text(
              //         'Rear Down Camera',
              //         style: TextStyle(
              //           fontSize: 18.0,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              //   onPressed: () {},
              // ),
              SizedBox(height: 25.0),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'images/llama_img_web.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GlowingButton2(
                text: "Stop",
                onPressed: () {},
                color1: Colors.blue,
                color2: Colors.cyan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
