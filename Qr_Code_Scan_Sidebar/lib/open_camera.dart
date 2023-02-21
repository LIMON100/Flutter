import 'package:flutter/material.dart';
import 'qrviewexample.dart';

class OpenCamera extends StatelessWidget {
  const OpenCamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(' '),
      ),
      backgroundColor: Colors.grey,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRViewExample(),
            ));
          },
          child: const Text('Open Camera'),
        ),
      ),
    );
  }
}
