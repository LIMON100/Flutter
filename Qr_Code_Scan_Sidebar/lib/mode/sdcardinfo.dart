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
}