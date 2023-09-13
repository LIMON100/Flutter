import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';


class VlcPlayerPage extends StatefulWidget {
  @override
  _VlcPlayerPageState createState() => _VlcPlayerPageState();
}

class _VlcPlayerPageState extends State<VlcPlayerPage> {
  VlcPlayerController? _vlcController;

  double _brightnessLevel = 1.0;
  late BrightnessController _brightnessController;

  @override
  void initState() {
    super.initState();
    _vlcController = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(0),
          VlcAdvancedOptions.clockJitter(0),
          VlcAdvancedOptions.fileCaching(0),
          VlcAdvancedOptions.liveCaching(0),
        ]),
      ),
    );
    _brightnessController = BrightnessController();
    _vlcController!.addListener(() {
      _brightnessController.value = _vlcController!.value as double;
    });
  }

  @override
  void dispose() {
    _vlcController?.dispose();
    super.dispose();
  }
  double rotationAngle = 0.0;
  void changeOrientation() {
    setState(() {
      rotationAngle += 90.0; // Rotate by 90 degrees
      print("ROTATE ANGLE");
      print(rotationAngle);
      if (rotationAngle >= 360.0) {
        rotationAngle = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VLC Player')),
      body: Center(
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
                  aspectRatio: 16 / 9,
                  child: Transform.rotate(
                    angle: rotationAngle * 3.14159265359 / 180,
                    child: VlcPlayer(
                      controller: _vlcController!,
                      aspectRatio: 16 / 9,
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
          ],
        ),
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
