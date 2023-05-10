import 'package:flutter/material.dart';
import 'package:lamaradar/temp/glowing_button.dart';
import 'package:lamaradar/mode/review_ride.dart';

class LlamaDefender extends StatefulWidget {

  const LlamaDefender({Key? key}) : super(key: key);

  @override
  _LlamaDefenderState createState() => _LlamaDefenderState();
}

class _LlamaDefenderState extends State<LlamaDefender> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFa8caba), Color(0xFF517fa4)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.black,
          title: const Text('Llama Defender'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF517fa4),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlowingButton2(
                text: "Ride Settings",
                onPressed: () {

                },
                color1: Color(0xFF517fa4),
                color2: Colors.cyan,
              ),
              SizedBox(height:5),
              GlowingButton2(
                text: "Warning Zone",
                onPressed: () {

                },
                color1: Color(0xFF517fa4),
                color2: Colors.cyan,
              ),
              SizedBox(height:5),
              GlowingButton2(
                text: "Alert Zone",
                onPressed: () {

                },
                color1: Color(0xFF517fa4),
                color2: Colors.cyan,
              ),
              SizedBox(height:5),
              GlowingButton2(
                text: "Ride Distance",
                onPressed: () {

                },
                color1: Color(0xFF517fa4),
                color2: Colors.cyan,
              ),
              SizedBox(height:250),
              GlowingButton2(
                text: "Review Ride",
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ReviewRide()
                    ),
                  );
                },
                color1: Color(0xFF517fa4),
                color2: Colors.cyan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
