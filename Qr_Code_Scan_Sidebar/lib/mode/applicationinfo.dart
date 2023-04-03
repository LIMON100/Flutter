<<<<<<< HEAD
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5D9FFF), Color(0xFFB8DCFF), Color(0xFF6BBBFF)],
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
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
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
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
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
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
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
                              child: Text("Restart app"),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 40,
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
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
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
                        controller: _textFieldController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: _handleSubmitted,
                      ),
                    ),
                  ],
                ),

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
                                          Color(0xFF0D47A1),
                                          Color(0xFF1976D2),
                                          Color(0xFF42A5F5),
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
                                          Color(0xFF0D47A1),
                                          Color(0xFF1976D2),
                                          Color(0xFF42A5F5),
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
                                          Color(0xFF0D47A1),
                                          Color(0xFF1976D2),
                                          Color(0xFF42A5F5),
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
=======
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApplicationInfo extends StatefulWidget {

  const ApplicationInfo({Key? key}) : super(key: key);

  @override
  _ApplicationInfoState createState() => _ApplicationInfoState();
}

class _ApplicationInfoState extends State<ApplicationInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Application"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start and stop app button and field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Start App code'),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 50,
                  child: TextField(
                    //controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Close App code'),
                ),
              ],
            ),

            //Restart button and text field
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {},
              child: Text('Restart app'),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 50,
              child: TextField(
                //controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 35.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Data Collection'),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Main application'),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Data Upload'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              width: 80,
              child: TextField(

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),

          //  Play Audio
            SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Play Audio'),
                ),
                Container(
                  width: 50,
                  child: TextField(
                    //controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
             ),
          ],
        ),
      ),
    );
  }
>>>>>>> a8776f8116c317b8a4629530ef06c600a63434ce
}