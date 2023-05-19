<<<<<<< HEAD
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'warning_icons.dart';
import 'indicator_icons.dart';
import 'BlinkingIconButton.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:just_audio/just_audio.dart';

class CollisionWarningPage2 extends StatefulWidget {
  final BluetoothDevice device;

  const CollisionWarningPage2({Key? key, required this.device}) : super(key: key);
  // const CollisionWarningPage({Key? key}) : super(key: key);

  @override
  _CollisionWarningPage2State createState() => _CollisionWarningPage2State();
}

class _CollisionWarningPage2State extends State<CollisionWarningPage2> {
  late Timer _timer;
  bool _isLeftBlinking = false;
  bool _isRightBlinking = false;
  bool _isTopBlinking = false;
  bool _isBottomBlinking = false;

  bool _cameraOn = false;
  bool _lightOn1 = false;
  bool _lightOn2 = false;
  bool _emergencyOn = false;
  bool _powerOn = false;

  final right_redPlayer = AudioPlayer();
  final rear_redPlayer = AudioPlayer();
  final left_redPlayer = AudioPlayer();
  final right_greenPlayer = AudioPlayer();
  final rear_greenPlayer = AudioPlayer();
  final left_greenPlayer = AudioPlayer();

  bool _redLightOn = false;
  bool _greenLightOn = false;

  void _toggleRedLight() {
    setState(() {
      _redLightOn = !_redLightOn;
      if (_redLightOn) {
        // turn red light on and play red audio
        // redPlayer2.setAsset('assets/warning_beep.mp3');
        // redPlayer2.play();
      } else {
        // turn red light off
        // redPlayer2.stop();
      }
    });
  }

  void _toggleGreenLight() {
    setState(() {
      _greenLightOn = !_greenLightOn;
      if (_greenLightOn) {
        // turn green light on and play green audio
        // greenPlayer.setAsset('assets/danger_beep.mp3');
        // greenPlayer.play();
      } else {
        // turn green light off
        // greenPlayer.stop();
      }
    });
  }


  //notificaiton variable
  late BluetoothDevice _device;
  BluetoothCharacteristic? _characteristic;
  BluetoothCharacteristic? _characteristic_write;
  Stream<List<int>>? _stream;
  String _value = '';
  bool isDataMatched = false;


  @override
  void initState() {
    super.initState();
    // _initializePlayers();
    _device = widget.device;
    _connectToDevice();
    _startBlinking();
  }

  Future<void> _connectToDevice() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = await service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        print("Check the properties");

        if (characteristic.uuid.toString() ==
            'beb5483e-36e1-4688-b7f5-ea07361b26a7') {
          _characteristic_write = characteristic;
          // break;
        }

