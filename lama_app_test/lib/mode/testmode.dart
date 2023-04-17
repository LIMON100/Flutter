import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaAppR/Models/model.dart';
import 'dart:convert';
import 'package:lamaAppR/Models/model.dart';
import 'package:lamaAppR/Models/Checkwifistat.dart';
import 'package:lamaAppR/Models/WifiStat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lamaAppR/Models/ApiResponse.dart';
import 'package:lamaAppR/Models/RestartInfo.dart';
import 'package:lamaAppR/temp/glowing_button.dart';
import 'package:lamaAppR/temp/glowing_button2.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';


class TestMode extends StatefulWidget {
  final Function(File)? onImageSelected;
  const TestMode({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _TestModeState createState() => _TestModeState();
}

class _TestModeState extends State<TestMode> {


  // /Restart check
  Future<RestartInfo> getRestartInfoApi() async {
    final response = await http.get(Uri.parse('http://192.168.0.105/api/v1/custom=3&cmd=3001'));
    if (response.statusCode == 200) {
      return RestartInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   Color shadowColor = Colors.blue;

  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       title: Text('Audio'),
  //     ),
  //     body: SingleChildScrollView(
  //       scrollDirection: Axis.vertical,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Container(
  //             margin: EdgeInsets.zero,
  //             child:Center(
  //                 child: FutureBuilder<RestartInfo>(
  //                   future: getRestartInfoApi(),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.hasData) {
  //                       final request = snapshot.data!.request;
  //                       return SingleChildScrollView(
  //                         scrollDirection: Axis.vertical,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                           Text('${request.restartCounter}'),
  //                             // Text(""),
  //                             // TextField(
  //                             //   decoration: InputDecoration(
  //                             //     labelText: '',
  //                             //     border: OutlineInputBorder(),
  //                             //   ),
  //                             //   controller: TextEditingController(
  //                             //     text: '${request['date']} ${request['time']}',
  //                             //   ),
  //                             //   enabled: false,
  //                             // ),
  //                           ],
  //                         ),
  //                       );
  //                     } else if (snapshot.hasError) {
  //                       return Text('${snapshot.error}');
  //                     } else {
  //                       return CircularProgressIndicator();
  //                     }
  //                   },
  //                 ),
  //               )
  //           ),
  //           Text('NEON BUTTON',
  //           style: TextStyle(
  //             fontSize: 20,
  //             color: Colors.white,
  //             shadows: [
  //               for (double i = 1; i < 4; i++)
  //                 Shadow(
  //                   color: shadowColor,
  //                   blurRadius: 3 * i,
  //                 )
  //             ]
  //           ),),
  //         ],
  //       ),
  //     )
  //     );
  // }
    //DataCell(Text('${request.restartCounter}')),
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
  //   final List<String> buttonTitles = [
  //     'Button 1',
  //     'Button 2',
  //     'Button 3',
  //     'Button 4',
  //     'Button 5',
  //     'Button 6',
  //     'Button 7',
  //   ];
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: Text('My App'),
  //       ),
  //       body: SingleChildScrollView(
  //         child: Padding(
  //           padding: EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               SizedBox(height: 16.0),
  //               ..._buildButtons(),
  //               SizedBox(height: 32.0),
  //               ..._buildTextFields(),
  //               SizedBox(height: 16.0),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   List<Widget> _buildButtons() {
  //     return buttonTitles
  //         .map(
  //           (title) => GlowingButton(
  //             color1: Colors.orange,
  //             color2: Colors.black38,
  //           ),
  //     )
  //         .toList();
  //   }
  //
  //   List<Widget> _buildTextFields() {
  //     return List.generate(
  //       4,
  //           (index) => TextField(
  //         decoration: InputDecoration(
  //           labelText: 'Text Field ${index + 1}',
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //     );
  //   }
  double progress = 0.0;

  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    final bytes = await http.readBytes(Uri.parse(url));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/audio.mp3');
    await file.writeAsBytes(bytes);
    final source = AudioSource.uri(Uri.parse(file.path));
    await _audioPlayer.setAudioSource(source);
    await _audioPlayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _sendPostRequest(String input) async {
    final url = Uri.parse('http://your-api-url.com/audio');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'input': input,
      }),
    );
    if (response.statusCode == 200) {
      final url = json.decode(response.body)['url'];
      await _playAudio(url);
    } else {
      throw Exception('Failed to load audio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buttons and Text Fields"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: GlowingButton(
                    color1: Colors.pinkAccent,
                    color2: Colors.indigoAccent,
                  ),
                ),
                // GlowingButton(),
                SizedBox(width: 16.0),
                Expanded(
                  child: GlowingButton2(
                    text: "Button 2",
                    onPressed: () {},
                    color1: Colors.red,
                    color2: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              height: 100,
              width: 10,
              child: LiquidCircularProgressIndicator(
                value: 0.5, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors.indigoAccent), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.black38,
                borderWidth: 5.0,
                direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                center: Text("Loading..."),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 5.0,
              child: LiquidLinearProgressIndicator(
                value: progress, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors.blueAccent), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.greenAccent,
                borderWidth: 5.0,
                // borderRadius: 5.0,
                direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                center: Text('${(progress * 100).toStringAsFixed(0)}%'),
              ),
            ),
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Enter audio URL',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final input = _textFieldController.text;
                await _sendPostRequest(input);
              },
              child: Text('Play Audio'),
            ),
            SizedBox(height: 16),
            if (_isPlaying) Text('Playing Audio...'),
          ],
        ),
      ),
    );
  }
}
