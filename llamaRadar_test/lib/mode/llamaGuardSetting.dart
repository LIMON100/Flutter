import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
  String currentTailightMode = 'NO'
  ;String currentSsid = 'NO';
  String currentPassword = 'NO';


  @override
  Widget build(BuildContext context) {
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
            ListTile(
              title: Text('Tailight Mode'),
              subtitle: Text('Current Mode: $_value'), // Display current mode
              onTap: () {
                _sendData([0x02, 0x01, 0x13, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17]);
              },
            ),
            Divider(),
            ListTile(
              title: Text('WiFi'),
              subtitle: Text('Current SSID: $_value\nCurrent Password: $_value'), // Display current SSID and password
              onTap: () {
                _sendData([0x02, 0x01, 0x20, 0x00, 0x01, 0x24]);
              },
            ),
            ListTile(
              title: Text('WiFi Settings'),
              subtitle: Text('Set SSID/Password'),
              onTap: () {
                setState(() {
                  showWifiSettings = !showWifiSettings; // Toggle the flag
                });
              },
            ),
            Divider(),
            // SSID SET & PASSWORD
            if (showWifiSettings)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: TextField(
                        controller: ssidController,
                        decoration: InputDecoration(
                          labelText: 'SSID: $ssidVal',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      child: ElevatedButton(
                        child: Text('Change SSID'),
                        onPressed: () {
                          String ssid = ssidController.text.trim();
                          _sendData([0x02, 0x01, 0x21, 0x00, 0x04, 0x77, 0x69, 0x66, 0x69, 0x08, 0x0A, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x8d]);
                          // changeSSID(ssid);
                        },
                      ),
                    ),
                    SizedBox(height: 16), // Add vertical spacing
                    Container(
                      child: TextField(
                        controller: passController,
                        decoration: InputDecoration(
                          labelText: 'Pass: $passVal',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      child: ElevatedButton(
                        child: Text('Change WiFi Pass'),
                        onPressed: () {
                          String pass = passController.text.trim();
                          // changePASS(pass);
                        },
                      ),
                    ),
                  ],
                ),
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
          ],
        ),
      ),
    );
  }
}