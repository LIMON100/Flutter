import 'package:flutter/material.dart';

class ReviewRide extends StatefulWidget {
  @override
  _ReviewRideState createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('Review Ride'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xFF2580B3),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 60),
          Expanded(
            child: Text(
                "Thank you for riding. You rode 5 km today You got 6 safety alerts Near miss 2"
            ),
          ),
        ],
      ),
    );
  }
}