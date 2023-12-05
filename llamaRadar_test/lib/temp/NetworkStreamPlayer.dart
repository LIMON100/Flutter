import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:http/http.dart' as http;

class NetworkStreamPlayer extends StatefulWidget {
  @override
  _NetworkStreamPlayerState createState() => _NetworkStreamPlayerState();
}

class _NetworkStreamPlayerState extends State<NetworkStreamPlayer> {
  VlcPlayerController ?_controller;
  Orientation currentOrientation = Orientation.portrait;
  double rotationAngle = 0.0;
  String streamUrl = '';
  int networkCache = 1000; // Default network cache duration

  @override
  void initState() {
    super.initState();
    liveViewState();
    stopRecordState();
    _controller = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(50),
          VlcAdvancedOptions.fileCaching(50),
          VlcAdvancedOptions.liveCaching(50),
          VlcAdvancedOptions.clockSynchronization(1),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
          ":rtsp-tcp",
        ]),
          sout: VlcStreamOutputOptions([
            VlcStreamOutputOptions.soutMuxCaching(0),
          ])
      ),);
  }

  Future<void> liveViewState() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2015&par=1'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  Future<void> stopRecordState() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2001&par=0'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }
  void changeOrientation() {
    setState(() {
      rotationAngle += 90.0; // Rotate by 90 degrees
      if (rotationAngle >= 360.0) {
        rotationAngle = 0.0;
      }
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Stream Player'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter RTSP/HTTP URL',
            ),
            onChanged: (value) {
              setState(() {
                streamUrl = value;
              });
            },
          ),
          Row(
            children: [
              Text('Network Cache (0-1000ms)'),
              Slider(
                value: networkCache.toDouble(),
                onChanged: (value) {
                  setState(() {
                    networkCache = value.round();
                  });
                },
                min: 0,
                max: 1000,
                divisions: 20, // Adjust as needed
              ),
            ],
          ),

          // VlcPlayer(
          //   controller: _controller!,
          //   aspectRatio: 16 / 9, // Adjust for your video's aspect ratio
          // ),
          AspectRatio(
            aspectRatio: currentOrientation == Orientation.portrait
                ? 16 / 9
                : 9 / 16,
            child: Transform.rotate(
              angle: rotationAngle * 3.14159265359 / 180,
              child: VlcPlayer(
                controller: _controller!,
                aspectRatio: currentOrientation == Orientation.portrait
                    ? 16 / 9
                    : 9 / 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: changeOrientation,
            child: Text('Change Orientation'),
          ),
        ],
      ),
    );
  }

}
