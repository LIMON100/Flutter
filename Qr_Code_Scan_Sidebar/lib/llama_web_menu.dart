import 'package:flutter/material.dart';
import 'package:lamaApp/mode/systeminfo.dart';
import 'mode/wifiInfo.dart';
import 'mode/systeminfo.dart';
import 'websidebar.dart';

class LlamaWebMenu extends StatelessWidget {
  const LlamaWebMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: WebSideBar(),

      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('LLama Web'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xff2e89f6),
          ),
        ),
      ),
      // backgroundColor: Colors.lightBlue,),

      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          child: Text(" "),
          // child: Image.asset('images/test.jpg',
          //   fit: BoxFit.fill,
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          // ),
        ),
      ),
    );
  }
}