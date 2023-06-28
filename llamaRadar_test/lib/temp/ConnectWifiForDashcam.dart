
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';


import 'package:lamaradar/mode/dash_cam.dart';

class ConnectWifiForDashCam extends StatefulWidget {
  const ConnectWifiForDashCam({Key? key}) : super(key: key);

  @override
  _ConnectWifiForDashCamState createState() => _ConnectWifiForDashCamState();
}

class _ConnectWifiForDashCamState extends State<ConnectWifiForDashCam> {

  bool isConnected = false;
  final String ssid = 'CARDV';
  final password = '12345678'; //@@@@####, 12345678

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
        // _startWifiScan(context);
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
        await Future.delayed(
            Duration(seconds: 2)); // Adjust the delay as needed

        List<dynamic> networks = await FlutterIotWifi.list();
        showDialog(
          context:
          context, // Use a parent context instead of the current context
          builder: (BuildContext dialogContext) {
            // Use a different variable for the dialog context
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
                        Navigator.of(dialogContext)
                            .pop(); // Close the dialog after selection using the dialog context
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
        await Future.delayed(
            Duration(seconds: 6)); // Adjust the delay as needed
        _startWifiScan(context);
      }
    } catch (e) {
      print('Failed to scan Wi-Fi networks: $e');
    }
  }


  void _connect(BuildContext context, String ssid) async {
    if (!mounted) {
      // Widget is no longer active, do not proceed
      return;
    }

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
    }
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
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.black,
          title: Text('Connect wifi'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2580B3),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // _connect(context);
                  _scanWifiNetworks(context);
                },
                child: Icon(
                  Icons.wifi,
                  color: isConnected ? Colors.green : Colors.black,
                  size: 50,
                ),
              ),
              Text(
                isConnected ? 'Disconnected' : 'Connect WIFI',
                style: TextStyle(
                  color: isConnected ? Colors.green : Colors.black,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              if (isConnected)
                GlowingButton2(
                  text: "Open Dashcam",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashCam(),
                      ),
                    );
                  },
                  color1: Color(0xFF517fa4),
                  color2: Colors.cyan,
                ),
            ],

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200, // Set a fixed height for the PageView
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imageList[index],
                        fit: BoxFit.cover,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 180),
                InkWell(
                  onTap: () {
                    // _connect(context);
                    _scanWifiNetworks(context);
                  },
                  child: Icon(
                    Icons.wifi,
                    color: isConnected ? Colors.green : Colors.black,
                    size: 50,
                  ),
                ),
                Text(
                  isConnected ? 'Disconnected' : 'Connect WIFI',
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.black,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                if (isConnected)
                  GlowingButton2(
                    text: "Open Dashcam",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashCam(),
                        ),
                      );
                    },
                    color1: Color(0xFF517fa4),
                    color2: Colors.cyan,
                  ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}