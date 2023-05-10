import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'warning_icons.dart';
import 'indicator_icons.dart';
import 'BlinkingIconButton.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CollisionWarningPage2 extends StatefulWidget {
  final BluetoothDevice device;

  const CollisionWarningPage2({Key? key, required this.device}) : super(key: key);
  // const CollisionWarningPage({Key? key}) : super(key: key);

  @override
  _CollisionWarningPage2State createState() => _CollisionWarningPage2State();
}

class _CollisionWarningPage2State extends State<CollisionWarningPage2> {
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

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _connectToDevice();
    _startBlinking();
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
    _stopBlinking();
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
    _rightBlinkTimer = Timer.periodic(Duration(milliseconds: 50), (_) {
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

  //Blink with value
  bool _isBlinking = false;
  int _blinkCount = 0;
  bool _isRed = false;
  bool _isYellow = false;

  void _startBlinking() {
    _isBlinking = true;
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_isBlinking) {
        setState(() {
          if (_blinkCount % 2 == 0) {
            _isRed = true;
            _isYellow = false;
          } else {
            _isRed = false;
            _isYellow = true;
          }
          _blinkCount++;
          if (_blinkCount >= 6) {
            _stopBlinking();
          }
        });
      }
    });
  }
  // void _startBlinking() {
  //   int num = int.parse(_value[1]);
  //   _isBlinking = true;
  //   _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
  //     if (_isBlinking) {
  //       setState(() {
  //         if (_blinkCount % 2 == 0) {
  //           _isRed = false;
  //           _isYellow = false;
  //         } else {
  //           switch (num) {
  //             case 1:
  //               _isRed = false;
  //               _isYellow = true;
  //               break;
  //             case 2:
  //               _isRed = true;
  //               _isYellow = false;
  //               break;
  //             case 3:
  //               _isRed = false;
  //               _isYellow = true;
  //               break;
  //             case 4:
  //               _isRed = true;
  //               _isYellow = false;
  //               break;
  //             case 5:
  //               _isRed = true;
  //               _isYellow = false;
  //               break;
  //             default:
  //               _isRed = false;
  //               _isYellow = false;
  //           }
  //         }
  //         _blinkCount++;
  //         if (_blinkCount >= 6) {
  //           _stopBlinking();
  //         }
  //       });
  //     }
  //   });
  // }


  void _stopBlinking() {
    _isBlinking = false;
    _timer.cancel();
    setState(() {
      _isRed = false;
      _isYellow = false;
      _blinkCount = 0;
    });
  }

  String _getLocation() {
    if (_value.length < 12) {
      return 'Notification Not Available';
    }
    switch (int.parse(_value[11])) {
      case 1:
        return 'Right Notification Warning';
      case 2:
        return 'Right Notification Danger';
      case 3:
        return 'Right Notification Warning';
      case 4:
        return 'Left Notification Danger';
      case 5:
        return 'Rear Notification Danger';
      default:
        return '';
    }
  }

  Color _getColor() {
    if (_value.isEmpty || _value.length < 12) {
      return Colors.black;
    }
    switch (int.parse(_value[11])) {
      case 1:
      case 3:
        return _getLocation() == 'Right Notification Warning'
            ? Colors.yellow
            : Colors.black;
      case 2:
      case 4:
      case 5:
        return _getLocation() == 'Rear Notification Danger'
            ? Colors.red
            : Colors.black;
      default:
        return Colors.black;
    }
  }

  Widget _getCircle(Color color) {
    double opacity = 1.0;
    if (_getLocation() == 'Left Notification Danger' ||
        _getLocation() == 'Right Notification Danger' ||
        _getLocation() == 'Rear Notification Danger') {
      opacity = 0.0;
    }
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: opacity,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Widget _getLeftIcon() {
    double opacity = 1.0;
    Color color = Colors.red;

    if (_getLocation() == 'Left Notification Danger') {
      color = Colors.red;
    } else if (_getLocation() == 'Left Notification Warning') {
      color = Colors.yellow;
    } else {
      color = Colors.green;
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: opacity,
      // child: Icon(Icons.arrow_back, color: color),
      child: Icon(
        Warning.image2vector,
        size: 48,
        color: color,
        // color: _getColor(),
      ),
    );
  }

  Widget _getRightIcon() {
    double opacity = 1.0;
    Color color = Colors.red;

    if (_getLocation() == 'Right Notification Danger') {
      color = Colors.red;
    } else if (_getLocation() == 'Right Notification Warning') {
      color = Colors.yellow;
    } else {
      // opacity = 0.0;
      color = Colors.green;
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: opacity,
      child: Icon(
        Warning.image2vector2,
        size: 48,
        color: color,
      ),
    );
  }

  Widget _getRearIcon() {
    double opacity = 1.0;
    Color color = Colors.red;

    if (_getLocation() == 'Rear Notification Danger') {
      color = Colors.red;
    } else if (_getLocation() == 'Rear Notification Warning') {
      color = Colors.yellow;
    } else {
      color = Colors.green;
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: opacity,
      child: Icon(
        Warning.image2vector3,
        size: 48,
        color: color,
      ),
    );
  }


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
                  // Icon(
                  //   Warning.image2vector,
                  //   size: 48,
                  //   color: _isLeftBlinking ? Colors.red : Colors.green,
                  //   // color: _getColor(),
                  // ),
                  _getLeftIcon(),
                  SizedBox(width: 15),
                  Text(
                    _getLocation(),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 20),
                  _getRightIcon(),
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

              // Rear warning
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getRearIcon(),
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

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(height: 16),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         _getLeftIcon(),
              //         SizedBox(width: 16),
              //         Text(
              //           _getLocation(),
              //           style: TextStyle(fontSize: 20),
              //         ),
              //         SizedBox(width: 16),
              //         _getRightIcon(),
              //       ],
              //     ),
              //     SizedBox(width: 2),
              //     _getRearIcon(),
              //   ],
              // ),

              // Image with power button
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
}
