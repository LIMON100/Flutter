import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class BlinkingLightPage extends StatefulWidget {
  const BlinkingLightPage({Key? key}) : super(key: key);

  @override
  _BlinkingLightPageState createState() => _BlinkingLightPageState();
}

class _BlinkingLightPageState extends State<BlinkingLightPage> {
  late AudioCache _audioCache;
  late bool _isOn;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache();
    _isOn = false;
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isOn = !_isOn;
        if (_isOn) {
          _audioCache.play('warning_beep.mp3'); // play beep sound
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blinking Light'),
      ),
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isOn ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}
