import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'BlinkingIconsButton.dart';
import 'glowing_button.dart';
import 'warning_icons.dart';
import 'indicator_icons.dart';
import 'BlinkingIconButton.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';

class CollisionWarningPage2 extends StatefulWidget {
  final BluetoothDevice device;

  const CollisionWarningPage2({Key? key, required this.device}) : super(key: key);

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

  // for popup dashcam windows
  // late Timer _timer;
  VlcPlayerController? _controller;

  // Wifi connection
  final String ssid = "Limonn_mob"; // TODO replace with your ssid  Mahmudur @ SF Networking
  final String password = "limon1234"; // TODO replace with your password


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
    _connect();
    _device = widget.device;
    _connectToDevice();
    _startBlinking();
    initializePlayer();
  }

  // wifi connection

  Future<bool> _checkPermissions() async {
    if (Platform.isIOS || await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }

  void _connect() async {
    if (await _checkPermissions()) {
      FlutterIotWifi.connect(ssid, password, prefix: true).then((value) => print("connect initiated: $value"));
    }
    // else {
    //   print("don't have permission");
    // }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Error'),
            content: Text('Please turn on Wi-Fi first.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
  Future<void> _sendData(List<int> dataToSend) async {
    if (_characteristic_write != null) {
      // List<int> byteData = utf8.encode(dataToSend);
      await _characteristic_write!.write(dataToSend);
      // Wait for the response from the BLE device
      final response = await _characteristic_write!.value.first;
    }
  }

  //BYTE ARRAY

  // Future<void> _sendData(List<int> dataToSend) async {
  //   if (_characteristic_write != null) {
  //     Uint8List byteData = Uint8List.fromList(dataToSend);
  //     await _characteristic_write!.write(byteData);
  //     // Wait for the response from the BLE device
  //     final response = await _characteristic_write!.value.first;
  //   }
  // }

  final _random = Random();
  int _generateRandomNumber(int min, int max) {
    return (min + (max - min) * _random.nextDouble()).toInt();
  }

  //Blinking funciton
  Timer? _leftBlinkTimer;
  Timer? _rightBlinkTimer;


  void _startLeftBlinking() {
    if (_leftBlinkTimer != null) {
      _leftBlinkTimer!.cancel();
      _leftBlinkTimer = null;
      setState(() {
        _isLeftBlinking = false;
      });
    } else {
      _leftBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
        setState(() {
          _isLeftBlinking = !_isLeftBlinking;
        });
      });
      // Stop the blinking after 3 seconds
      Future.delayed(Duration(seconds: 30)).then((_) {
        _leftBlinkTimer?.cancel();
        setState(() {
          _isLeftBlinking = false;
        });
      });
    }
  }

  void _startRightBlinking() {
    if (_rightBlinkTimer != null) {
      _rightBlinkTimer!.cancel();
      _rightBlinkTimer = null;
      setState(() {
        _isRightBlinking = false;
      });
    } else {
      _rightBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
        setState(() {
          _isRightBlinking = !_isRightBlinking;
        });
      });
      // Stop the blinking after 3 seconds
      Future.delayed(Duration(seconds: 30)).then((_) {
        _rightBlinkTimer?.cancel();
        setState(() {
          _isRightBlinking = false;
        });
      });
    }
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
    // showStreamPopup();

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

  int right_danger_counter = 0;
  Widget _getRightIcon() {
    double opacity = 1.0;
    Color color = Colors.red;
    if (_getLocation() == 'Right Notification Danger') {
      color = Colors.red;
      right_redPlayer.setAsset('assets/warning_beep.mp3');
      right_redPlayer.play();
    } else if (_getLocation() == 'Right Notification Warning') {
      if (right_danger_counter >= 6) {
        showStreamPopup();
        right_danger_counter = 0;
      }
      right_danger_counter = right_danger_counter + 1;
      print("FIND RIGHT NOTIFICAITON COUNTER");
      print(right_danger_counter);
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

  // blink for distance
  void _startBlinking2(int value) {
    Timer _blinkTimer;
    bool _isBlinking = false;

    _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        _isBlinking = !_isBlinking;
      });
    });

    // Stop the blinking after 3 seconds
    Future.delayed(Duration(seconds: 3)).then((_) {
      _blinkTimer?.cancel();
      setState(() {
        _isBlinking = false;
      });
    });
  }

  bool _isBlinkingIcon1 = false;
  bool _isBlinkingIcon2 = false;
  bool _isBlinkingIcon3 = false;

  void _startBlinking3() {
    Timer _blinkTimer;
    bool _isBlinking = false;

    _blinkTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _isBlinkingIcon1 = (int.tryParse(_value[15]) == 3) ? !_isBlinkingIcon1 : false;
        _isBlinkingIcon2 = (int.tryParse(_value[15]) == 6) ? !_isBlinkingIcon2 : false;
        _isBlinkingIcon3 = (int.tryParse(_value[15]) == 9) ? !_isBlinkingIcon1 : false;
        _isBlinking = !_isBlinking;
      });
    });
    // Stop the blinking after 3 seconds
    Future.delayed(Duration(seconds: 3)).then((_) {
      _blinkTimer?.cancel();
      setState(() {
        _isBlinking = false;
      });
    });
  }


  void _handleButtonPress() {
    if (int.tryParse(_value[15]) == 3 || int.tryParse(_value[15]) == 6 || int.tryParse(_value[15]) == 9) {
      _startBlinking3();
    }
  }

  // Open pop-up window for dashcam rear warning
  Future<void> initializePlayer() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }

    _controller = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mov',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    await _controller!.initialize();
  }

  // void showStreamPopup() async {
  //   if (_controller == null) {
  //     return;
  //   }
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('RTSP Stream'),
  //             SizedBox(height: 16),
  //             Container(
  //               width: MediaQuery.of(context).size.width,
  //               height: MediaQuery.of(context).size.width * 9 / 16,
  //               child: VlcPlayer(
  //                 controller: _controller!,
  //                 aspectRatio: 16 / 9,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //
  //   // Close the pop-up window after 4 seconds
  //   await Future.delayed(Duration(seconds: 4));
  //   Navigator.of(context).pop();
  //
  //   // Terminate the current VlcPlayerController
  //   await initializePlayer();
  // }

  void showStreamPopup() {
    if (_controller == null) {
      return;
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Dashcam'),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 9 / 16,
                  child: VlcPlayer(
                    controller: _controller!,
                    aspectRatio: 16 / 9,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    // initializePlayer();
                    // Navigator.pop(context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //       builder: (context) => CollisionWarningPage2(device: widget.device)),
                    //   );
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        },
      );
      // ).then((_) {
      //   // Close the pop-up window after 4 seconds
      //   Future.delayed(Duration(seconds: 5)).then((_) {
      //     Navigator.of(context).pop();
      //   });
      // });
    });
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.of(context).pop();
      initializePlayer();
    });
  }


  // Dispose function
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
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
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
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Top warning+indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _startLeftBlinking();
                            _sendData([0x02, 0x01, 0xA, 0x01, 0xE]);
                          },
                          icon: Icon(
                            Indicator.image2vector,
                            size: 48,
                            color: _isLeftBlinking ? Colors.orange : Colors.black,
                          ),
                        ),

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
                            _sendData([0x02, 0x01, 0xA, 0x02, 0xF]);
                          },
                          icon: Icon(
                            Indicator.image2vector__1_,
                            size: 48,
                            color: _isRightBlinking ? Colors.orange : Colors.black,
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
                            icon: Icon(_lightOn1 ? Icons.lightbulb : Icons
                                .lightbulb_outline),
                            onPressed: () {
                              setState(() {
                                _lightOn1 = !_lightOn1;
                              });
                            }
                        ),
                        SizedBox(width: 140),
                        IconButton(
                            icon: Icon(_lightOn2 ? Icons.lightbulb : Icons
                                .lightbulb_outline),
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

                    // Blink icon for tailight, camera and distance
                    //CAM+Tailight+Distance button
                    SizedBox(width: 1),

                    // Test distance
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.square),
                                Text('Camera'),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Icon(
                                  Icons.square,
                                  size: 40,
                                  color: _isBlinkingIcon1 ? Colors.red : Colors
                                      .black,
                                ),
                                Text(
                                  '30M',
                                  style: TextStyle(
                                    color: _isBlinkingIcon1 ? Colors.red : Colors
                                        .black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Icon(
                                  Icons.square,
                                  size: 40,
                                  color: _isBlinkingIcon2 ? Colors.red : Colors
                                      .black,
                                ),
                                Text(
                                  '60M',
                                  style: TextStyle(
                                    color: _isBlinkingIcon2 ? Colors.red : Colors
                                        .black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Icon(
                                  Icons.square,
                                  size: 40,
                                  color: _isBlinkingIcon3 ? Colors.red : Colors
                                      .black,
                                ),
                                Text(
                                  '90M',
                                  style: TextStyle(
                                    color: _isBlinkingIcon3 ? Colors.red : Colors
                                        .black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(_cameraOn ? Icons.camera_alt : Icons
                                  .camera_alt_outlined),
                              onPressed: () {
                                setState(() {
                                  _cameraOn = !_cameraOn;
                                  _sendData([0x02, 0x01, 0xB, 0x01, 0xF]);
                                });
                                // open camera if _cameraOn is true
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.social_distance_rounded),
                              onPressed: () {
                                _handleButtonPress();
                                _sendData([0x02, 0x01, 0xC, 0x01, 0x10]);
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(_lightOn1 ? Icons.lightbulb : Icons
                                  .lightbulb_outline),
                              onPressed: () {
                                setState(() {
                                  // _lightOn1 = !_lightOn1;
                                  _sendData([0x02, 0x01, 0xD, 0x01, 0x11]);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Stop ride
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(width: 50),
                        GlowingButton2(
                          text: "Stop Ride",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  BleScreen(title: '',)),
                            );
                          },
                          color1: Color(0xFF517fa4),
                          color2: Colors.cyan,
                        ),
                      ],
                    ),
                    // Image with power button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 120),
                        Image.asset(
                          'images/llama_img_web2.jpg',
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
            ),
          ),
        );
      }
    );
  }
}