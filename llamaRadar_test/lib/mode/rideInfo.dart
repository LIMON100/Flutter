import 'package:flutter/material.dart';

class RideInfo extends StatefulWidget {
  @override
  _RideInfoState createState() => _RideInfoState();
}

class _RideInfoState extends State<RideInfo> {
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
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.all(30.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Go to Ride'),
            ),
          ),
        ],
      ),
    );
  }
}