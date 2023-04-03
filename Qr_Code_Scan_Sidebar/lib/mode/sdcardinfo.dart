<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SdCardInfo extends StatefulWidget {

  const SdCardInfo({Key? key}) : super(key: key);

  @override
  _SdCardInfoState createState() => _SdCardInfoState();
}

class _SdCardInfoState extends State<SdCardInfo> {

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
          title: Text("Sd Card"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Upload file'),
                    ),
                    SizedBox(height: 16.0),

                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Delete file'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
=======
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SdCardInfo extends StatefulWidget {
  @override
  _SdCardInfoState createState() => _SdCardInfoState();
}

class _SdCardInfoState extends State<SdCardInfo> {

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Field Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  child: Text("Button 1"),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text("Button 2"),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: "Enter text here",
                border: OutlineInputBorder(),
              ),
              onSubmitted: _handleSubmitted,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  child: Text("Button 1"),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text("Button 2"),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text("Button 3"),
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