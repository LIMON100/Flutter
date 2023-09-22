import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import '../temp/LedValuesProvider.dart';

class LlamaGuardSetting extends StatefulWidget {
  final BluetoothDevice device;
  final String selectedOption;
  LlamaGuardSetting({Key? key, required this.device, required this.selectedOption}) : super(key: key);

  @override
  _LlamaGuardSettingState createState() => _LlamaGuardSettingState();
}

class _LlamaGuardSettingState extends State<LlamaGuardSetting> {

  bool isTailightModeEnabled = false;
  bool isRadarEnabled = false;
  bool isBluetoothEnabled = false;
  BluetoothCharacteristic? _characteristic_write;
  BluetoothCharacteristic? _characteristic;
  TextEditingController ssidController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String ssidVal ='';
  String passVal ='';
  String _value = '';
  late BluetoothDevice _device;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _connectToDevice();
  }

  // BLE notification
  Future<void> _connectToDevice() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = await service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.uuid.toString() ==
            'beb5483e-36e1-4688-b7f5-ea07361b26a7') {
          _characteristic_write = characteristic;
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
      await _characteristic_write!.write(dataToSend);
      final response = await _characteristic_write!.value.first;
    }
  }

  bool showWifiSettings = false;
  String currentTailightMode = 'NO';
  String currentSsid = 'NO';
  String currentPassword = 'NO';

  double leftLedValue = 50.0; // Initial value for left_led
  double rightLedValue = 50.0; // Initial value for right_led

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
  void _sendData2(LedValuesProvider ledValuesProvider) {
    int leftLed = ledValuesProvider.leftLedValue.round();
    int rightLed = ledValuesProvider.rightLedValue.round();
    int turnOnTime = (ledValuesProvider.turnOnTime.round() * 10000).toInt();
    int turnOffTime = (ledValuesProvider.turnOffTime.round() * 1000).toInt();

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

    print(ledValuesProvider);
    print('Left LED: $leftLed');
    print('Right LED: $rightLed');
    print('ON Time: $turnOnTime');
    print('OFF Time: $turnOffTime');

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

  void showPopUp(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('                  SSID and PASSWORD set correctly.'),
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }
  bool isSwitched = false;
  double sliderValue = 0.0;
  double maxSliderValue = 60.0;

  bool isMilliseconds = false;
  double timeOnValue = 0.0;
  double timeOffValue = 0.0;
  double maxTimeOnValueSeconds = 6.0;
  double maxTimeOffValueSeconds = 60.0;
  double maxTimeOnValueMilliseconds = 1000.0;
  double maxTimeOffValueMilliseconds = 1000.0;

  @override
  Widget build(BuildContext context) {
    final ledValuesProvider = Provider.of<LedValuesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('Settings'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xFF6497d3),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Divider(),
            ListTile(
              title: Text('Tailight Mode'),
              subtitle: Text('Current Mode: ${widget.selectedOption}'), // Display current mode
              // onTap: () {
              //   _sendData([0x02, 0x01, 0x11, 0x00, 0x00, 0x14]);
              // },
            ),

            Divider(),
            ListTile(
              title: Text('WiFi'),
              subtitle: Text('Current SSID: \nCurrent Password: '), // Display current SSID and password
              onTap: () {
                _sendData([0x02, 0x01, 0x20, 0x00, 0x01, 0x24]);
              },
            ),
            Divider(),
            ListTile(
              title: Text('WiFi Settings'),
              subtitle: Text('Set SSID/Password'),
              onTap: () {
                _sendData([0x02, 0x01, 0x21, 0x00, 0x04, 0x77, 0x69, 0x66, 0x69, 0x08, 0x0A, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x8d]);
                setState(() {
                  showWifiSettings = !showWifiSettings; // Toggle the flag
                  showPopUp();
                });
              },
            ),
            Divider(),
            ListTile(
              title: Text('Firmware'),
              subtitle: Text('Version: '), // Display current mode
              onTap: () {
                _sendData([0x02, 0x01, 0xF0, 0x00, 0x00, 0xF4]);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Firmware Update'),
              onTap: () {
                _sendData([0x02, 0x01, 0xF2, 0x00, 0x01, 0xF6]);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Radar'),
              trailing: Switch(
                value: isRadarEnabled,
                onChanged: (value) {
                  setState(() {
                    isRadarEnabled = value;
                  });
                  if (isRadarEnabled) {
                    _sendData([0x02, 0x01, 0x31, 0x00, 0x01, 0x35]);
                  } else {
                    _sendData([0x02, 0x01, 0x30, 0x00, 0x01, 0x34]);
                  }
                },
                activeColor: Colors.green,
                inactiveTrackColor: Colors.red,
                inactiveThumbColor: Colors.red,
              ),
            ),

            Divider(),
            ListTile(
              title: Text('Bluetooth'),
              trailing: Switch(
                value: isBluetoothEnabled,
                onChanged: (value) {
                  setState(() {
                    isBluetoothEnabled = value;
                  });
                  if (isBluetoothEnabled) {
                    _sendData([0x02, 0x01, 0x40, 0x00, 0x01, 0x44]);
                  }
                },
                activeColor: Colors.green,
                inactiveTrackColor: Colors.red,
                inactiveThumbColor: Colors.red,
              ),
            ),
            Divider(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // _sendData([0x02, 0x01, 0x50, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x77]);
                  _sendData([0x02, 0x01, 0x50, 0x00, 0x01, 0x54]);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Change button color based on state
                ),
                child: Text('TEST System'),
              ),
            ),
            Divider(),
            Text("  System Info: $_value"),
            Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                TextButton(
                  onPressed: () {
                    _sendData([0x02, 0x01, 0x52, 0x00, 0x01, 0x56]);

                    Future.delayed(Duration(seconds: 2), () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Reset Successfully"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  },
                  child: Text(
                    "Reset Device",
                    style: TextStyle(
                      fontSize: 18, // Adjust the font size as needed
                      color: Colors.black, // Change the text color to your desired color
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),

            SizedBox(height:20),
            Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                TextButton(
                  onPressed: () {
                    // Show a confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirmation"),
                          content: Text("Are you sure you want to do a factory reset?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("NO"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: Text("YES"),
                              onPressed: () {
                                // Perform the factory reset action here
                                _sendData([0x02, 0x01, 0x55, 0x00, 0x01, 0x59]);

                                // Show a success dialog after the reset
                                Future.delayed(Duration(seconds: 2), () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Reset Successfully"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the success dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });

                                Navigator.of(context).pop(); // Close the confirmation dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "Factory Reset",
                    style: TextStyle(
                      fontSize: 18, // Adjust the font size as needed
                      color: Colors.red, // Change the text color to your desired color
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}