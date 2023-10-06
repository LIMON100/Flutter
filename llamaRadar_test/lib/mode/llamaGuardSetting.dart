import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lamaradar/provider/BluetoothStateProvider.dart';
import 'package:provider/provider.dart';

import '../provider/LedValuesProvider.dart';
import '../provider/PopupWindowProvider.dart';

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
  bool isBluetoothEnabled = true;
  bool popupWindow = false;
  BluetoothCharacteristic? _characteristic_write;
  BluetoothCharacteristic? _characteristic;
  TextEditingController ssidController = TextEditingController();
  TextEditingController passController = TextEditingController();
  late BluetoothDevice _device;
  String ssidVal ='';
  String passVal ='';
  String _value = '';
  String textFirmware = '';
  String textFirmwareVersion = '0.0.0';
  String textFirmwareDate = 'Aug 01 2023';
  String currentSSID = '';
  String currentpass = '';
  List<int> notificationValue = [];
  List<String> hexList = [];
  String textResultFirmware = '';
  bool isNotificationReceived = false;
  bool bleConnectionAvailable = false;
  bool isFirmwareUpdatePress = false;
  bool isResetPress = false;

  bool showWifiSettings = false;
  String currentTailightMode = 'NO';
  String currentSsid = 'NO';
  String currentPassword = 'NO';

  double leftLedValue = 50.0;
  double rightLedValue = 50.0;

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
  bool showVersionAndDate = false;
  bool showWifissidpass = false;
  bool showSetWifi = false;
  String completeValue = '';

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    _connectToDevice();
  }

  String accumulatedValue = '';
  // BLE notification
  Future<void> _connectToDevice() async {
    try {
      await widget.device.requestMtu(512);
      // print('Requested MTU size: 512');
    } catch (e) {
      print('Error requesting MTU size: $e');
    }

    // Discover services and characteristics
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      List<BluetoothCharacteristic> characteristics = await service.characteristics;
      for (BluetoothCharacteristic characteristic in characteristics) {
        if (characteristic.uuid.toString() ==
            'beb5483e-36e1-4688-b7f5-ea07361b26a7') {
          _characteristic_write = characteristic;
        }

        if (characteristic.properties.notify) {
          if (characteristic.uuid.toString() ==
              'beb5483e-36e1-4688-b7f5-ea07361b26a8') {
            _characteristic = characteristic;

            // Enable notifications for the characteristic
            await _characteristic!.setNotifyValue(true);

            // Listen to the characteristic notifications
            _characteristic!.value.listen((value) {
              setState(() {
                _value = value.toString();
                notificationValue = value;

                // CHecking Write->Notification command
                hexList = intsToHexStrings(notificationValue);
                List<String> hexList2 = hexList;
                textResultFirmware = hexListToText(hexList2);

                // print("WOFO");
                // print(textResultFirmware);

                if (textResultFirmware[2] == 'ð') {
                  functionForFirmware(textResultFirmware);
                }

                if (textResultFirmware[2] != 'ð') {
                  functionForWifi(textResultFirmware);
                }
              });
            });
            print('Found characteristic ${characteristic.uuid}');
          }
        }
      }
    }

    setState(() {
      _device = widget.device;
      bleConnectionAvailable = true;
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

  // Firmware version
  void functionForFirmware(textResultFirmware) {

    List<String> parts = splitTextResultFirmware(textResultFirmware);

    if (parts.length == 2) {
      textFirmwareVersion = parts[0].trim().substring(1);
      textFirmwareDate = parts[1].trim();
      if (textFirmwareDate.isNotEmpty) {
        textFirmwareDate = textFirmwareDate.substring(0, textFirmwareDate.length - 1);
      }
      // print("Version: $textFirmwareVersion");
      // print("Date: $textFirmwareDate");
    }
  }

  // Wifi ssid password
  void functionForWifi(textResultFirmware) {
    // List<String> parts = textResultFirmware.replaceAll('[', '').replaceAll(']', '').split(' ');
    List<String> parts = textResultFirmware.replaceAll('[', '').replaceAll(']', '').split(' ');
    if (parts.length > 2) {
      currentSSID = parts[3];
      currentpass = parts[4];
      currentpass = currentpass.substring(0, currentpass.length - 1);
    }
    else {
      print("Invalid format");
    }
  }

  // HEX convert
  List<String> splitTextResultFirmware(String textResult) {
    List<String> delimiters = ["Sep ", "Oct ", "Nov ", "Dec "]; // Add more if needed

    for (String delimiter in delimiters) {
      List<String> parts = textResult.split(delimiter);
      if (parts.length == 2) {
        return [parts[0].trim(), delimiter + parts[1].trim()];
      }
    }

    // If no delimiter is found, return the entire textResult as the version
    return [textResult.trim(), ""];
  }


  String hexListToText(List<String> hexList) {
    StringBuffer textBuffer = StringBuffer();

    for (String hex in hexList) {
      int intValue = int.parse(hex, radix: 16);

      if (intValue < 32) {
        textBuffer.write(' ');
      } else {
        textBuffer.writeCharCode(intValue);
      }
    }
    return textBuffer.toString();
  }

  // Send data part
  Future<void> _sendData(List<int> dataToSend) async {
    if (_characteristic_write != null) {
      await _characteristic_write!.write(dataToSend);
      final response = await _characteristic_write!.value.first;
    }
  }

  List<int> calculateChecksum(List<int> data) {
    int csk = 0;
    for (int value in data) {
      csk += value;
    }
    int cskResult = csk % 256;
    data.add(cskResult); // Add the checksum to the end of the list
    return data;
  }

  void showPopUp(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('                  SSID and PASSWORD set correctly.'),
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  // Dispose method
  @override
  void dispose() {
    ssidController.dispose();
    passController.dispose();
    super.dispose();
  }

  // Command for wifi SSID and PASSWORD
  String command  = '';
  String cskHex = '';
  void generateCommand() {
    String ssid = ssidController.text;
    String pass = passController.text;

    // Validate SSID and Password lengths
    if (ssid.isEmpty || ssid.length > 40) {
      setState(() {
        command = 'Invalid SSID length';
      });
      return;
    }

    if (pass.isEmpty || pass.length > 40) {
      setState(() {
        command = 'Invalid Password length';
      });
      return;
    }

    // Convert SSID and Password to hexadecimal
    String ssidHex = '';
    String passHex = '';

    for (int i = 0; i < ssid.length; i++) {
      ssidHex += '0x${ssid.codeUnitAt(i).toRadixString(16).padLeft(2, '0')},';
    }

    for (int i = 0; i < pass.length; i++) {
      String hexValue = pass.codeUnitAt(i).toRadixString(16).toUpperCase(); // Ensure uppercase
      if (hexValue.length == 1) {
        hexValue = '0$hexValue';
      }
      passHex += '0x$hexValue,';
    }

    ssidHex = ssidHex.substring(0, ssidHex.length - 1);
    passHex = passHex.substring(0, passHex.length - 1);

    // Calculate the checksum (CSK)
    int cskValue = 0;

    // Construct the command without the CSK
    String fullCommand =
        '0x02,0x01,0x21,0x00,0x${ssid.length.toRadixString(16)},$ssidHex,0x${pass.length.toRadixString(16)},$passHex';


    // Calculate CSK using XOR on each byte
    List<String> commandBytes = fullCommand.split(',');
    for (String byteStr in commandBytes) {
      int byteValue = int.parse(byteStr.replaceAll('0x', ''), radix: 16);
      cskValue ^= byteValue;
    }

    // TEST CHECKSUM
    List<int> command3 = fullCommand.split(',').map((hex) {
      return int.parse(hex.startsWith('0x') ? hex.substring(2) : hex, radix: 16);
    }).toList();

    String cskHex = '0x${cskValue.toRadixString(16)}';

    // Update the full command string with CSK as the last element
    fullCommand += ',$cskHex';

    List<int> command2 = fullCommand.split(',').map((hex) {
      return int.parse(hex.startsWith('0x') ? hex.substring(2) : hex, radix: 16);
    }).toList();

    _sendData(command3);

    setState(() {
      command = fullCommand;
    });
  }

  bool showSuccessMessage = false;

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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showWifissidpass)
                    Text(
                      'Press to check current ssid and password',
                    ),
                  if (showWifissidpass)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current SSID: ',
                          style: TextStyle(
                            color: Colors.black, // Change the color to your desired color
                          ),
                        ),
                        Text(
                          '$currentSSID',
                          style: TextStyle(
                            color: Colors.blue, // Change the color to your desired color
                          ),
                        ),
                        Text(
                          'Current Password: ',
                          style: TextStyle(
                            color: Colors.black, // Change the color to your desired color
                          ),
                        ),
                        Text(
                          '$currentpass',
                          style: TextStyle(
                            color: Colors.blue, // Change the color to your desired color
                          ),
                        ),
                      ],
                    ),
                ],
              ), // Display current SSID and password
              onTap: () {
                if (bleConnectionAvailable) {
                  _sendData([0x02, 0x01, 0x20, 0x00, 0x01, 0x24]);
                  showWifissidpass = true;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('BLE connection error. Make sure BLE is connected.'),
                      duration: Duration(seconds: 2), // Set the duration to 2 seconds
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          // Handle the action when the user dismisses the message
                        },
                      ),
                    ),
                  );
                }
              },
            ),

            Divider(),
            ListTile(
              title: Text('WiFi Settings'),
              subtitle: Text('Set SSID/Password'),
              onTap: () {
                setState(() {
                  showSetWifi = !showSetWifi; // Toggle the flag
                });
              },
            ),
            if (showSetWifi)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: ssidController,
                      decoration: InputDecoration(labelText: 'SSID (1-40 characters)'),
                    ),
                    TextField(
                      controller: passController,
                      decoration: InputDecoration(labelText: 'Password (1-40 characters)'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (bleConnectionAvailable) {
                          generateCommand();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'SSID and password saved successfully'),
                              duration: Duration(
                                  seconds: 1), // Display for 1 second
                            ),
                          );
                        }
                        else {
                          // Show a BLE connection error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('BLE connection error. Make sure BLE is connected.'),
                              duration: Duration(seconds: 2), // Set the duration to 2 seconds
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  // Handle the action when the user dismisses the message
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('SAVE'),
                    ),
                  ],
                ),
              ),
            Divider(),
            ListTile(
              title: Text('Firmware'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showVersionAndDate)
                    Text(
                      'Press to check Firmware version',
                    ),
                  if (showVersionAndDate)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Version: ',
                          style: TextStyle(
                            color: Colors.black, // Change the color to your desired color
                          ),
                        ),
                        Text(
                          '$textFirmwareVersion',
                          style: TextStyle(
                            color: Colors.blue, // Change the color to your desired color
                          ),
                        ),
                        Text(
                          'Date: ',
                          style: TextStyle(
                            color: Colors.black, // Change the color to your desired color
                          ),
                        ),
                        Text(
                          '$textFirmwareDate',
                          style: TextStyle(
                            color: Colors.blue, // Change the color to your desired color
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              onTap: () {
                if (bleConnectionAvailable) {
                  _sendData([0x02, 0x01, 0xF0, 0x00, 0x00, 0xF4]);
                  setState(() {
                    showVersionAndDate = true;
                  });
                }
                else {
                  // Show a BLE connection error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('BLE connection error. Make sure BLE is connected.'),
                      duration: Duration(seconds: 2), // Set the duration to 2 seconds
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          // Handle the action when the user dismisses the message
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            Divider(),
            ListTile(
              title: Text('Firmware Update'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirmation"),
                      content: Text("PLEASE first check your wifi is CONNECTED, and check the wifi SSID & PASSWORD is correct, if NOT then first set SSID & Password according to your wifi, then proceed next"),
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
                            isFirmwareUpdatePress = true;
                            _sendData([0x02, 0x01, 0xF2, 0x00, 0x01, 0xF6]);
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "WARNING",
                                    style: TextStyle(
                                      color: Colors.red, // Set the text color to red
                                    ),
                                  ),
                                  content: Text("PLEASE wait 5 seconds to START firmware update. You can see light blinking when updating firmware, So DONOT turn OFF wifi on that time, When FINISH the blinking will OFF."),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the AlertDialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
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
            // Popup window
            Consumer<PopupWindowProvider>(
              builder: (context, popupState, _) {
                return ListTile(
                  title: Text('Enable Pop-up Rearcam'),
                  trailing: Switch(
                    value: popupState.isPopupWindowEnabled,
                    onChanged: (value) {
                      popupState.setPopupWindowEnabled(value);
                    },
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    inactiveThumbColor: Colors.red,
                  ),
                );
              },
            ),

            Divider(),
            // Bluetooth
            Consumer<BluetoothStateProvider>(
              builder: (context, appState, _) {
                return ListTile(
                  title: Text('Bluetooth'),
                  trailing: Switch(
                    value: appState.isBluetoothEnabled,
                    onChanged: (value) {
                      appState.setBluetoothEnabled(value);
                      if (!value) {
                        _sendData([0x02, 0x01, 0x40, 0x00, 0x01, 0x44]);
                      }
                    },
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    inactiveThumbColor: Colors.red,
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirmation"),
                          content: Text("Are you sure you want to reset?"),
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
                                _sendData([0x02, 0x01, 0x52, 0x00, 0x01, 0x56]);
                                setState(() {
                                  isResetPress = true;
                                });
                                Navigator.of(context).pop(); // Close the confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Reset Initiated"),
                                      content: Text("The reset process has been initiated."),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the AlertDialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "Reset Device",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
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