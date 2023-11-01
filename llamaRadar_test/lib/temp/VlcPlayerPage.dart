import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gallery_saver/files.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';
import 'package:http/http.dart' as http;


enum GSensorLevel {
  OFF,
  LOW,
  MED,
  HIGH,
}

class VlcPlayerPage extends StatefulWidget {
  @override
  _VlcPlayerPageState createState() => _VlcPlayerPageState();
}

class _VlcPlayerPageState extends State<VlcPlayerPage> {
  VlcPlayerController? _vlcController;

  double _brightnessLevel = 1.0;
  late BrightnessController _brightnessController;
  Orientation currentOrientation = Orientation.portrait;
  static const String rotationAngleKey = 'rotation_angle';
  double rotationAngle = 0.0;
  DateTime frameReceivedTime = DateTime.now();
  DateTime frameDisplayTime = DateTime.now();
  Duration latency = Duration.zero;

  @override
  void initState() {
    super.initState();
    // _vlcController = VlcPlayerController.network(
    //   'rtsp://192.168.1.254/xxxx.mov',
    //   hwAcc: HwAcc.disabled,
    //   autoPlay: true,
    //   options: VlcPlayerOptions(
    //     advanced: VlcAdvancedOptions([
    //       VlcAdvancedOptions.networkCaching(0),
    //       VlcAdvancedOptions.clockJitter(0),
    //       VlcAdvancedOptions.fileCaching(0),
    //       VlcAdvancedOptions.liveCaching(0),
    //     ]),
    //     rtp: VlcRtpOptions([
    //       VlcRtpOptions.rtpOverRtsp(true),
    //       ":rtsp-tcp",
    //     ]),
    //   ),
    // );
    _vlcController = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
          // video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
          //   VlcVideoOptions.skipFrames(true)],),

          advanced: VlcAdvancedOptions([
                VlcAdvancedOptions.networkCaching(0),
                VlcAdvancedOptions.clockJitter(0),
                VlcAdvancedOptions.fileCaching(0),
                VlcAdvancedOptions.liveCaching(0),

          ]),
          rtp: VlcRtpOptions([
                VlcRtpOptions.rtpOverRtsp(true),
                ":rtsp-tcp",
              ]),
          extras: ['--h264-fps=120']
      ),);

    _loadRotationAngle();

    // _vlcController!.addListener(() {
    //   if (_vlcController!.value.isPlaying) {
    //     frameReceivedTime = DateTime.now();
    //     setState(() {
    //       latency = frameDisplayTime.difference(frameReceivedTime);
    //     });
    //   }
    // });
  }

  // int calculateLatency() {
  //   if (frameReceivedTime != null && frameDisplayTime != null) {
  //     latency = frameDisplayTime.difference(frameReceivedTime);
  //     return latency.inMilliseconds;
  //   }
  //   return 0;
  // }


  @override
  void dispose() {
    _vlcController?.removeListener(() {});
    _vlcController?.dispose();
    super.dispose();
  }

  void _loadRotationAngle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rotationAngle = prefs.getDouble(rotationAngleKey) ?? 0.0;
    });
  }

  // Save the current rotation angle to SharedPreferences
  void _saveRotationAngle(double angle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(rotationAngleKey, angle);
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


  // G-sensor for camera
  GSensorLevel selectedLevel = GSensorLevel.OFF;

  // Define the sensitivity level options
  List<GSensorLevel> sensitivityLevels = [
    GSensorLevel.OFF,
    GSensorLevel.LOW,
    GSensorLevel.MED,
    GSensorLevel.HIGH,
  ];

  // Map sensitivity level enum values to display strings
  Map<GSensorLevel, String> levelStrings = {
    GSensorLevel.OFF: 'OFF',
    GSensorLevel.LOW: 'LOW',
    GSensorLevel.MED: 'MID',
    GSensorLevel.HIGH: 'HIGH',
  };

  // Function to handle sensitivity level selection
  void onLevelSelected(GSensorLevel? level) {
    if (level != null) {
      setState(() {
        selectedLevel = level;
      });
      saveSelectedLevelToSettings(level); // Save the selected level
    }
  }


  // Implement the saveSelectedLevelToSettings function to save the selected level
  void saveSelectedLevelToSettings(GSensorLevel level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gsensor_sensitivity', level.index);
  }

  Future<void> gSensorSens() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2011&par=2'));
    if (response.statusCode == 200) {
      print('sensor activated');
      print(response.body);
    } else {
      print('G sensor Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VLC Player')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          currentOrientation = orientation;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Container(
                  width: 360, // Set the width of the fixed space
                  height: 400, // Set the height of the fixed space
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: currentOrientation == Orientation.portrait
                          ? 16 / 9
                          : 9 / 16,
                      child: Transform.rotate(
                        angle: rotationAngle * 3.14159265359 / 180,
                        child: VlcPlayer(
                          controller: _vlcController!,
                          aspectRatio: currentOrientation == Orientation.portrait
                              ? 16 / 9
                              : 9 / 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                ElevatedButton(
                  onPressed: changeOrientation,
                  child: Text('Change Orientation'),
                ),
                SizedBox(height: 20,),
                // Text(
                //   'Latency: ${latency?.inMilliseconds ?? 0} ms',
                //   style: TextStyle(fontSize: 20),
                // ),
                // Text('Select G-Sensor Sensitivity:'),
                // DropdownButton<GSensorLevel>(
                //   value: selectedLevel,
                //   onChanged: onLevelSelected,
                //   items: sensitivityLevels.map((GSensorLevel level) {
                //     return DropdownMenuItem<GSensorLevel>(
                //       value: level,
                //       child: Text(levelStrings[level] ?? ''),
                //     );
                //   }).toList(),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     gSensorSens(); // Call the function when the button is pressed
                //   },
                //   child: Text('Activate G-Sensor'),
                // ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class BrightnessController extends ChangeNotifier {
  double value = 1.0;
  void setBrightness(double brightness) {
    value = brightness;
    notifyListeners();
  }
}


