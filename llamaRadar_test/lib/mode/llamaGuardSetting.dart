import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import '../temp/LedValuesProvider.dart';

class LlamaGuardSetting extends StatefulWidget {
  final BluetoothDevice device;
  LlamaGuardSetting({Key? key, required this.device}) : super(key: key);

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

            // ListTile(
            //   title: Text('Set Taillight Mode'),
            //   subtitle: Row(
            //     children: [
            //       Text('Left LED: ${ledValuesProvider.leftLedValue.toInt()}'),
            //       SizedBox(width: 20), // Add spacing between text
            //       Text('Right LED: ${ledValuesProvider.rightLedValue.toInt()}'),
            //     ],
            //   ),
            // ),
            //
            // Divider(),
            // Column(
            //   children: [
            //     Text('Left LED Brightness: ${ledValuesProvider.leftLedValue.toInt()}'),
            //     Slider(
            //       value: ledValuesProvider.leftLedValue,
            //       min: 0,
            //       max: 100,
            //       onChanged: (newValue) {
            //         ledValuesProvider.updateLeftLedValue(newValue);
            //       },
            //     ),
            //     Text('Right LED Brightness: ${ledValuesProvider.rightLedValue.toInt()}'),
            //     Slider(
            //       value: ledValuesProvider.rightLedValue,
            //       min: 0,
            //       max: 100,
            //       onChanged: (newValue) {
            //         ledValuesProvider.updateRightLedValue(newValue);
            //       },
            //     ),
            //     // Set Timer
            //     Text('Time On: ${ledValuesProvider.turnOnTime.toInt()}'),
            //     Slider(
            //       value: ledValuesProvider.turnOnTime,
            //       min: 0,
            //       max: 6,
            //       onChanged: (newValue) {
            //         setState(() {
            //           ledValuesProvider.updateTurnOnTime(newValue);
            //         });
            //       },
            //     ),
            //     Text('Time Off: ${ledValuesProvider.turnOffTime.toInt()}'),
            //     Slider(
            //       value: ledValuesProvider.turnOffTime,
            //       min: 0,
            //       max: 60,
            //       onChanged: (newValue) {
            //         setState(() {
            //           ledValuesProvider.updateTurnOffTime(newValue);
            //         });
            //       },
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         ElevatedButton(
            //           onPressed: () {
            //             // Reset the LED values to their defaults
            //             ledValuesProvider.resetLedValues();
            //           },
            //           child: Text('Reset'),
            //         ),
            //         SizedBox(width: 16), // Add spacing between buttons
            //         ElevatedButton(
            //           onPressed: () {
            //             _sendData2(ledValuesProvider); // Pass the ledValuesProvider
            //           },
            //           child: Text('Save'),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),

            // Divider(),
            ListTile(
              title: Text('Tailight Mode'),
              subtitle: Text('Current Mode: '), // Display current mode
              onTap: () {
                _sendData([0x02, 0x01, 0x13, 0x00, 0x00, 0x16]);
              },
            ),
            Divider(),
            ListTile(
              title: Text('WiFi'),
              subtitle: Text('Current SSID: \nCurrent Password: '), // Display current SSID and password
              onTap: () {
                _sendData([0x02, 0x01, 0x20, 0x00, 0x01, 0x24]);
              },
            ),
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
              onTap: () {
                _sendData([0x02, 0x01, 0xF2, 0x00, 0x01, 0xF6]);
              },
            ),
            Divider(),
            // SSID SET & PASSWORD
            // if (showWifiSettings)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: <Widget>[
            //         Container(
            //           child: TextField(
            //             controller: ssidController,
            //             decoration: InputDecoration(
            //               labelText: 'SSID: $ssidVal',
            //             ),
            //           ),
            //         ),
            //         SizedBox(height: 16),
            //         Container(
            //           child: ElevatedButton(
            //             child: Text('Change SSID'),
            //             onPressed: () {
            //               String ssid = ssidController.text.trim();
            //               _sendData([0x02, 0x01, 0x21, 0x00, 0x04, 0x77, 0x69, 0x66, 0x69, 0x08, 0x0A, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x8d]);
            //               // changeSSID(ssid);
            //             },
            //           ),
            //         ),
            //         SizedBox(height: 16), // Add vertical spacing
            //         Container(
            //           child: TextField(
            //             controller: passController,
            //             decoration: InputDecoration(
            //               labelText: 'Pass: $passVal',
            //             ),
            //           ),
            //         ),
            //         SizedBox(height: 16),
            //         Container(
            //           child: ElevatedButton(
            //             child: Text('Change WiFi Pass'),
            //             onPressed: () {
            //               String pass = passController.text.trim();
            //               // changePASS(pass);
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

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
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       _sendData([0x02, 0x01, 0x12, 0x00, 0xea, 0x60, 0xea, 0x60, 0x01, 0x64, 0x01, 0x72]);
            //       // List<int> data = [0x02, 0x01, 0x12, 0x00, 0x03, 0xe8, 0x13, 0x88, 0x50, 0x50, 0x01];
            //       // List<int> dataWithChecksum = calculateChecksum(data);
            //       // print("Data with Checksum: ${dataWithChecksum.map((e) => "0x${e.toRadixString(16).toUpperCase()}").join(", ")}");
            //     },
            //     style: ElevatedButton.styleFrom(
            //       primary: Colors.green, // Change button color based on state
            //     ),
            //     child: Text('TEST OTHER'),
            //   ),
            // )
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Seconds'),
                Switch(
                  value: isMilliseconds,
                  onChanged: (value) {
                    setState(() {
                      isMilliseconds = value;
                      if (isMilliseconds) {
                        timeOnValue = 0.0;
                        timeOffValue = 0.0;
                      } else {
                        timeOnValue = 0.0;
                        timeOffValue = 0.0;
                      }
                    });
                  },
                ),
                Text('Milliseconds'),
              ],
            ),
            Text('Time On: ${timeOnValue.toStringAsFixed(2)}'),
            Slider(
              value: timeOnValue,
              min: 0,
              max: isMilliseconds ? maxTimeOnValueMilliseconds : maxTimeOnValueSeconds,
              onChanged: (newValue) {
                setState(() {
                  timeOnValue = newValue;
                });
              },
            ),
            Text('Time Off: ${timeOffValue.toStringAsFixed(2)}'),
            Slider(
              value: timeOffValue,
              min: 0,
              max: isMilliseconds ? maxTimeOffValueMilliseconds : maxTimeOffValueSeconds,
              onChanged: (newValue) {
                setState(() {
                  timeOffValue = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}