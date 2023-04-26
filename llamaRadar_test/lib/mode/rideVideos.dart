import 'package:flutter/material.dart';

class RideVideos extends StatefulWidget {
  @override
  _RideVideosState createState() => _RideVideosState();
}

class _RideVideosState extends State<RideVideos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('Ride Files'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xFF2580B3),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 160),
          Center(
            child: Text(
                "Video Files"
            ),
          ),
        ],
      ),
    );
  }
}