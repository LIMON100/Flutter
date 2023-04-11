// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lamaAppR/temp/glowing_button2.dart';
//
// class CameraInfo extends StatefulWidget {
//
//   const CameraInfo({Key? key}) : super(key: key);
//
//   @override
//   _CameraInfoState createState() => _CameraInfoState();
// }
//
// class _CameraInfoState extends State<CameraInfo> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFFCBBACC), Color(0xFF2580B3)],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text("CAMERA"),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               // color: Color(0xFF6497d3),
//               color: Color(0xFF2580B3),
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // ElevatedButton(
//                   //   onPressed: () {},
//                   //   child: Text('Open Camera'),
//                   // ),
//                   GlowingButton2(
//                     text: "Open Camera",
//                     onPressed: () {},
//                     color1: Colors.blue,
//                     color2: Colors.cyan,
//                   ),
//                   GlowingButton2(
//                     text: "Close Camera",
//                     onPressed: () {},
//                     color1: Colors.blue,
//                     color2: Colors.cyan,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.0),
//               Container(
//                 height: 150,
//                 width: 200,
//                 child: Image.asset('',
//                   fit: BoxFit.fill,
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                 ),
//               ),
//               SizedBox(height: 40),
//               Text(
//                 'Snapshot take',
//                 style: TextStyle(fontSize: 24.0),
//               ),
//               SizedBox(height: 35.0),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     // child: ElevatedButton(
//                     //   onPressed: () {},
//                     //   child: Text('Front Camera'),
//                     // ),
//                     child: GlowingButton2(
//                       text: "Front Camera",
//                       onPressed: () {},
//                       color1: Colors.blue,
//                       color2: Colors.cyan,
//                     ),
//                   ),
//                   SizedBox(width: 7.0),
//                   Expanded(
//                     child: GlowingButton2(
//                       text: "Rear Up Camera",
//                       onPressed: () {},
//                       color1: Colors.blue,
//                       color2: Colors.cyan,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 5.0),
//               Expanded(
//                 child: GlowingButton2(
//                   text: "Rear Down Camera",
//                   onPressed: () {},
//                   color1: Colors.blue,
//                   color2: Colors.cyan,
//                 ),
//               ),
//               SizedBox(height: 25.0),
//               Container(
//                 height: 150,
//                 width: 200,
//                 child: Image.asset('',
//                   fit: BoxFit.fill,
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               GlowingButton2(
//                 text: "Stop",
//                 onPressed: () {},
//                 color1: Colors.blue,
//                 color2: Colors.cyan,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamaAppR/temp/glowing_button2.dart';

class CameraInfo extends StatefulWidget {
  const CameraInfo({Key? key}) : super(key: key);

  @override
  _CameraInfoState createState() => _CameraInfoState();
}

class _CameraInfoState extends State<CameraInfo> {
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
          title: Text("CAMERA"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2580B3),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GlowingButton2(
                      text: "Open Camera",
                      onPressed: () {},
                      color1: Colors.blue,
                      color2: Colors.cyan,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: GlowingButton2(
                      text: "Close Camera",
                      onPressed: () {},
                      color1: Colors.blue,
                      color2: Colors.cyan,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'images/llama_img_web.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Snapshot taken',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              SizedBox(height: 35.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GlowingButton2(
                      text: "Front Camera",
                      onPressed: () {},
                      color1: Colors.blue,
                      color2: Colors.cyan,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: GlowingButton2(
                      text: "Rear Up Camera",
                      onPressed: () {},
                      color1: Colors.blue,
                      color2: Colors.cyan,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: 60.0,
                child: GlowingButton2(
                    text: "Rear Down Camera",
                    onPressed: () {},
                    color1: Colors.blue,
                    color2: Colors.cyan,
                  ),
              ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(18.0),
              //       ),
              //     ),
              //   ),
              //   child: SizedBox(
              //     width: 200.0,
              //     height: 50.0,
              //     child: Center(
              //       child: Text(
              //         'Rear Down Camera',
              //         style: TextStyle(
              //           fontSize: 18.0,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              //   onPressed: () {},
              // ),
              SizedBox(height: 25.0),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'images/llama_img_web.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GlowingButton2(
                text: "Stop",
                onPressed: () {},
                color1: Colors.blue,
                color2: Colors.cyan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
