import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'glowing_button.dart';
import 'warning_icons.dart';
import 'indicator_icons.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';

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

  bool _cameraOn = false;
  bool _tailight = false;
  bool _powerOn = false;

  final right_redPlayer = AudioPlayer();
  final rear_redPlayer = AudioPlayer();
  final left_redPlayer = AudioPlayer();
  final right_greenPlayer = AudioPlayer();
  final rear_greenPlayer = AudioPlayer();
  final left_greenPlayer = AudioPlayer();


  // for popup dashcam windows
  VlcPlayerController? _controller;
  bool isCameraStreaming = false;

  // Wifi connection
  final String ssid = "CARDV";
  final String password = "12345678";
  List<String> availableNetworks = [];

  //notificaiton variable
  late BluetoothDevice _device;
  BluetoothCharacteristic? _characteristic;
  BluetoothCharacteristic? _characteristic_write;
  Stream<List<int>>? _stream;
  String _value = '';
  bool isDataMatched = false;
  bool _isDisconnected = false;
  bool isConnected = false;
  List<dynamic> wifiNetworks = [];
  bool isRearCamOpen = false;


  @override
  void initState() {
    super.initState();
    _scanWifiNetworks(context);
    _device = widget.device;
    _connectToDevice();
    _startBlinking();
    initializePlayer();
  }

  // check wifi connected or not

  // wifi connection
  Future<bool> _checkPermissions() async {
    if (Platform.isIOS || await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }

  void _scanWifiNetworks(BuildContext context) async {
    if (isConnected) {
      FlutterIotWifi.disconnect().then((value) {
        setState(() {
          isConnected = false;
        });
        print("Disconnect initiated: $value");

        // Start the Wi-Fi scan after disconnecting
        _startWifiScan(context);
      });
    } else if (await _checkPermissions()) {
      // Start the Wi-Fi scan directly
      _startWifiScan(context);
    }
  }

  void _startWifiScan(BuildContext context) async {
    try {
      bool? isSuccess = await FlutterIotWifi.scan();
      if (isSuccess!) {
        // Wait for the scan process to complete
        await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed

        List<dynamic> networks = await FlutterIotWifi.list();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                width: 300, // Adjust the width as needed
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: networks.length,
                  itemBuilder: (context, index) {
                    final wifiNetwork = networks[index];
                    return ListTile(
                      title: Text(wifiNetwork.toString()),
                      onTap: () {
                        _connect(context, wifiNetwork.toString());
                        Navigator.of(context).pop(); // Close the dialog after selection
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      } else {
        print('Failed to scan Wi-Fi networks');
        await Future.delayed(Duration(seconds: 10)); // Adjust the delay as needed
        _startWifiScan(context);
      }
    } catch (e) {
      print('Failed to scan Wi-Fi networks: $e');
    }
  }

  // Try with dialog window
  void _connect(BuildContext context, String ssid) async {
    if (await _checkPermissions()) {
      if (isConnected) {
        FlutterIotWifi.disconnect().then((value) {
          setState(() {
            isConnected = false;
          });
          print("Disconnect initiated: $value");
        });
      } else {
        FlutterIotWifi.connect(ssid, password).then((value) {
          setState(() {
            isConnected = true;
          });
          print("Connect initiated: $value");
        });
      }
      // Delay the pop to ensure the connection process is completed
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the dialog window
      });
    } else {
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

  // BLE notification
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

  // Disconnect BLE
  void _disconnectFromDevice() {

    setState(() {
      _isDisconnected = true;
    });

    // Perform the disconnection logic asynchronously
    _performDisconnection();
  }

  Future<void> _performDisconnection() async {
    await widget.device.disconnect();
    print('Disconnected from ${widget.device.name}');
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
        return 'Left Notification Warning';
      case 4:
        return 'Left Notification Danger';
      case 5:
        return 'Rear Notification Danger';
      default:
        return '';
    }
  }

  // String _getLocation() {
  //   if (_value.length > 33) {
  //     return 'Notification Not Available';
  //   }
  //   switch (_value[28]) {
  //     case "1":
  //       return 'Right Notification Warning';
  //     case "2":
  //       return 'Right Notification Danger';
  //     case "3":
  //       return 'Left Notification Warning';
  //     case "4":
  //       return 'Left Notification Danger';
  //     case "5":
  //       return 'Rear Notification Danger';
  //     default:
  //       return '';
  //   }
  // }

  //TEST MULTIPLE NOTIFICATION
  // String _getLocation() {
  //   if (_value.length < 33) {
  //     return 'Notification Not Available';
  //   }
  //   switch (_value[30] + _value[31]) {
  //     case "33":
  //       return 'Left Notification Warning';
  //     case "34":
  //       return 'Right Notification Warning';
  //     case "36":
  //       return 'Rear Notification Warning';
  //     case "40":
  //       return 'Front Notification Warning';
  //
  //     case "65":
  //       return 'left Notification Danger';
  //     case "66":
  //       return 'Right Notification Danger';
  //     case "68":
  //       return 'Rear Notification Danger';
  //     case "72":
  //       return 'Front Notification Danger';
  //
  //     default:
  //       return 'Safe';
  //   }
  // }

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
      duration: Duration(milliseconds: 300),
      opacity: opacity,
      // child: Icon(Icons.arrow_back, color: color),
      child: Container(
        height: 48,
        color: Colors.transparent,
        child: Image.asset(
          'assets/icons/left_warning_llama_rb.png',
          color: color,
        ),
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
      duration: Duration(milliseconds: 300),
      opacity: opacity,

      child: Container(
        height: 48,
        color: Colors.transparent,
        child: Image.asset(
          'assets/icons/right_warning_llama_rb.png',
          color: color,
        ),
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
      if (right_danger_counter >= 2 && !isRearCamOpen) {
        // showStreamPopup();
        right_danger_counter = 0;
      }
      right_danger_counter = right_danger_counter + 1;
      // print("FIND RIGHT NOTIFICAITON COUNTER");
      // print(right_danger_counter);
      // print(isRearCamOpen);
    } else if (_getLocation() == 'Rear Notification Warning') {
      color = Colors.yellow;
    } else {
      color = Colors.green;
      rear_redPlayer.stop();
      rear_greenPlayer.stop();
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: opacity,
      child: Container(
        height: 48,
        color: Colors.transparent,
        child: Image.asset(
          'assets/icons/rear_warning_llama_rb.png',
          color: color,
        ),
      ),
    );
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
        _isBlinkingIcon3 = (int.tryParse(_value[15]) == 9) ? !_isBlinkingIcon3 : false;
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
    _controller = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4?network-caching=0?clock-jitter=0?clock-synchro=0',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(0),
        ]),),
    );

    await _controller!.initialize();
  }


  void showStreamPopup() {
    if (_controller == null) {
      return;
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Rear Dashcam'),
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

  // camera open
  late VlcPlayerController _videoPlayerController;

  void toggleCameraStreaming() {
    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
    } else {
      Connectivity().onConnectivityChanged.listen((connectivity) {
        if (connectivity == ConnectivityResult.wifi) {
          _videoPlayerController = VlcPlayerController.network(
            'rtsp://192.168.1.254/xxxx.mp4?network-caching=0?clock-jitter=0?clock-synchro=0',
            hwAcc: HwAcc.disabled,
            autoPlay: true,
            options: VlcPlayerOptions(
              advanced: VlcAdvancedOptions([
                VlcAdvancedOptions.networkCaching(0),
              ]),),
          );
          _videoPlayerController.initialize().then((_) {
            _videoPlayerController.play();
          });
        }
      });

      _videoPlayerController = VlcPlayerController.network(
        'rtsp://192.168.1.254/xxxx.mp4?network-caching=0?clock-jitter=0?clock-synchro=0',
        hwAcc: HwAcc.disabled,
        autoPlay: true,
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(0),
          ]),),
      );
      _videoPlayerController.initialize().then((_) {
        _videoPlayerController.play();
      });
    }

    setState(() {
      isCameraStreaming = !isCameraStreaming;
      isRearCamOpen = !isRearCamOpen;
    });
  }



  Widget buildCameraButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: ElevatedButton(
          onPressed: toggleCameraStreaming,
          style: ElevatedButton.styleFrom(
            primary: isCameraStreaming ? Colors.red : Colors.cyan.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: Text(
            isCameraStreaming ? 'Stop Rear Camera' : 'Open Rear Cam',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Color screenColor = Theme.of(context).backgroundColor;
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
                margin: EdgeInsets.only(top: 15),
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
                        Container(
                          height: 48,
                          color: Colors.transparent,
                          child: Image.asset(
                            'assets/icons/front_warning_llama_rb.png',
                            color: _isTopBlinking ? Colors.red : Colors.green,
                          ),
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
                    SizedBox(height: 30),
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

                    // Rear warning
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.only(top: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _getRearIcon(),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 1),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       // Text(_value[30]),
                    //       Text(_value[30] + _value[31]),
                    //       // Text(_value[31]),
                    //       // Text(_value[32]),
                    //     ],
                    //   ),
                    // ),
                    // Blink icon for tailight, camera and distance
                    //CAM+Tailight+Distance button
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  // ElevatedButton(onPressed: (){}, child: Text("Rear Cam")),
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
                                icon: Icon(_tailight ? Icons.lightbulb : Icons
                                    .lightbulb_outline),
                                onPressed: () {
                                  setState(() {
                                    _tailight = !_tailight;
                                    // _sendData([0x02, 0x01, 0xD, 0x01, 0x11]);
                                    //New data
                                    // _sendData([0x02, 0x01, 0x45, 0x00, 0x01, 0x49]);
                                    _sendData([0x02, 0x01, 0x41, 0x00, 0x01, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x61]);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Open rear up cam
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCameraButton(),
                        // SizedBox(width: 10),
                        // Dashcam
                      ],
                    ),
                    Container(
                      height: 200,
                      width: 300,
                      child: isCameraStreaming && _videoPlayerController != null
                      //     ? VlcPlayer(
                      //   controller: _videoPlayerController,
                      //   aspectRatio: 16 / 9,
                      //   placeholder: Center(child: CircularProgressIndicator()),
                      // )
                          ? Transform.rotate(
                        angle: 3.14159,
                        alignment: Alignment.center,
                        child: VlcPlayer(
                          controller: _videoPlayerController,
                          aspectRatio: 16 / 9,
                          placeholder: Center(child: CircularProgressIndicator()),
                        ),
                      )
                          : Image.asset(
                        'images/test_background3.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    // Stop ride
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(width: 50),
                        GlowingButton2(
                          text: "Stop Ride",
                          onPressed: () {
                            _disconnectFromDevice();
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
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.only(top: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 120),
                          Container(
                            color: Colors.transparent,
                            child: Image.asset(
                              'images/llama_img_web3_rb.png',
                              height: 100,
                              width: 130,
                            ),
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
                      ),
                    ),
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