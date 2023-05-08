import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'warning_icons.dart';
import 'indicator_icons.dart';
import 'BlinkingIconButton.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CollisionWarningPage extends StatefulWidget {
  final BluetoothDevice device;

  const CollisionWarningPage({Key? key, required this.device}) : super(key: key);
  // const CollisionWarningPage({Key? key}) : super(key: key);

  @override
  _CollisionWarningPageState createState() => _CollisionWarningPageState();
}

class _CollisionWarningPageState extends State<CollisionWarningPage> {
  late Timer _timer;
  int _leftCollisionValue = 0;
  int _rightCollisionValue = 100;
  int _topCollisionValue = 0;
  int _bottomCollisionValue = 101;
  bool _blinkLeft = false;
  bool _blinkRight = false;
  bool _blinkTop = false;
  bool _blinkBottom = false;


  Timer? _blinkTimer;
  bool _isLeftBlinking = false;
  bool _isRightBlinking = false;
  bool _isTopBlinking = false;
  bool _isBottomBlinking = false;

  bool _cameraOn = false;
  bool _lightOn1 = false;
  bool _lightOn2 = false;
  bool _emergencyOn = false;
  bool _powerOn = false;

  //notificaiton variable
  late BluetoothDevice _device;
  BluetoothCharacteristic? _characteristic;
  Stream<List<int>>? _stream;
  String _value = '';

