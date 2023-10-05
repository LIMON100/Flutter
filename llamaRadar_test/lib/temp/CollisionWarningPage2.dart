import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:lamaradar/mode/llamaGuardSetting.dart';
import 'package:lamaradar/provider/LedValuesProvider.dart';
import 'package:lamaradar/provider/PopupWindowProvider.dart';
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
import 'package:provider/provider.dart';
import 'package:lamaradar/provider/LedValuesProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // VlcPlayerController? _controller;
  bool isCameraStreaming = false;
  late VlcPlayerController _videoPlayerController;

  // Wifi connection
  final String ssid = ' ';
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
  bool _isFirstData = true;
  bool _isFirstDataRight = true;
  String _selectedOption = 'OFF';
  int blinkDurationMilliseconds = 10000;

  @override
  void initState() {
    super.initState();
    _scanWifiNetworks(context);
    _device = widget.device;
    _connectToDevice();
    _startBlinking();
    _loadRotationAngle();
    initializePlayer();
  }

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

  // For Lower android version
  void _startWifiScan(BuildContext context) async {
    print("Inside startscan");
    try {
      bool? isSuccess = await FlutterIotWifi.scan();
      if (isSuccess!) {
        // Wait for the scan process to complete
        await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed

        List<dynamic> networks = await FlutterIotWifi.list();
        print(networks);

        if (networks.isEmpty) {
          // Show a pop-up message when the networks list is empty
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text('No WiFi Networks Found'),
                content: Text(
                    "Can't find any WiFi network. Please connect to the WiFi named 'CARDV'."
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Show the list of available WiFi networks
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
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
                          Navigator.of(dialogContext).pop(); // Close the dialog after selection
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      } else {
        print('Failed to scan Wi-Fi networks');
        await Future.delayed(Duration(seconds: 6)); // Adjust the delay as needed
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
              'beb5483e-36e1-4688-b7f5-ea07361b26a8') {
            // _service = service;
            _characteristic = characteristic;

            // Enable notifications for the characteristic
            await _characteristic!.setNotifyValue(true);

            // Listen to the characteristic notifications
            _characteristic!.value.listen((value) {
              setState(() {
                _value = value.toString();
                print("VALUE");
                // List<String> hexList = intsToHexStrings(value);
                // List<String> hexList2 = hexList;
                print(_value);
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

  List<String> intsToHexStrings(List<int> intList) {
    List<String> hexList = [];

    for (int intValue in intList) {
      String hexString = intValue.toRadixString(16).toUpperCase().padLeft(2, '0');
      hexList.add(hexString);
    }
    return hexList;
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
      await _characteristic_write!.write(dataToSend);
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


  // void _startLeftBlinking() {
  //   if (_leftBlinkTimer != null) {
  //     _leftBlinkTimer!.cancel();
  //     _leftBlinkTimer = null;
  //     setState(() {
  //       _isLeftBlinking = false;
  //     });
  //   }
  //   else {
  //     _leftBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
  //       setState(() {
  //         _isLeftBlinking = !_isLeftBlinking;
  //       });
  //     });
  //     // Stop the blinking after 3 seconds
  //     Future.delayed(Duration(seconds: 30)).then((_) {
  //       _leftBlinkTimer?.cancel();
  //       setState(() {
  //         _isLeftBlinking = false;
  //       });
  //     });
  //   }
  // }

  // Test MPU with blinking
  void _startLeftBlinking() {
    if (_leftBlinkTimer != null) {
      print("INSIDE TIMER CHECK");
      _leftBlinkTimer!.cancel();
      _leftBlinkTimer = null;
      setState(() {
        _isLeftBlinking = false;
      });
    }
    else {
      // Timer is not running, start blinking
      if (_value.length > 46) {
        int? valueAtIndex46 = int.tryParse(_value[46] ?? '');

        if (valueAtIndex46 == 0) {
          blinkDurationMilliseconds = 10000;
        }
        else if (valueAtIndex46 == 1 || valueAtIndex46 == 2) {
          blinkDurationMilliseconds = 3000; // 3 seconds
        }
        else {
          // Handle other cases here if needed
          blinkDurationMilliseconds = 10000; // Default to 10 seconds
        }
      }

      _leftBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
        setState(() {
          _isLeftBlinking = !_isLeftBlinking;
        });
      });
    }
    // Stop the blinking after the specified duration
    Future.delayed(Duration(milliseconds: blinkDurationMilliseconds)).then((_) {
      _leftBlinkTimer?.cancel();
      _leftBlinkTimer = null;
      // BLink OFF
      _sendData([0x02, 0x01, 0x10, 0x00, 0x00, 0x19]);
      _isFirstData = true;
      setState(() {
        _isLeftBlinking = false;
      });
    });
  }



  // void _startRightBlinking() {
  //   if (_rightBlinkTimer != null) {
  //     _rightBlinkTimer!.cancel();
  //     _rightBlinkTimer = null;
  //     setState(() {
  //       _isRightBlinking = false;
  //     });
  //   } else {
  //     _rightBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
  //       setState(() {
  //         _isRightBlinking = !_isRightBlinking;
  //       });
  //     });
  //     // Stop the blinking after 3 seconds
  //     Future.delayed(Duration(seconds: 30)).then((_) {
  //       _rightBlinkTimer?.cancel();
  //       setState(() {
  //         _isRightBlinking = false;
  //       });
  //     });
  //   }
  // }


  // Test MPU with blinking
  void _startRightBlinking() {
    if (_rightBlinkTimer != null) {
      _rightBlinkTimer!.cancel();
      _rightBlinkTimer = null;
      setState(() {
        _isRightBlinking = false;
      });
    } else {
      int blinkDurationMilliseconds = 10000; // Default to 5 seconds

      if (_value.length > 46) {
        int? valueAtIndex46 = int.tryParse(_value[46] ?? '');

        switch (valueAtIndex46) {
          case 0:
            blinkDurationMilliseconds = 20000; // 20 seconds
            break;
          case 1:
          case 2:
            blinkDurationMilliseconds = 3000; // 3 seconds
            break;
        }
      }

      _rightBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
        setState(() {
          _isRightBlinking = !_isRightBlinking;
        });
      });

      // Stop the blinking after the specified duration
      Future.delayed(Duration(milliseconds: blinkDurationMilliseconds)).then((_) {
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

  //Problem
  // String _getLocation() {
  //   if (_value.length < 29) {
  //     return 'Notification Not Available';
  //   }
  //   switch (int.parse(_value[28])) {
  //     case 1:
  //       return 'Right Notification Warning';
  //     case 2:
  //       return 'Right Notification Danger';
  //     case 3:
  //       return 'Left Notification Warning';
  //     case 4:
  //       return 'Left Notification Danger';
  //     case 5:
  //       return 'Rear Notification Danger';
  //     default:
  //       return '';
  //   }
  // }


  String _getLocation() {
    // Check if _value is null or empty
    if (_value == null || _value.isEmpty || _value.length < 29) {
      return 'Notification Not Available';
    }

    // Extract the character at index 28 and parse it as an integer
    int locationCode;
    try {
      locationCode = int.parse(_value[28]);
    } catch (e) {
      return 'No Notification';
    }

    // Switch on the parsed integer
    switch (locationCode) {
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

  // Left/Right/Rear icon
  int right_danger_counter = 0;

  Widget _getLeftIcon() {
    double opacity = 1.0;
    Color color = Colors.red;

    if (_getLocation() == 'Left Notification Danger') {
      color = Colors.red;
      left_redPlayer.setAsset('assets/warning_beep.mp3');
      left_redPlayer.play();
    }
    else if (_getLocation() == 'Left Notification Warning') {
      color = Colors.yellow;
      left_greenPlayer.setAsset('assets/danger_beep.mp3');
      left_greenPlayer.play();
    }
    else {
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


  Widget _getRightIcon() {
    double opacity = 1.0;
    Color color = Colors.red;

    if (_getLocation() == 'Right Notification Danger') {
      color = Colors.red;
      right_redPlayer.setAsset('assets/warning_beep.mp3');
      right_redPlayer.play();
    }
    else if (_getLocation() == 'Right Notification Warning') {
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
    final popupState = Provider.of<PopupWindowProvider>(context, listen: false);

    if (_getLocation() == 'Rear Notification Danger') {
      color = Colors.red;
      rear_redPlayer.setAsset('assets/warning_beep.mp3');
      rear_redPlayer.play();
      if (right_danger_counter >= 5 && !isRearCamOpen) {
        if (popupState.isPopupWindowEnabled) {
          showStreamPopup();
        }
        right_danger_counter = 0;
      }
      right_danger_counter = right_danger_counter + 1;
    }
    else if (_getLocation() == 'Rear Notification Warning') {
      color = Colors.yellow;
    }
    else {
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
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          // VlcRtpOptions.rtpOverRtsp(true), // New method try and test
          VlcAdvancedOptions.networkCaching(0),
          VlcAdvancedOptions.clockJitter(0),
          VlcAdvancedOptions.fileCaching(0),
          VlcAdvancedOptions.liveCaching(0),
        ]),
      ),
    );
    await _videoPlayerController!.initialize();
  }

  // Can't close the pop-up window, it will run 5 seconds and then close
  // void showStreamPopup() {
  //   if (_controller == null) {
  //     return;
  //   }
  //   WidgetsBinding.instance!.addPostFrameCallback((_) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text('Rear Dashcam'),
  //               SizedBox(height: 16),
  //               Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 height: MediaQuery.of(context).size.width * 9 / 16,
  //                 child: VlcPlayer(
  //                   controller: _controller!,
  //                   aspectRatio: 16 / 9,
  //                 ),
  //               ),
  //               SizedBox(height: 16),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   // Navigator.of(context).pop();
  //                   // initializePlayer();
  //                   // Navigator.pop(context);
  //                   // Navigator.of(context).push(
  //                   //   MaterialPageRoute(
  //                   //       builder: (context) => CollisionWarningPage2(device: widget.device)),
  //                   //   );
  //                 },
  //                 child: Text('Close'),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   });
  //   Future.delayed(Duration(seconds: 5)).then((_) {
  //     Navigator.of(context).pop();
  //     initializePlayer();
  //   });
  // }

  // Can close pop-up window
  bool _isShowingPopup = false;
  void showStreamPopup() {
    if (_videoPlayerController == null) {
      return;
    }

    if (_isShowingPopup) {
      return;
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _isShowingPopup = true;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Rear Dashcam'),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 9 / 16,
                  child: VlcPlayer(
                    controller: _videoPlayerController!,
                    aspectRatio: 16 / 9,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _isShowingPopup = false;
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        },
      );
    });
    initializePlayer();
  }

  // camera open
  void toggleCameraStreaming() {
    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
    } else {
      Connectivity().onConnectivityChanged.listen((connectivity) {
        if (connectivity == ConnectivityResult.wifi) {
          _videoPlayerController = VlcPlayerController.network(
            'rtsp://192.168.1.254/xxxx.mp4',
            hwAcc: HwAcc.disabled,
            autoPlay: true,
            options: VlcPlayerOptions(
              advanced: VlcAdvancedOptions([
                VlcAdvancedOptions.networkCaching(0),
                VlcAdvancedOptions.clockJitter(0),
                VlcAdvancedOptions.fileCaching(0),
                VlcAdvancedOptions.liveCaching(0),
              ]),),
          );
          _videoPlayerController.initialize().then((_) {
            _videoPlayerController.play();
          });
        }
      });

      _videoPlayerController = VlcPlayerController.network(
        'rtsp://192.168.1.254/xxxx.mp4',
        hwAcc: HwAcc.disabled,
        autoPlay: true,
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(0),
            VlcAdvancedOptions.clockJitter(0),
            VlcAdvancedOptions.fileCaching(0),
            VlcAdvancedOptions.liveCaching(0),
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
    _videoPlayerController.dispose();
    super.dispose();
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

  bool isCustomSelected = false;

  List<int> calculateChecksum(List<int> data) {
    int csk = 0;
    for (int value in data) {
      csk += value;
    }
    int cskResult = csk % 256;
    data.add(cskResult); // Add the checksum to the end of the list
    return data;
  }

  // _send2data for multiple input
  void _sendData2(LedValuesProvider ledValuesProvider, bool isMilliseconds) {
    int leftLed = ledValuesProvider.leftLedValue.round();
    int rightLed = ledValuesProvider.rightLedValue.round();
    int turnOnTime = ledValuesProvider.turnOnTime.round();
    int turnOffTime = ledValuesProvider.turnOffTime.round();

    // Multiply by 60 if isMilliseconds is true
    if (isMilliseconds) {
      turnOnTime *= 1;
      turnOffTime *= 1;
    } else {
      turnOnTime *= 10000;
      turnOffTime *= 1000;
    }

    print('Left LED: $leftLed');
    print('Right LED: $rightLed');
    print('ON Time: $turnOnTime');
    print('OFF Time: $turnOffTime');

    // Ensure that turnOnTime and turnOffTime are within the expected range (0-65535)
    turnOnTime = turnOnTime.clamp(0, 65535);
    turnOffTime = turnOffTime.clamp(0, 65535);

    String onTimeHex = turnOnTime.toRadixString(16).toUpperCase();
    String offTimeHex = turnOffTime.toRadixString(16).toUpperCase();

    onTimeHex = onTimeHex.padLeft(4, '0');
    offTimeHex = offTimeHex.padLeft(4, '0');

    String on1 = onTimeHex.substring(0, 2);
    String on2 = onTimeHex.substring(2);

    String off1 = offTimeHex.substring(0, 2);
    String off2 = offTimeHex.substring(2);

    print([
      '0x02, 0x01, 0x12, 0x00',
      int.parse(on1, radix: 16),
      int.parse(on2, radix: 16),
      int.parse(off1, radix: 16),
      int.parse(off2, radix: 16),
      rightLed,
      leftLed,
      '0x01',
      '0x64',
    ]);

    List<int> data = [0x02, 0x01, 0x12, 0x00, int.parse(on1, radix: 16), int.parse(on2, radix: 16), int.parse(off1, radix: 16), int.parse(off2, radix: 16), rightLed, leftLed, 0x01];
    List<int> dataWithChecksum = calculateChecksum(data);
    print("Data with Checksum: ${dataWithChecksum.map((e) => "0x${e.toRadixString(16).toUpperCase()}").join(", ")}");
    _sendData(data);
  }


  bool isMilliseconds = false;
  bool isSwitched = false;
  double timeOnValue = 0.0;
  double timeOffValue = 0.0;
  double maxTimeOnValueSeconds = 6.0;
  double maxTimeOffValueSeconds = 60.0;
  double maxTimeOnValueMilliseconds = 1000.0;
  double maxTimeOffValueMilliseconds = 1000.0;
  static const String rotationAngleKey = 'rotation_angle';

  // Change camera orientation
  Orientation currentOrientation = Orientation.portrait;
  double rotationAngle = 0.0;

  void _loadRotationAngle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        rotationAngle = prefs.getDouble(rotationAngleKey) ?? 0.0;
      });
    } catch (e) {
      print("Error loading rotation angle: $e");
    }
  }

  void _saveRotationAngle(double angle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setDouble(rotationAngleKey, angle);
    } catch (e) {
      print("Error saving rotation angle: $e");
    }
  }

  void changeOrientation() {
    setState(() {
      rotationAngle += 90.0; // Rotate by 90 degrees
      if (rotationAngle >= 360.0) {
        rotationAngle = 0.0;
      }
      _saveRotationAngle(rotationAngle); // Save the new angle
    });
  }


  // Custom tailight dialog
  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final ledValuesProvider = Provider.of<LedValuesProvider>(context);
        return Center(
          child: Container(
            width: 400, // Set the desired width of the dialog
            child: AlertDialog(
              title: Center( // Center-align the title
                child: Text('Custom Options'),
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min, // Minimize the dialog size
                    children: [
                      Text('Left LED Brightness: ${ledValuesProvider.leftLedValue.toInt()}'),
                      Slider(
                        value: ledValuesProvider.leftLedValue,
                        min: 0,
                        max: 100,
                        onChanged: (newValue) {
                          setState(() {
                            ledValuesProvider.updateLeftLedValue(newValue);
                          });
                        },
                      ),
                      Text('Right LED Brightness: ${ledValuesProvider.rightLedValue.toInt()}'),
                      Slider(
                        value: ledValuesProvider.rightLedValue,
                        min: 0,
                        max: 100,
                        onChanged: (newValue) {
                          setState(() {
                            ledValuesProvider.updateRightLedValue(newValue);
                          });
                        },
                      ),
                      // Set Timer
                      Text('Time On: ${ledValuesProvider.turnOnTime.toInt()}'),
                      Slider(
                        value: ledValuesProvider.turnOnTime,
                        min: 0,
                        // max: isMilliseconds ? 1000 : 6,
                        max: isMilliseconds ? maxTimeOnValueMilliseconds : maxTimeOnValueSeconds,
                        onChanged: (newValue) {
                          setState(() {
                            ledValuesProvider.updateTurnOnTime(newValue);
                          });
                        },
                      ),
                      Text('Time Off: ${ledValuesProvider.turnOffTime.toInt()}'),
                      Slider(
                        value: ledValuesProvider.turnOffTime,
                        min: 0,
                        max: isMilliseconds ? maxTimeOffValueMilliseconds : maxTimeOffValueSeconds,
                        onChanged: (newValue) {
                          setState(() {
                            // ledValuesProvider.updateTurnOffTime(isMilliseconds ? newValue : newValue / 1000);
                            ledValuesProvider.updateTurnOffTime(newValue);
                          });
                        },
                      ),
                      // Time change slider
                      SizedBox(width: 16), //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('sec'),
                          Switch(
                            value: isMilliseconds,
                            onChanged: (value) {
                              setState(() {
                                isMilliseconds = value;
                                if (isMilliseconds) {
                                  ledValuesProvider.turnOnTime = 0.0;
                                  ledValuesProvider.turnOffTime = 0.0;
                                } else {
                                  ledValuesProvider.turnOnTime = 0.0;
                                  ledValuesProvider.turnOffTime = 0.0;
                                }
                              });
                            },
                          ),
                          Text('ms'),
                        ],
                      ),

                      SizedBox(width: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Reset the LED values to their defaults
                              ledValuesProvider.resetLedValues();
                            },
                            child: Text('Reset'),
                          ),
                          SizedBox(width: 16), // Add spacing between buttons
                          ElevatedButton(
                            onPressed: () {
                              _sendData2(ledValuesProvider, isMilliseconds); // Pass the ledValuesProvider
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final ledValuesProvider = Provider.of<LedValuesProvider>(context);
    Color screenColor = Theme.of(context).backgroundColor;
    return OrientationBuilder(
      builder: (context, orientation) {
        currentOrientation = orientation;
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
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LlamaGuardSetting(device: widget.device, selectedOption: _selectedOption)),
                    );
                  },
                ),
              ],
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
                            if (!_isLeftBlinking) {
                              _startLeftBlinking();
                              if (_isFirstData) {
                                _sendData([0x02, 0x01, 0x10, 0x00, 0x06, 0x19]);
                                _isFirstData = false;
                              }
                              else {
                                _sendData([0x02, 0x01, 0x10, 0x00, 0x00, 0x19]);
                                _isFirstData = true;
                              }
                            }
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
                            if (!_isRightBlinking) {
                              _startRightBlinking();
                              // Determine which data to send based on the state
                              if (_isFirstDataRight) {
                                _sendData([0x02, 0x01, 0x10, 0x00, 0x07, 0x19]);
                                _isFirstDataRight = false; // Toggle the state for the next press
                              } else {
                                _sendData([0x02, 0x01, 0x10, 0x00, 0x00, 0x19]);
                                _isFirstDataRight = true; // Toggle the state for the next press
                              }
                            }
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
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(width: 15),
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
                    Container(
                      margin: EdgeInsets.only(top: 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("_isLeftBlinking:: $_isLeftBlinking"),
                          Text("_isFirstData:: $_isFirstData"),
                        ],
                      ),
                    ),
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
                              // Column(
                              //   children: [
                              //     // ElevatedButton(onPressed: (){}, child: Text("Rear Cam")),
                              //     Icon(Icons.square),
                              //     Text('Camera'),
                              //   ],
                              // ),
                              SizedBox(width: 20),
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
                              SizedBox(width: 45),
                              // IconButton(
                              //   icon: Icon(_cameraOn ? Icons.camera_alt : Icons
                              //       .camera_alt_outlined),
                              //   onPressed: () {
                              //     setState(() {
                              //       _cameraOn = !_cameraOn;
                              //     });
                              //     // open camera if _cameraOn is true
                              //   },
                              // ),
                              SizedBox(width: 1),
                              IconButton(
                                icon: Icon(Icons.social_distance_rounded),
                                onPressed: () {
                                  _handleButtonPress();
                                  // _sendData([0x02, 0x01, 0xC, 0x01, 0x10]);
                                //  new Data
                                  _sendData([0x02, 0x01, 0x32, 0x00, 0x01, 0x36]);
                                },
                              ),
                              SizedBox(width: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(_tailight ? Icons.lightbulb : Icons.lightbulb_outline),
                                    onPressed: () {},
                                    padding: EdgeInsets.all(0), // Remove padding around the icon
                                  ),
                                  DropdownButton<String>(
                                    value: _selectedOption, // Set the selected option
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOption = value!; // Update the selected option
                                        switch (value) {
                                          case 'OFF':
                                            _sendData([0x02, 0x01, 0x10, 0x00, 0x00, 0x19]);
                                            break;
                                          case 'ON':
                                            _sendData([0x02, 0x01, 0x10, 0x00, 0x01, 0x19]);
                                            break;
                                          case 'FLASHING':
                                          // Send the command for FLASHING
                                            _sendData([0x02, 0x01, 0x10, 0x00, 0x02, 0x19]);
                                            break;
                                          case 'PULSE':
                                            _sendData([0x02, 0x01, 0x10, 0x00, 0x03, 0x19]);
                                            break;
                                          case 'PELOTON':
                                            _sendData([0x02, 0x01, 0x10, 0x00, 0x04, 0x19]);
                                            break;
                                          case 'QUICKLY_FLASH':
                                            _sendData([0x02, 0x01, 0x10, 0x00, 0x05, 0x19]);
                                            break;
                                          case 'CUSTOM':
                                            isCustomSelected = true;
                                            _showCustomDialog();
                                            break;
                                          default:
                                            isCustomSelected = false;
                                            break;
                                        }
                                      });
                                    },
                                    items: <String>['OFF', 'ON', 'FLASHING', 'PULSE', 'PELOTON', 'QUICKLY_FLASH', 'CUSTOM']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
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
                      ],
                    ),
                    // Container(
                    //   height: 280,
                    //   width: 300,
                    //   child: isCameraStreaming && _videoPlayerController != null
                    //       ? Transform.rotate(
                    //     angle: rotationAngle * 3.14159265359 / 180,
                    //     // Apply rotation based on user choice
                    //     child: VlcPlayer(
                    //       controller: _videoPlayerController,
                    //       aspectRatio: currentOrientation == Orientation.portrait
                    //           ? 16 / 9
                    //           : 9 / 16,
                    //     ),
                    //   )
                    //       : Image.asset(
                    //     'images/test_background3.jpg',
                    //     fit: BoxFit.fitWidth,
                    //   ),
                    // ),
                    // if (isCameraStreaming)
                    //   Positioned(
                    //     bottom: 16.0,
                    //     right: 16.0,
                    //     child: IconButton(
                    //       color: Colors.red,
                    //       icon: Icon(Icons.cameraswitch_outlined),
                    //       // You can choose a different icon
                    //       onPressed: changeOrientation,
                    //       iconSize: 40.0, // Adjust the icon size as needed
                    //     ),
                    //   ),
                    SizedBox(width:50),
                    Container(
                      height: 280,
                      width: 300,
                      child: Center(
                        child: Stack(
                          children: [
                            isCameraStreaming && _videoPlayerController != null
                                ? Transform.rotate(
                              angle: rotationAngle * 3.14159265359 / 180,
                              child: VlcPlayer(
                                controller: _videoPlayerController,
                                aspectRatio: currentOrientation == Orientation.portrait
                                    ? 16 / 9
                                    : 9 / 16,
                              ),
                            )
                                : Image.asset(
                              'images/test_background3.jpg',
                              fit: BoxFit.fitWidth,
                            ),
                            if (isCameraStreaming)
                              Positioned(
                                bottom: 16.0,
                                right: 16.0,
                                child: IconButton(
                                  color: Colors.red,
                                  icon: Icon(Icons.cameraswitch_outlined),
                                  onPressed: changeOrientation,
                                  iconSize: 40.0,
                                ),
                              ),
                          ],
                        ),
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
                              _sendData([0x02, 0x01, 0x53, 0x00, 0x01, 0x57]);
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