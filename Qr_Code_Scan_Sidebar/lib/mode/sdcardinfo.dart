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
}