        if (characteristic.properties.notify){
          if (characteristic.uuid.toString() ==
              'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
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
            // break;
          }
        }
      }
    }
    setState(() {
      _device = widget.device;
    });
  }

  // Send data part
  // Future<void> _sendData() async {
  //   if (_characteristic_write != null) {
  //     // final dataToSend = [0x02, 0x01, 0x10, 0xA, 0x02, 0x15, 0xF];
  //     final dataToSend = [0x02, 0x01, 0xC, 0x01, 0x10];
  //     // await characteristic!.write(dataToSend);
  //     await _characteristic_write!.write(utf8.encode(dataToSend.toString()));
  //     // Wait for the response from the BLE device
  //     final response = await _characteristic_write!.value.first;
  //     if (response.isNotEmp
  //     ty && response[0] == 0x01) {
  //       setState(() {
  //         isDataMatched = true;
  //       });
  //     }
  //   }
  // }

  // Future<void> _sendData() async {
  //   if (characteristic != null) {
  //     final dataToSend = [0x02, 0x01, 0xD, 0x01, 0x11];
  //     List<int> byteData = utf8.encode(dataToSend.toString());
  //     await characteristic!.write(byteData);
  //     // Wait for the response from the BLE device
  //     final response = await characteristic!.value.first;
  //   }
  // }

  //BYTE ARRAY
  // Future<void> _sendData(List<int> dataToSend) async {
  //   if (_characteristic_write != null) {
  //     List<int> byteData = dataToSend;
  //     await _characteristic_write!.write(byteData);
  //     // Wait for the response from the BLE device
  //     final response = await _characteristic_write!.value.first;
  //   }
  // }

  Future<void> _sendData(List<int> dataToSend) async {
    if (_characteristic_write != null) {
      Uint8List byteData = Uint8List.fromList(dataToSend);
      await _characteristic_write!.write(byteData);
      // Wait for the response from the BLE device
      final response = await _characteristic_write!.value.first;
    }
  }

  final _random = Random();
  int _generateRandomNumber(int min, int max) {
    return (min + (max - min) * _random.nextDouble()).toInt();
  }

  //Blinking funciton
  Timer? _leftBlinkTimer;
  Timer? _rightBlinkTimer;

  @override
  void dispose() {
    _leftBlinkTimer?.cancel();
    _rightBlinkTimer?.cancel();
    right_redPlayer.dispose();
    right_greenPlayer.dispose();
    rear_greenPlayer.dispose();
    rear_redPlayer.dispose();
    left_greenPlayer.dispose();
    left_redPlayer.dispose();
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
    if (_value.length < 29) {
      return 'Notification Not Available';
    }
    switch (int.parse(_value[28])) {
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
    if (_value.isEmpty || _value.length < 29) {
      return Colors.black;
    }
    switch (int.parse(_value[28])) {
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
      left_redPlayer.setAsset('assets/warning_beep.mp3');
      left_redPlayer.play();
    } else if (_getLocation() == 'Left Notification Warning') {
      color = Colors.yellow;
      left_greenPlayer.setAsset('assets/danger_beep.mp3');
      left_greenPlayer.play();
    } else {
      color = Colors.green;
      left_greenPlayer.stop();
      left_redPlayer.stop();
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
      right_redPlayer.setAsset('assets/warning_beep.mp3');
      right_redPlayer.play();
    } else if (_getLocation() == 'Right Notification Warning') {
      color = Colors.yellow;
      right_greenPlayer.setAsset('assets/danger_beep.mp3');
      right_greenPlayer.play();
    } else {
      // opacity = 0.0;
      color = Colors.green;
      right_redPlayer.stop();
      right_greenPlayer.stop();
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
      rear_redPlayer.setAsset('assets/warning_beep.mp3');
      rear_redPlayer.play();
    } else if (_getLocation() == 'Rear Notification Warning') {
      color = Colors.yellow;
      // greenPlayer.setAsset('assets/danger_beep.mp3');
      // greenPlayer.play();
    } else {
      color = Colors.green;
      rear_redPlayer.stop();
      rear_greenPlayer.stop();
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

  final _writeController = TextEditingController();

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

            // test data send

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  onPressed: () {
                    _sendData([0x02, 0x01, 0xD, 0x01, 0x11]);
                  },
                  // onPressed: showInfo,
                  child: const Text('Right button pressed'),
                ),
                const SizedBox(height: 16),
                if (isDataMatched)
                  const Text('Data matched')
                else
                  const Text('Data not matched'),
              ],
            ),

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
=======
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'warning_icons.dart';
import 'indicator_icons.dart';
import 'BlinkingIconButton.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:just_audio/just_audio.dart';

class CollisionWarningPage2 extends StatefulWidget {
  final BluetoothDevice device;

  const CollisionWarningPage2({Key? key, required this.device}) : super(key: key);
  // const CollisionWarningPage({Key? key}) : super(key: key);

  @override
  _CollisionWarningPage2State createState() => _CollisionWarningPage2State();
}

class _CollisionWarningPage2State extends State<CollisionWarningPage2> {
  late Timer _timer;
  bool _isLeftBlinking = false;
  bool _isRightBlinking = false;
  bool _isTopBlinking = false;
  bool _isBottomBlinking = false;

  bool _cameraOn = false;
  bool _lightOn1 = false;
  bool _lightOn2 = false;
  bool _emergencyOn = false;
  bool _powerOn = false;

  final right_redPlayer = AudioPlayer();
  final rear_redPlayer = AudioPlayer();
  final left_redPlayer = AudioPlayer();
  final right_greenPlayer = AudioPlayer();
  final rear_greenPlayer = AudioPlayer();
  final left_greenPlayer = AudioPlayer();

  bool _redLightOn = false;
  bool _greenLightOn = false;

  void _toggleRedLight() {
    setState(() {
      _redLightOn = !_redLightOn;
      if (_redLightOn) {
        // turn red light on and play red audio
        // redPlayer2.setAsset('assets/warning_beep.mp3');
        // redPlayer2.play();
      } else {
        // turn red light off
        // redPlayer2.stop();
      }
    });
  }

  void _toggleGreenLight() {
    setState(() {
      _greenLightOn = !_greenLightOn;
      if (_greenLightOn) {
        // turn green light on and play green audio
        // greenPlayer.setAsset('assets/danger_beep.mp3');
        // greenPlayer.play();
      } else {
        // turn green light off
        // greenPlayer.stop();
      }
    });
  }


  //notificaiton variable
  late BluetoothDevice _device;
  BluetoothCharacteristic? _characteristic;
  BluetoothCharacteristic? _characteristic_write;
  Stream<List<int>>? _stream;
  String _value = '';
  bool isDataMatched = false;


  @override
  void initState() {
    super.initState();
    // _initializePlayers();
    _device = widget.device;
    _connectToDevice();
    _startBlinking();
  }

  Future<void> _connectToDevice() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = await service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        print("Check the properties");

