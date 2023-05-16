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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                GlowingButton2(
                  text: "Ride Settings",
                  onPressed: () {},
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
                SizedBox(height: 10),
                GlowingButton2(
                  text: "Warning Zone",
                  onPressed: () {},
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
                SizedBox(height: 10),
                GlowingButton2(
                  text: "Alert Zone",
                  onPressed: () {},
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
                SizedBox(height: 10),
                GlowingButton2(
                  text: "Ride Distance",
                  onPressed: () {},
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
                SizedBox(height: 200),
                GlowingButton2(
                  text: "Review Ride",
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ReviewRide()),
                    );
                  },
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //3rd part
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Color(0xFFa8caba), Color(0xFF517fa4)],
  //       ),
  //     ),
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       appBar: AppBar(
  //         centerTitle: true,
  //         foregroundColor: Colors.black,
  //         title: const Text('Llama Defender'),
  //         flexibleSpace: Container(
  //           decoration: BoxDecoration(
  //             color: Color(0xFF517fa4),
  //           ),
  //         ),
  //       ),
  //       body: SafeArea(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               flex: 1,
  //               child: Center(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
  //                   child: GlowingButton2(
  //                     text: "Ride Settings",
  //                     onPressed: () {},
  //                     color1: Color(0xFF517fa4),
  //                     color2: Colors.cyan,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
  //             Expanded(
  //               flex: 1,
  //               child: Center(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //                   child: GlowingButton2(
  //                     text: "Warning Zone",
  //                     onPressed: () {},
  //                     color1: Color(0xFF517fa4),
  //                     color2: Colors.cyan,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
  //             Expanded(
  //               flex: 1,
  //               child: Center(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //                   child: GlowingButton2(
  //                     text: "Alert Zone",
  //                     onPressed: () {},
  //                     color1: Color(0xFF517fa4),
  //                     color2: Colors.cyan,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
  //             Expanded(
  //               flex: 1,
  //               child: Center(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //                   child: GlowingButton2(
  //                     text: "Ride Distance",
  //                     onPressed: () {},
  //                     color1: Color(0xFF517fa4),
  //                     color2: Colors.cyan,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: MediaQuery.of(context).size.height * 0.1),
  //             Expanded(
  //               flex: 1,
  //               child: Center(
  //                 child: Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //                   child: GlowingButton2(
  //                     text: "Review Ride",
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                       Navigator.of(context).push(
  //                         MaterialPageRoute(builder: (context) => const ReviewRide()),
  //                       );
  //                     },
  //                     color1: Color(0xFF517fa4),
  //                     color2: Colors.cyan,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
