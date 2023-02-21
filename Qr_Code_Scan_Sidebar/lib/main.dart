import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'SideBar.dart';
import 'qrviewexample.dart';

void main() => runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(title: const Text('LLama'),
      backgroundColor: Colors.grey,),
      // backgroundColor: Colors.blueGrey,
      body: Container(
        child: Center(
          child: Image.asset('images/llamalogo_no_txt.jpg',
            fit: BoxFit.cover,
            width: 90,
            height: 90,
          ),
        ),
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => const QRViewExample(),
      //       ));
      //     },
      //     child: const Text('Open Camera'),
      //   ),
      // ),
    );
  }
}
