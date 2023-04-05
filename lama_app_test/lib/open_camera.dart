import 'package:flutter/material.dart';
import 'qrviewexample.dart';

class OpenCamera extends StatelessWidget {
  const OpenCamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(' '),
      // ),
      // backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xff2e89f6),
        child: Align(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const QRViewExample(),
              ));
            },
            child: const Text('Open Camera to scan QR code'),
          ),
        ),
      ),
      ),
    );
  }
}
