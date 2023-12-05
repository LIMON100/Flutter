import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamaradar/sideBar.dart';
import 'package:lamaradar/temp/glowing_button.dart';
import 'goToRide.dart';

class BleScreen extends StatefulWidget {
  BleScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  // final FlutterBluePlus flutterBlue = FlutterBluePlus();
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};


  @override
  _BleScreenState createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  final _writeController = TextEditingController();
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];

  bool _isScanning = false;
  String? _scanError;

  StreamSubscription<List<BluetoothDevice>>? connectedDevicesSubscription;
  StreamSubscription<List<ScanResult>>? scanResultsSubscription;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //  New
    // connectedDevicesSubscription =
    //     FlutterBluePlus.connectedDevices.asStream().listen((List<BluetoothDevice> devices) {
    //       for (BluetoothDevice device in devices) {
    //         _addDeviceTolist(device);
    //       }
    //     });

    List<BluetoothDevice> devs = FlutterBluePlus.connectedDevices;
    for (BluetoothDevice device in devs) {
      _addDeviceTolist(device);
    }
    scanResultsSubscription = FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
  }

  // Future<void> _startScan() async {
  //   try {
  //     // await widget.flutterBlue.startScan(timeout: Duration(seconds: 4));
  //     print("START");
  //     Set<DeviceIdentifier> seen = {};
  //     var subscription = FlutterBluePlus.scanResults.listen(
  //             (results) {
  //           for (ScanResult r in results) {
  //             if (seen.contains(r.device.remoteId) == false) {
  //               print('${r.device.remoteId}: "${r.device.localName}" found! rssi: ${r.rssi}');
  //               seen.add(r.device.remoteId);
  //             }
  //           }
  //         },
  //
  //     );
  //     await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
  //     setState(() {
  //       _isScanning = true;
  //       _scanError = null;
  //     });
  //   }
  //   catch (e) {
  //     print("Error starting scan: $e");
  //     setState(() {
  //       _scanError = e.toString();
  //     });
  //   }
  //
  //   setState(() {
  //     _isScanning = false;
  //   });
  // }
  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _scanError = null;
    });

    try {
      Set<DeviceIdentifier> seen = {};

      var subscription = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (seen.contains(r.device.remoteId) == false) {
            print('${r.device.remoteId}: "${r.device.localName}" found! rssi: ${r.rssi}');
            seen.add(r.device.remoteId);
          }
        }

      });

      // You can add a timeout to stop the scan after a certain duration
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

      // Cancel the scan subscription
      subscription.cancel();
    }
    catch (e) {
      print("Error starting scan: $e");
      setState(() {
        _scanError = e.toString();
      });
    }
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      _isScanning = false;
    });
  }


  //GO to another page
  ListView _buildListViewOfDevices() {
    List<Widget> containers = <Widget>[];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        SizedBox(
          height: 50,
          child: Row(
            children: <Widget>[
              SizedBox(height: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          device.name == '' ? '(unknown device)' : device.name),
                    ),
                    Expanded(
                      child: Text(device.id.toString()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextButton(
                  child: const Text(
                    'Connect',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    FlutterBluePlus.stopScan();
                    try {
                      await device.connect();
                    } on PlatformException catch (e) {
                      if (e.code != 'already_connected') {
                        rethrow;
                      }
                    } finally {
                      _services = await device.discoverServices();
                    }
                    setState(() {
                      _connectedDevice = device;
                    });

                    // Navigate to new page after connecting to device
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoToRide(device: device),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        SizedBox(height: 15),
        if (_isScanning)
          Center(
            child: SpinKitSpinningLines(
              color: Colors.blue,
              size: 150.0,
            ),
          )
        else
          Center(
            child: GlowingButton2(
              text: "Pair Device to Start",
              onPressed: () {
                _startScan();
              },
              color1: Color(0xFF517fa4),
              color2: Colors.cyan,
            ),
          ),
        ...containers,
      ],
    );
  }


  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: const Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child:
              const Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }
    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Widget> containers = <Widget>[];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = <Widget>[];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ${widget.readValues[characteristic.uuid]}'),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        ExpansionTile(
            title: Text(service.uuid.toString()),
            children: characteristicsWidget),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildView() {
    // if (_connectedDevice != null) {
    //   return _buildConnectDeviceView();
    // }
    return _buildListViewOfDevices();
  }

  @override
  void dispose() {
    connectedDevicesSubscription!.cancel();
    scanResultsSubscription!.cancel();
    super.dispose();
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
        drawer: SideBar(),
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.black,
          title: const Text('Llama Guard'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF517fa4),
            ),
          ),
        ),
        body: _buildView(),
      ),
    );
  }
}
