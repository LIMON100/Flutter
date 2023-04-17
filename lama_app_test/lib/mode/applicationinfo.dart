import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaAppR/temp/glowing_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';



class ApplicationInfo extends StatefulWidget {

  const ApplicationInfo({Key? key}) : super(key: key);

  @override
  _ApplicationInfoState createState() => _ApplicationInfoState();
}

class _ApplicationInfoState extends State<ApplicationInfo> {

  TextEditingController _textFieldController = TextEditingController();
  String _inputText = '';

  void _handleSubmitted(String value) {
    setState(() {
      _inputText = value;
      _textFieldController.clear();
    });
  }

  //Audio Api
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  TextEditingController _textFieldController2 = TextEditingController();

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
          title: Text("Application"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF2580B3),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start and stop app button and field
                SizedBox(height: 18.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF42A5F5),
                                        Color(0xFFa6c1ee),
                                        Color(0xFF1976D2),
                                      ]
                                  )
                              ),
                            ),),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                primary: Colors.white,
                                textStyle: const TextStyle(fontSize: 15),
                              ),
                              onPressed: (){},
                              child: Text("Start App code"),
                            )

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18.0),
                    Container(
                      width: 55,
                      child: TextField(
                        //controller: _textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF3D4E81),
                                        Color(0xFF5753C9),
                                        Color(0xFF243949),
                                      ]
                                  )
                              ),
                            ),),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                primary: Colors.white,
                                textStyle: const TextStyle(fontSize: 15),
                              ),
                              onPressed: (){},
                              child: Text("Close App code"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //Restart button and text field
                SizedBox(height: 29.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xFF30cfd0),
                                          Color(0xFF330867),
                                          // Color(0xFF42A5F5),
                                        ]
                                    )
                                ),
                              ),),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(20),
                                  primary: Colors.white,
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                                onPressed: (){},
                                child: Text("Restart app"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      child: TextField(
                        controller: _textFieldController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: _handleSubmitted,
                      ),
                    ),
                  ],
                ),

                //  Play Audio
                SizedBox(height: 58.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFFbbc1bf),
                                        Color(0xFF57c6e1),
                                        Color(0xFF7ac5d8),
                                      ]
                                  )
                              ),
                            ),),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                primary: Colors.white,
                                textStyle: const TextStyle(fontSize: 15),
                              ),
                              onPressed: () async {
                              final input = _textFieldController.text;
                              await _sendPostRequest(input);
                              },
                              child: Text("Play Audio"),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      child: TextField(
                        controller: _textFieldController2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: _handleSubmitted,
                      ),
                    ),
                  ],
                ),

                //Change Script
                SizedBox(height: 35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child:
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xFF868f96),
                                          Color(0xFF596164),
                                          // Color(0xFF42A5F5),
                                        ]
                                    )
                                ),
                              ),),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  primary: Colors.white,
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                                onPressed: (){},
                                child: Text("Data Collection"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: <Color>[
                                          // Color(0xFFd558c8),
                                          Color(0xFF5D9FFF),
                                          Color(0xFF2580B3),
                                          Color(0xFF6BBBFF),
                                        ]
                                    )
                                ),
                              ),),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  primary: Colors.white,
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                                onPressed: (){},
                                child: Text("Main Application"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xFF562B7C),
                                          Color(0xFF2B86C5),
                                          Color(0xFF6654F1),
                                        ]
                                    )
                                ),
                              ),),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  primary: Colors.white,
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                                onPressed: (){},
                                child: Text("Data upload"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17.0),
                Container(
                  width: 80,
                  child: TextField(

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}