        if (characteristic.uuid.toString() ==
            'beb5483e-36e1-4688-b7f5-ea07361b26a7') {
          _characteristic_write = characteristic;
          // break;
        }

        if (characteristic.properties.notify){
          if (characteristic.uuid.toString() ==
              'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // Replace with the characteristic UUID for your device
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
            // break;
          }
        }
      }
    }
    setState(() {
      _device = widget.device;
    });
  }

  // Send data part
  // Future<void> _sendData() async {
  //   if (_characteristic_write != null) {
  //     // final dataToSend = [0x02, 0x01, 0x10, 0xA, 0x02, 0x15, 0xF];
  //     final dataToSend = [0x02, 0x01, 0xC, 0x01, 0x10];
  //     // await characteristic!.write(dataToSend);
  //     await _characteristic_write!.write(utf8.encode(dataToSend.toString()));
  //     // Wait for the response from the BLE device
  //     final response = await _characteristic_write!.value.first;
  //     if (response.isNotEmp
  //     ty && response[0] == 0x01) {
  //       setState(() {
  //         isDataMatched = true;
  //       });
  //     }
  //   }
  // }

  // Future<void> _sendData() async {
  //   if (characteristic != null) {
  //     final dataToSend = [0x02, 0x01, 0xD, 0x01, 0x11];
  //     List<int> byteData = utf8.encode(dataToSend.toString());
  //     await characteristic!.write(byteData);
  //     // Wait for the response from the BLE device
  //     final response = await characteristic!.value.first;
  //   }
  // }

  //BYTE ARRAY
  // Future<void> _sendData(List<int> dataToSend) async {
  //   if (_characteristic_write != null) {
  //     List<int> byteData = dataToSend;
  //     await _characteristic_write!.write(byteData);
  //     // Wait for the response from the BLE device
  //     final response = await _characteristic_write!.value.first;
  //   }
  // }

  Future<void> _sendData(List<int> dataToSend) async {
    if (_characteristic_write != null) {
      Uint8List byteData = Uint8List.fromList(dataToSend);
      await _characteristic_write!.write(byteData);
      // Wait for the response from the BLE device
      final response = await _characteristic_write!.value.first;
    }
  }

  final _random = Random();
  int _generateRandomNumber(int min, int max) {
    return (min + (max - min) * _random.nextDouble()).toInt();
  }

  //Blinking funciton
  Timer? _leftBlinkTimer;
  Timer? _rightBlinkTimer;

  @override
  void dispose() {
    _leftBlinkTimer?.cancel();
    _rightBlinkTimer?.cancel();
    right_redPlayer.dispose();
    right_greenPlayer.dispose();
    rear_greenPlayer.dispose();
    rear_redPlayer.dispose();
    left_greenPlayer.dispose();
    left_redPlayer.dispose();
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
    if (_value.length < 29) {
      return 'Notification Not Available';
    }
    switch (int.parse(_value[28])) {
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
    if (_value.isEmpty || _value.length < 29) {
      return Colors.black;
    }
    switch (int.parse(_value[28])) {
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
      left_redPlayer.setAsset('assets/warning_beep.mp3');
      left_redPlayer.play();
    } else if (_getLocation() == 'Left Notification Warning') {
      color = Colors.yellow;
      left_greenPlayer.setAsset('assets/danger_beep.mp3');
      left_greenPlayer.play();
    } else {
      color = Colors.green;
      left_greenPlayer.stop();
      left_redPlayer.stop();
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
      right_redPlayer.setAsset('assets/warning_beep.mp3');
      right_redPlayer.play();
    } else if (_getLocation() == 'Right Notification Warning') {
      color = Colors.yellow;
      right_greenPlayer.setAsset('assets/danger_beep.mp3');
      right_greenPlayer.play();
    } else {
      // opacity = 0.0;
      color = Colors.green;
      right_redPlayer.stop();
      right_greenPlayer.stop();
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
      rear_redPlayer.setAsset('assets/warning_beep.mp3');
      rear_redPlayer.play();
    } else if (_getLocation() == 'Rear Notification Warning') {
      color = Colors.yellow;
      // greenPlayer.setAsset('assets/danger_beep.mp3');
      // greenPlayer.play();
    } else {
      color = Colors.green;
      rear_redPlayer.stop();
      rear_greenPlayer.stop();
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

  final _writeController = TextEditingController();

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

            // test data send

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  onPressed: () {
                    _sendData([0x02, 0x01, 0xD, 0x01, 0x11]);
                  },
                  // onPressed: showInfo,
                  child: const Text('Right button pressed'),
                ),
                const SizedBox(height: 16),
                if (isDataMatched)
                  const Text('Data matched')
                else
                  const Text('Data not matched'),
              ],
            ),

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
>>>>>>> 7331559d8104a64967bf57b22226cfb8fec5fd9b
}