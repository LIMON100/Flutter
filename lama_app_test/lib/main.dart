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

      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('LLama'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xFF2580B3),
          ),
        ),
      ),
        // backgroundColor: Colors.lightBlue,),

      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          child: Image.asset('images/test.jpg',
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
