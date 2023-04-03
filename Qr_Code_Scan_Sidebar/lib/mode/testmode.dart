import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaApp/Models/model.dart';
import 'dart:convert';
import 'package:lamaApp/Models/model.dart';
import 'package:lamaApp/Models/Checkwifistat.dart';
import 'package:lamaApp/Models/WifiStat.dart';
import 'package:image_picker/image_picker.dart';

class TestMode extends StatefulWidget {
  final Function(File)? onImageSelected;
  const TestMode({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _TestModeState createState() => _TestModeState();
}

class _TestModeState extends State<TestMode> {

  final _picker = ImagePicker();
  File? _imageFile;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        widget.onImageSelected?.call(_imageFile!);
      }
    });
  }

    // @override
    // Widget build(BuildContext context) {
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       'Image',
    //       style: TextStyle(fontSize: 16),
    //     ),
    //     SizedBox(height: 8),
    //     GestureDetector(
    //       onTap: () {
    //         showModalBottomSheet(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return SafeArea(
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: <Widget>[
    //                   ListTile(
    //                     leading: Icon(Icons.photo_camera),
    //                     title: Text('Take a picture'),
    //                     onTap: () {
    //                       _getImage(ImageSource.camera);
    //                       Navigator.of(context).pop();
    //                     },
    //                   ),
    //                   ListTile(
    //                     leading: Icon(Icons.photo_library),
    //                     title: Text('Choose from gallery'),
    //                     onTap: () {
    //                       _getImage(ImageSource.gallery);
    //                       Navigator.of(context).pop();
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             );
    //           },
    //         );
    //       },
    //       child: Container(
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             color: Colors.grey,
    //             width: 1.0,
    //           ),
    //           borderRadius: BorderRadius.circular(4.0),
    //         ),
    //         child: _imageFile != null
    //             ? Image.file(
    //           _imageFile!,
    //           width: double.infinity,
    //           fit: BoxFit.cover,
    //         )
    //             : Icon(
    //           Icons.camera_alt,
    //           size: 64,
    //           color: Colors.grey[300],
    //         ),
    //         alignment: Alignment.center,
    //         height: 180,
    //       ),
    //     ),
    //   ],
    // );

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Color(0xFF3ac3cb), Color(0xFFf85187)],
  //       )
  //     ),
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       appBar: AppBar(
  //         backgroundColor: Colors.blue.withOpacity(0.5),
  //         title: Text('Test'),
  //       ),
  //       body: Center(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20)
  //           ),
  //           width: 200,
  //           height: 200,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent, // set background color here
              ),
              child: Image(
                image: AssetImage('images/test_background.jpg'),
              ),
            ),
          ),
        ));
  }
}