  // @override
  // void initState() {
  //   super.initState();
  //   // Start a timer that updates the collision values every 1 second
  //   _timer = Timer.periodic(Duration(seconds: 1), (_) {
  //     setState(() {
  //       // Generate random collision values between 0 and 10
  //       _leftCollisionValue = _generateRandomNumber(0, 10);
  //       _rightCollisionValue = _generateRandomNumber(0, 10);
  //       _topCollisionValue = _generateRandomNumber(0, 10);
  //       _bottomCollisionValue = _generateRandomNumber(0, 10);
  //
  //       // Determine which warning sign should blink based on the collision values
  //       int maxCollisionValue = [          _leftCollisionValue,          _rightCollisionValue,          _topCollisionValue,          _bottomCollisionValue        ].reduce((value, element) => value > element ? value : element);
  //
  //       _blinkLeft = _leftCollisionValue == maxCollisionValue;
  //       _blinkRight = _rightCollisionValue == maxCollisionValue;
  //       _blinkTop = _topCollisionValue == maxCollisionValue;
  //       _blinkBottom = _bottomCollisionValue == maxCollisionValue;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _connectToDevice();
    // Start a timer to blink the warning signs
    _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        // Check which side has the highest collision value
        if (_leftCollisionValue > _rightCollisionValue &&
            _leftCollisionValue > _topCollisionValue &&
            _leftCollisionValue > _bottomCollisionValue) {
          // If the left side has the highest collision value, blink the left warning sign
          _isLeftBlinking = !_isLeftBlinking;
          _isRightBlinking = false;
          _isTopBlinking = false;
          _isBottomBlinking = false;
        } else if (_rightCollisionValue > _leftCollisionValue &&
            _rightCollisionValue > _topCollisionValue &&
            _rightCollisionValue > _bottomCollisionValue) {
          // If the right side has the highest collision value, blink the right warning sign
          _isLeftBlinking = false;
          _isRightBlinking = !_isRightBlinking;
          _isTopBlinking = false;
          _isBottomBlinking = false;
        } else if (_topCollisionValue > _leftCollisionValue &&
            _topCollisionValue > _rightCollisionValue &&
            _topCollisionValue > _bottomCollisionValue) {
          // If the top side has the highest collision value, blink the top warning sign
          _isLeftBlinking = false;
          _isRightBlinking = false;
          _isTopBlinking = !_isTopBlinking;
          _isBottomBlinking = false;
        } else if (_bottomCollisionValue > _leftCollisionValue &&
            _bottomCollisionValue > _rightCollisionValue &&
            _bottomCollisionValue > _topCollisionValue) {
          // If the bottom side has the highest collision value, blink the bottom warning sign
          _isLeftBlinking = false;
          _isRightBlinking = false;
          _isTopBlinking = false;
          _isBottomBlinking = !_isBottomBlinking;
        }
      });
    });
  }

  Future<void> _connectToDevice() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = await service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
          // _service = service;
          _characteristic = characteristic;

          // Enable notifications for the characteristic
          await _characteristic!.setNotifyValue(true);

          // Listen to the characteristic notifications
          _characteristic!.value.listen((value) {
            setState(() {
              _value = value.toString();
            });
          });

          print('Found characteristic ${characteristic.uuid}');
          break;
        }
      }
    }
    setState(() {
      _device = widget.device;
    });
  }

  final _random = Random();
  int _generateRandomNumber(int min, int max) {
    return (min + (max - min) * _random.nextDouble()).toInt();
  }

  //Blinking funciton
  // bool _isLeftBlinking = false;
  // bool _isRightBlinking = false;
  Timer? _leftBlinkTimer;
  Timer? _rightBlinkTimer;

  @override
  void dispose() {
    _leftBlinkTimer?.cancel();
    _rightBlinkTimer?.cancel();
    super.dispose();
  }

  void _startLeftBlinking() {
    _leftBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        _isLeftBlinking = !_isLeftBlinking;
      });
    });
    // Stop the blinking after 3 seconds
    Future.delayed(Duration(seconds: 3)).then((_) {
      _leftBlinkTimer?.cancel();
      setState(() {
        _isLeftBlinking = false;
      });
    });
  }

  void _startRightBlinking() {
    _rightBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        _isRightBlinking = !_isRightBlinking;
      });
    });
    // Stop the blinking after 3 seconds
    Future.delayed(Duration(seconds: 3)).then((_) {
      _rightBlinkTimer?.cancel();
      setState(() {
        _isRightBlinking = false;
      });
    });
  }

  void _startBothBlinking() {
    _startLeftBlinking();
    _startRightBlinking();
  }

  //Notification value


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
          title: const Text('Ride Info'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF517fa4),
            ),
          ),
        ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Top warning+indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _startLeftBlinking();
                    },
                    icon: Icon(
                      Indicator.image2vector,
                      size: 48,
                      color: _isLeftBlinking ? Colors.orange : Colors.black,
                    ),
                  ),
                  // BlinkingIconButton(icon: Indicator.image2vector, size: 48),

                  SizedBox(width: 60),
                  Icon(
                    Warning.image2vector3,
                    size: 48,
                    color: _isTopBlinking ? Colors.red : Colors.green,
                  ),
                  SizedBox(width: 60),

                  IconButton(
                    onPressed: () {
                      _startRightBlinking();
                    },
                    icon: Icon(
                      Indicator.image2vector__1_,
                      size: 48,
                      color: _isRightBlinking  ? Colors.orange : Colors.black,
                    ),
                  ),
                ],
              ),

              // left+right warning
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Warning.image2vector,
                    size: 48,
                    color: _isLeftBlinking ? Colors.red : Colors.green,
                  ),
                  SizedBox(width: 140),
                  Icon(
                    Warning.image2vector2,
                    size: 48,
                    color: _isRightBlinking ? Colors.red : Colors.green,
                  ),
                ],
              ),

              // ligts
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(_lightOn1 ? Icons.lightbulb : Icons.lightbulb_outline),
                      onPressed: () {
                        setState(() {
                          _lightOn1 = !_lightOn1;
                        });
                      }
                  ),
                  SizedBox(width: 140),
                  IconButton(
                      icon: Icon(_lightOn2 ? Icons.lightbulb : Icons.lightbulb_outline),
                      onPressed: () {
                        setState(() {
                          _lightOn2 = !_lightOn2;
                        });
                      }
                  ),
                ],
              ),

              // Bottom warning
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Warning.image2vector3,
                    size: 48,
                    color: _isBottomBlinking ? Colors.red : Colors.green,
                  ),
                ],
              ),

              //other buttons
              SizedBox(width: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_cameraOn ? Icons.camera_alt : Icons.camera_alt_outlined),
                    onPressed: () {
                      setState(() {
                        _cameraOn = !_cameraOn;
                      });
                      // open camera if _cameraOn is true
                    },
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(_emergencyOn ? Icons.emergency_sharp : Icons.emergency_outlined),
                    onPressed: () {
                      _startBothBlinking();
                    },
                  ),
                  SizedBox(width: 20),
                  IconButton(
                      icon: Icon(_lightOn1 ? Icons.lightbulb : Icons.lightbulb_outline),
                      onPressed: () {
                        setState(() {
                          _lightOn1 = !_lightOn1;
                        });
                      }
                  ),
                ],
              ),

              // Notificaiton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Notifications:',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _value[11],
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),


              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text('Top: $_topCollisionValue'),
              //     SizedBox(width: 16),
              //     Text('Bottom: $_bottomCollisionValue'),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 120),
                  Image.asset(
                    'images/llama_img.png',
                    height: 100,
                    width: 130,
                  ),
                  SizedBox(width: 16),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _powerOn = !_powerOn;
                      });
                    },
                    backgroundColor: _powerOn ? Colors.red : Colors.blueGrey,
                    child: Icon(Icons.power_settings_new),
                  ),
                ],
              )
            ],
          ),
      ),
    );
  }
  void _updateWarningSigns() {
    setState(() {
      _blinkLeft = _leftCollisionValue > _rightCollisionValue &&
          _leftCollisionValue > _topCollisionValue &&
          _leftCollisionValue > _bottomCollisionValue;
      _blinkRight = _rightCollisionValue > _leftCollisionValue &&
          _rightCollisionValue > _topCollisionValue &&
          _rightCollisionValue > _bottomCollisionValue;
      _blinkTop = _topCollisionValue > _leftCollisionValue &&
          _topCollisionValue > _rightCollisionValue &&
          _topCollisionValue > _bottomCollisionValue;
      _blinkBottom = _bottomCollisionValue > _leftCollisionValue &&
          _bottomCollisionValue > _rightCollisionValue &&
          _bottomCollisionValue > _topCollisionValue;
    });
  }
}
