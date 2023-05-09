import 'SideBar.dart';
import 'package:flutter/material.dart';
import 'package:lamaradar/temp//CollisionWarningPage.dart';
import 'package:lamaradar/mode/bleScreen.dart';

class WifiPage extends StatefulWidget {
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  final List<String> _wifiNames = ['Llama Defender(BLE)', 'Display(BLE)', 'Llama DashCam(wifi)'];
  String _selectedWifi = '';

  void _connectToWifi(String wifiName) {
    setState(() {
      _selectedWifi = wifiName;
    });
    // TODO: Connect to selected Wi-Fi.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('LLama'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xFF2580B3),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 60),
          Expanded(
            child: ListView.builder(
              itemCount: _wifiNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_wifiNames[index]),
                  trailing: _selectedWifi == _wifiNames[index]
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : ElevatedButton(
                    onPressed: () {
                      _connectToWifi(_wifiNames[index]);
                    },
                    child: Text('Connect'),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(45.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Pair Device to Start'),
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.all(30.0),
            child: ElevatedButton(
              onPressed: () {

              },
              child: Text('Go to Ride'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BleScreen(title: ''),
    );
  }
}

