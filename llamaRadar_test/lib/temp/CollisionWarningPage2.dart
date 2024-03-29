import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:lamaradar/mode/llamaGuardSetting.dart';
import 'package:lamaradar/provider/LedValuesProvider.dart';
import 'package:lamaradar/provider/PopupWindowProvider.dart';
import '../ride_history/showGpsData.dart';
import '../sqflite/sqlite.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:intl/intl.dart';
import 'package:lamaradar/ride_history/mapView.dart';


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
  double _sliderValue = 0.0;
  int _selectedValue = 10;
  final sliderLabels = [10, 30, 60, 90];
  bool isButtonEnabled = true;
  bool isCameraAnimation = false;

  // For gps coordinates database
  String? _currentAddress;
  Position? _currentPosition;
  ScreenshotController screenshotController = ScreenshotController();
  late String imagePath = '';
  var now = DateTime.now();
  var formatterDate = DateFormat('yyyy-MM-dd');
  var formatterTime = DateFormat('HH:mm:ss');
  Map<String, String>? dateTime;
  Uint8List? capturedImage;

  // Helper for database
  GpsDatabaseHelper helper = GpsDatabaseHelper();
  bool dataInserted = false;
  bool _dangerWarningCalled = false;


  @override
  void initState() {
    super.initState();
    dateTime = {};
    // getCurrentDateTime();
    _scanWifiNetworks(context);
    _device = widget.device;
    _connectToDevice();
    _startBlinking();
    _loadRotationAngle();
    initializePlayer();
  }

  // ------------------Start GPS data processing-----------------
  // current date and time
  int dt = 0;
  int cpos = 0;
  int ss = 0;
  void getCurrentDateTime() {
    print("dt $dt");
    dateTime!['date'] = formatterDate.format(now);
    dateTime!['time'] = formatterTime.format(now);
    dt = dt + 1;
  }

  Future<void> _getCurrentPosition() async {
    print("cpos $cpos");
    cpos = cpos + 1;
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });

    // When navigating away, cancel the operation
    if (Navigator.canPop(context)) {
      completer.completeError('Navigation canceled');
    }
    return completer.future;
  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // Save Screenshot
  Future<void> _saveScreenshot() async {
    print("ss $ss");
    ss = ss + 1;
    capturedImage = await screenshotController.capture();
  }


  Future<String> saveImageTo(Uint8List bytes) async {
    await Permission.storage.request();
    final time = DateTime.now()
        .toString()
        .replaceAll('.', '-')
        .replaceAll(':', '-')
        .replaceAll(' ', '_');
    final name = 'screenshot$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    imagePath = result['filePath'];
    print("IMAGE");
    print(name);
    return result['filePath'];
  }

  // List<Map<String, dynamic>> getDemoData(){
  //   return [
  //     {
  //       "latitude": _currentPosition?.latitude,
  //       "longitude": _currentPosition?.longitude,
  //       "image": capturedImage,
  //       "date": dateTime!['date'].toString(),
  //       "time": dateTime!['time'].toString()
  //     },
  //   ];
  // }
  //
  // // GpsDatabaseHelper helper = GpsDatabaseHelper();
  // Future<void> insertDemoData() async {
  //   for(Map<String, dynamic> row in getDemoData()) {
  //     await helper.insertCoordinates(row);
  //   }
  // }

  // TEST SAVE SINGLE DATA
  Map<String, dynamic> getDemoData() {
    return {
      "latitude": _currentPosition?.latitude,
      "longitude": _currentPosition?.longitude,
      "image": capturedImage,
      "date": dateTime!['date'].toString(),
      "time": dateTime!['time'].toString()
    };
  }
  //

  Future<void> insertDemoData() async {
    if(_dangerWarningCalled) {
      Map<String, dynamic> demoData = getDemoData();
      await helper.insertCoordinates(demoData);
      _dangerWarningCalled = false;
=======
  int da = 0;
  Future<void> insertDemoData() async {
    if(_dangerWarningCalled) {
      print("insertData $da");
      print(da);
      Map<String, dynamic> demoData = getDemoData();
      await helper.insertCoordinates(demoData);
      _dangerWarningCalled = false;
      da = da + 1;
    }
  }
  // ------------------End GPS data processing-----------------

  // Future<void> liveViewState() async {
  //   final response = await http
  //       .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2015&par=1'));
  //   if (response.statusCode == 200) {
  //     //fileList = json.decode(response.body);
  //     print('HDR');
  //   } else {
  //     print('Cam error: ${response.statusCode}');
  //   }
  // }

  // Future<void> stopRecordState() async {
  //   final response = await http
  //       .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2001&par=0'));
  //   if (response.statusCode == 200) {
  //     //fileList = json.decode(response.body);
  //     print('HDR');
  //   } else {
  //     print('Cam error: ${response.statusCode}');
  //   }
  // }

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
    try {
      bool? isSuccess = await FlutterIotWifi.scan();
      if (isSuccess!) {
        // Wait for the scan process to complete
        await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed

        List<dynamic> networks = await FlutterIotWifi.list();
        // print(networks);

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
        // print("Check the properties");

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
                // print("Value");
                // print(_value);
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


  // MPU with blinking
  void _startLeftBlinking() {
    if (_leftBlinkTimer != null) {
      _leftBlinkTimer!.cancel();
      _leftBlinkTimer = null;
      setState(() {
        _isLeftBlinking = false;
      });
    }
    else {
      if (_value.length > 40) {
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
      if(!_isFirstData){
        _sendData([0x02, 0x01, 0x10, 0x00, 0x00, 0x19]);
        _isFirstData = true;
      }
      setState(() {
        _isLeftBlinking = false;
      });
    });
  }

  // MPU with blinking
  void _startRightBlinking() {
    if (_rightBlinkTimer != null) {
      _rightBlinkTimer!.cancel();
      _rightBlinkTimer = null;
      setState(() {
        _isRightBlinking = false;
      });
    }
    else {
      if (_value.length > 40) {
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

      _rightBlinkTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
        setState(() {
          _isRightBlinking = !_isRightBlinking;
        });
      });
    }

    // Stop the blinking after the specified duration
    Future.delayed(Duration(milliseconds: blinkDurationMilliseconds)).then((_) {
      _rightBlinkTimer?.cancel();
      _rightBlinkTimer = null;
      // BLink OFF
      if(!_isFirstDataRight){
        _sendData([0x02, 0x01, 0x10, 0x00, 0x00, 0x19]);
        _isFirstDataRight = true;
      }
      setState(() {
        _isRightBlinking = false;
      });
    });
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
    if (_value == null || _value.isEmpty || _value.length < 29) {
      return 'Notification Not Available';
    }

    // Extract the character at index 28 and parse it as an integer
    int locationCode;
    try {
      locationCode = int.parse(_value[27]); //_value[28]=test, _value[27]=real Radar data

      locationCode = int.parse(_value[28]); //_value[28]=test, _value[27]=real Radar data
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

  // Test insertDemodatacalling
  bool _isGpsDataCallScheduled = false;
  void callGpsData(){
    if (!_isGpsDataCallScheduled) {
      _isGpsDataCallScheduled = true;

      _gpsDataTimer = Timer(Duration(milliseconds: 300), () {
        getCurrentDateTime();
        _getCurrentPosition();

  int callGPS = 0;
  bool _isGpsDataCallScheduled = false;
  void callGpsData(){
    // Save value gps coordinates and images
    if (!_isGpsDataCallScheduled) {
      _isGpsDataCallScheduled = true;

      Timer(Duration(seconds: 1), () {
        print('Calling GPS data...');

        _getCurrentPosition();
        getCurrentDateTime();
        _saveScreenshot();
        insertDemoData();
        _isGpsDataCallScheduled = false;
      });
    }
  }

  Widget _getLeftIcon() {
    double opacity = 1.0;
    Color color = Colors.red;

    String location = _getLocation();

    if (location == 'Left Notification Danger') {
      _dangerWarningCalled = true;
      color = Colors.red;
      left_redPlayer.setAsset('assets/danger3.mp3');
      left_redPlayer.play();

      print("callGPS");
      print(callGPS);
      callGPS = callGPS + 1;

      Timer(Duration(milliseconds: 600), () {
        left_redPlayer.stop();
      });
      callGpsData();
    }

    else if (location == 'Left Notification Warning') {
      dataInserted = true;
      color = Colors.yellow;
      left_greenPlayer.setAsset('assets/warning3.wav');
      left_greenPlayer.play();

      Timer(Duration(milliseconds: 400), () {
        left_greenPlayer.stop();
      });
    }
    else {
      color = Colors.green;
      left_greenPlayer.stop();
      left_redPlayer.stop();
      dataInserted = false; // Reset the flag when the condition is not met
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: opacity,
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


  // previous workable
  // Widget _getLeftIcon() {
  //   double opacity = 1.0;
  //   Color color = Colors.red;
  //
  //   String location = _getLocation();
  //
  //   if (location == 'Left Notification Danger') {
  //     color = Colors.red;
  //     left_redPlayer.setAsset('assets/danger3.mp3');
  //     left_redPlayer.play();
  //
  //     // Save value gps coordinates and images
  //     _getCurrentPosition();
  //     getCurrentDateTime();
  //     _saveScreenshot();
  //     insertDemoData();
  //
  //     Timer(Duration(milliseconds: 600), () {
  //       left_redPlayer.stop();
  //     });
  //   }
  //   else if (location == 'Left Notification Warning') {
  //     color = Colors.yellow;
  //     left_greenPlayer.setAsset('assets/warning3.wav');
  //     left_greenPlayer.play();
  //
  //     Timer(Duration(milliseconds: 400), () {
  //       left_greenPlayer.stop();
  //     });
  //   }
  //   else {
  //     color = Colors.green;
  //     left_greenPlayer.stop();
  //     left_redPlayer.stop();
  //   }
  //
  //   return AnimatedOpacity(
  //     duration: Duration(milliseconds: 300),
  //     opacity: opacity,
  //     // child: Icon(Icons.arrow_back, color: color),
  //     child: Container(
  //       height: 48,
  //       color: Colors.transparent,
  //       child: Image.asset(
  //         'assets/icons/left_warning_llama_rb.png',
  //         color: color,
  //       ),
  //     ),
  //   );
  // }


  // Demo test lefIcon+getLocation
  // Widget _getNotificationIconLeft() {
  //   double opacity = 1.0;
  //   Color color = Colors.red;
  //   String notification = '';
  //
  //   if (_value == null || _value.isEmpty || _value.length < 29) {
  //     notification = 'Notification Not Available';
  //   }
  //   else
  //   {
  //     int locationCode = 0;
  //     try {
  //       locationCode = int.parse(_value[27]);
  //     }
  //     catch (e) {
  //       notification = 'No Notification';
  //     }
  //     switch (locationCode) {
  //       // case 1:
  //       //   notification = 'Right Notification Warning';
  //       //   color = Colors.red;
  //       //   left_redPlayer.setAsset('assets/warning_beep.mp3');
  //       //   left_redPlayer.play();
  //       //   break;
  //       // case 2:
  //       //   notification = 'Right Notification Danger';
  //       //   color = Colors.red;
  //       //   left_redPlayer.setAsset('assets/warning_beep.mp3');
  //       //   left_redPlayer.play();
  //       //   break;
  //       case 1:
  //         notification = 'Left Notification Danger';
  //         color = Colors.red;
  //         left_redPlayer.setAsset('assets/warning_beep.mp3');
  //         left_redPlayer.play();
  //         break;
  //       case 2:
  //         notification = 'Left Notification Warning';
  //         color = Colors.yellow;
  //         left_greenPlayer.setAsset('assets/danger_beep.mp3');
  //         left_greenPlayer.play();
  //         break;
  //       // case 5:
  //       //   notification = 'Rear Notification Danger';
  //       //   color = Colors.red;
  //       //   left_redPlayer.setAsset('assets/warning_beep.mp3');
  //       //   left_redPlayer.play();
  //       //   break;
  //       default:
  //         notification = '';
  //         color = Colors.green;
  //         left_greenPlayer.stop();
  //         left_redPlayer.stop();
  //     }
  //   }
  //   return AnimatedOpacity(
  //     duration: Duration(milliseconds: 300),
  //     opacity: opacity,
  //     // child: Icon(Icons.arrow_back, color: color),
  //     child: Container(
  //       height: 48,
  //       color: Colors.transparent,
  //       child: Image.asset(
  //         'assets/icons/left_warning_llama_rb.png',
  //         color: color,
  //       ),
  //     ),
  //   );
  // }

  Widget _getRightIcon() {
    double opacity = 1.0;
    Color color = Colors.red;

    if (_getLocation() == 'Right Notification Danger') {
      dataInserted = true;
      color = Colors.red;
      right_redPlayer.setAsset('assets/danger3.mp3');
      right_redPlayer.play();

      Timer(Duration(milliseconds: 600), () {
        right_redPlayer.stop();
      });
    }
    else if (_getLocation() == 'Right Notification Warning') {
      dataInserted = true;
      color = Colors.yellow;
      right_greenPlayer.setAsset('assets/warning3.wav');
      right_greenPlayer.play();

      Timer(Duration(milliseconds: 400), () {
        right_greenPlayer.stop();
      });
    }
    else {
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
      dataInserted = true;
      color = Colors.red;
      rear_redPlayer.setAsset('assets/danger3.mp3');
      rear_redPlayer.play();
      if (right_danger_counter >= 5 && !isRearCamOpen) {
        if (popupState.isPopupWindowEnabled) {
          showStreamPopup();
        }
        right_danger_counter = 0;
      }
      right_danger_counter = right_danger_counter + 1;
      Timer(Duration(milliseconds: 600), () {
        rear_redPlayer.stop();
      });
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


  // void _handleButtonPress() {
  //   if (int.tryParse(_value[15]) == 3 || int.tryParse(_value[15]) == 6 || int.tryParse(_value[15]) == 9) {
  //     _startBlinking3();
  //   }
  // }

  // Open pop-up window for dashcam rear warning
  Future<void> initializePlayer() async {
    // _videoPlayerController = VlcPlayerController.network(
    //   'rtsp://192.168.1.254/xxxx.mp4',
    //   hwAcc: HwAcc.disabled,
    //   autoPlay: true,
    //   options: VlcPlayerOptions(
    //     advanced: VlcAdvancedOptions([
    //       // VlcRtpOptions.rtpOverRtsp(true), // New method try and test
    //       VlcAdvancedOptions.networkCaching(0),
    //       VlcAdvancedOptions.clockJitter(0),
    //       VlcAdvancedOptions.fileCaching(0),
    //       VlcAdvancedOptions.liveCaching(0),
    //     ]),
    //   ),
    // );
    _videoPlayerController = VlcPlayerController.network(
      'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
          video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
            VlcVideoOptions.skipFrames(false)],),
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(30),
            VlcAdvancedOptions.clockJitter(0),
            VlcAdvancedOptions.fileCaching(30),
            VlcAdvancedOptions.liveCaching(30),
            VlcAdvancedOptions.clockSynchronization(1),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
            ":rtsp-tcp",
          ]),
          extras: ['--h264-fps=60'],
          // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
          sout: VlcStreamOutputOptions([
            VlcStreamOutputOptions.soutMuxCaching(0),
          ])
      ),);
    await _videoPlayerController!.initialize();
  }


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
    // Extra
    // setState(() {
    //   isButtonEnabled = false;
    //   isCameraAnimation = true;
    // });

    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
    }
    else {
      Connectivity().onConnectivityChanged.listen((connectivity) {
        if (connectivity == ConnectivityResult.wifi) {
          // _videoPlayerController = VlcPlayerController.network(
          //   'rtsp://192.168.1.254/xxxx.mp4',
          //   hwAcc: HwAcc.disabled,
          //   autoPlay: true,
          //   options: VlcPlayerOptions(
          //     advanced: VlcAdvancedOptions([
          //       VlcAdvancedOptions.networkCaching(0),
          //       VlcAdvancedOptions.clockJitter(0),
          //       VlcAdvancedOptions.fileCaching(0),
          //       VlcAdvancedOptions.liveCaching(0),
          //     ]),),
          // );
          _videoPlayerController = VlcPlayerController.network(
            'https://media.w3.org/2010/05/sintel/trailer.mp4',
            hwAcc: HwAcc.disabled,
            autoPlay: true,
            options: VlcPlayerOptions(
                video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
                  VlcVideoOptions.skipFrames(false)],),
                advanced: VlcAdvancedOptions([
                  VlcAdvancedOptions.networkCaching(30),
                  VlcAdvancedOptions.clockJitter(0),
                  VlcAdvancedOptions.fileCaching(30),
                  VlcAdvancedOptions.liveCaching(30),
                  VlcAdvancedOptions.clockSynchronization(1),
                ]),
                rtp: VlcRtpOptions([
                  VlcRtpOptions.rtpOverRtsp(true),
                  ":rtsp-tcp",
                ]),
                extras: ['--h264-fps=60'],
                // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
                sout: VlcStreamOutputOptions([
                  VlcStreamOutputOptions.soutMuxCaching(0),
                ])
            ),);
          _videoPlayerController.initialize().then((_) {
            _videoPlayerController.play();
          });
        }
      });

      // _videoPlayerController = VlcPlayerController.network(
      //   'rtsp://192.168.1.254/xxxx.mp4',
      //   hwAcc: HwAcc.disabled,
      //   autoPlay: true,
      //   options: VlcPlayerOptions(
      //     advanced: VlcAdvancedOptions([
      //       VlcAdvancedOptions.networkCaching(0),
      //       VlcAdvancedOptions.clockJitter(0),
      //       VlcAdvancedOptions.fileCaching(0),
      //       VlcAdvancedOptions.liveCaching(0),
      //     ]),),
      // );
      _videoPlayerController = VlcPlayerController.network(
        'https://media.w3.org/2010/05/sintel/trailer.mp4',
        hwAcc: HwAcc.disabled,
        autoPlay: true,
        options: VlcPlayerOptions(
            video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
              VlcVideoOptions.skipFrames(false)],),
            advanced: VlcAdvancedOptions([
              VlcAdvancedOptions.networkCaching(30),
              VlcAdvancedOptions.clockJitter(0),
              VlcAdvancedOptions.fileCaching(30),
              VlcAdvancedOptions.liveCaching(30),
              VlcAdvancedOptions.clockSynchronization(1),
            ]),
            rtp: VlcRtpOptions([
              VlcRtpOptions.rtpOverRtsp(true),
              ":rtsp-tcp",
            ]),
            extras: ['--h264-fps=60'],
            // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
            sout: VlcStreamOutputOptions([
              VlcStreamOutputOptions.soutMuxCaching(0),
            ])
        ),);
      _videoPlayerController.initialize().then((_) {
        _videoPlayerController.play();
      });
    }

    setState(() {
      isCameraStreaming = !isCameraStreaming;
      isRearCamOpen = !isRearCamOpen;
    });
    // EXTRA

    // Future.delayed(Duration(seconds: 2), () {
    //   // Enable the button and open the camera
    //   setState(() {
    //     isButtonEnabled = true;
    //     isCameraAnimation = false;
    //   });
    // });
  }

  // Only for stop camera animation
  // void stopCameraAnime() {
  //   setState(() {
  //     isCameraAnimation = true;
  //   });
  // }

  // Dispose function
  @override
  void dispose() {
    print("DISPOSE CALLED");
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
    _gpsDataTimer?.cancel();
    super.dispose();
    print("DISPOSE END");
  }

  Widget buildCameraButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (isCameraStreaming) // Show "Stop Rear Camera" button when streaming
              ElevatedButton(
                onPressed: toggleCameraStreaming,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  'Stop Rear Camera',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            if (!isCameraStreaming) // Show "Open Rear Cam" button when not streaming
              ElevatedButton(
                onPressed: toggleCameraStreaming,
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  'Open Rear Cam',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
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
  void didPop() {
    super.dispose();
  }

  @override
  void didPopNext() {
    // This is called when the page is popped and the previous page is now active
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ledValuesProvider = Provider.of<LedValuesProvider>(context);
    Color screenColor = Theme.of(context).backgroundColor;
    return OrientationBuilder(
      builder: (context, orientation) {
        currentOrientation = orientation;
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFa8caba), Color(0xFF517fa4)],
              ),
            ),
            child: Scaffold(
              // backgroundColor: Colors.transparent,
              backgroundColor: Colors.white70,
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
                    // color: Colors.white70,
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
                          // _getNotificationIconLeft(),
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
                      // Test without column
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 100),
                                // SizedBox(width: 0),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(_tailight ? Icons.wb_twilight : Icons.wb_twilight),
                                      onPressed: () {},
                                      padding: EdgeInsets.all(0),
                                    ),
                                    DropdownButton<String>(
                                      value: _selectedOption,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedOption = value!;
                                          switch (value) {
                                            case 'OFF':
                                              _sendData([0x02, 0x01, 0x10, 0x00, 0x00, 0x19]);
                                              break;
                                            case 'ON':
                                              _sendData([0x02, 0x01, 0x10, 0x00, 0x01, 0x19]);
                                              break;
                                            case 'FLASHING':
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
                      Container(
                        // margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start, // Align children to the start (left)
                          children: [
                            SizedBox(width: 70),
                            buildCameraButton(),
                            SizedBox(width: 75),
                          ],
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
                                  BleScreen(title: '')),
                            );
                          },
                          color1: Color(0xFF517fa4),
                          color2: Colors.cyan,
                        ),
                      ],
                    ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GlowingButton2(
                  //       text: "Stop Ride",
                  //       onPressed: () {
                  //         // Show a confirmation dialog
                  //         showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return AlertDialog(
                  //               title: Text("Stop Ride"),
                  //               content: Text("Are you sure you want to Review your ride?"),
                  //               actions: [
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     _disconnectFromDevice();
                  //                     Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(builder: (context) => ShowGpsData()),
                  //                     );
                  //                   },
                  //                   child: Text("Yes"),
                  //                 ),
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     _disconnectFromDevice();
                  //                     Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(builder: (context) => BleScreen(title: '')),
                  //                     );
                  //                   },
                  //                   child: Text("No"),
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       },
                  //       color1: Color(0xFF517fa4),
                  //       color2: Colors.cyan,
                  //     ),
                  //   ],
                  // ),
                  // Image with power button
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.only(top: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(width: 50),
                          GlowingButton2(
                            text: "Stop Ride",
                            onPressed: () {
                              left_redPlayer.stop();
                              left_greenPlayer.stop();
                              _disconnectFromDevice();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    BleScreen(title: '')),
                              );
                            },
                            color1: Color(0xFF517fa4),
                            color2: Colors.cyan,
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     GlowingButton2(
                      //       text: "Stop Ride",
                      //       onPressed: () {
                      //         // Show a confirmation dialog
                      //         showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return AlertDialog(
                      //               title: Text("Stop Ride"),
                      //               content: Text("Are you sure you want to Review your ride?"),
                      //               actions: [
                      //                 TextButton(
                      //                   onPressed: () {
                      //                     _disconnectFromDevice();
                      //                     Navigator.push(
                      //                       context,
                      //                       MaterialPageRoute(builder: (context) => ShowGpsData()),
                      //                     );
                      //                   },
                      //                   child: Text("Yes"),
                      //                 ),
                      //                 TextButton(
                      //                   onPressed: () {
                      //                     _disconnectFromDevice();
                      //                     Navigator.push(
                      //                       context,
                      //                       MaterialPageRoute(builder: (context) => BleScreen(title: '')),
                      //                     );
                      //                   },
                      //                   child: Text("No"),
                      //                 ),
                      //               ],
                      //             );
                      //           },
                      //         );
                      //       },
                      //       color1: Color(0xFF517fa4),
                      //       color2: Colors.cyan,
                      //     ),
                      //   ],
                      // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     GlowingButton2(
                    //       text: "Stop Ride",
                    //       onPressed: () {
                    //         // Show a confirmation dialog
                    //         showDialog(
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return AlertDialog(
                    //               title: Text("Stop Ride"),
                    //               content: Text("Are you sure you want to Review your ride?"),
                    //               actions: [
                    //                 TextButton(
                    //                   onPressed: () {
                    //                     _disconnectFromDevice();
                    //                     Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(builder: (context) => ShowGpsData()),
                    //                     );
                    //                   },
                    //                   child: Text("Yes"),
                    //                 ),
                    //                 TextButton(
                    //                   onPressed: () {
                    //                     _disconnectFromDevice();
                    //                     Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(builder: (context) => BleScreen(title: '')),
                    //                     );
                    //                   },
                    //                   child: Text("No"),
                    //                 ),
                    //               ],
                    //             );
                    //           },
                    //         );
                    //       },
                    //       color1: Color(0xFF517fa4),
                    //       color2: Colors.cyan,
                    //     ),
                    //   ],
                    // ),
                    // Image with power button
                      SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.only(top: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 235),
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
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}