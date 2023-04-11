import 'package:flutter/material.dart';
import 'package:lamaAppR/mode/systeminfo.dart';
import 'mode/wifiInfo.dart';
import 'mode/systeminfo.dart';
import 'websidebar.dart';

class LlamaWebMenu extends StatelessWidget {
  const LlamaWebMenu({Key? key}) : super(key: key);

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
        drawer: WebSideBar(),

        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.black,
          title: const Text('LLama Eye'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF2580B3),
            ),
          ),
        ),
        // backgroundColor: Colors.lightBlue,),

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
      ),
    );
  }
}
