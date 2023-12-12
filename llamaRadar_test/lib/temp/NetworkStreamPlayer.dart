import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';


class NetworkStreamPlayer extends StatefulWidget {
  @override
  _NetworkStreamPlayerState createState() => _NetworkStreamPlayerState();
}

class _NetworkStreamPlayerState extends State<NetworkStreamPlayer> {
  final String videoUrl = 'rtsp://username:password@ip_address:554/stream/channel=1/0';
  final VlcPlayerController _controller = VlcPlayerController.network(
    'rtsp://username:password@ip_address:554/stream/channel=1/0',
    options: VlcPlayerOptions(),
  );
  bool _isPlaying = false;
  Uint8List? _screenshot;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _takeScreenshot() async {
    try {
      final screenshot = await _controller.takeSnapshot();
      print("SCREEN");
      print(screenshot);
      setState(() {
        _screenshot = screenshot;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        actions: [
          ElevatedButton(
            onPressed: _takeScreenshot,
            child: Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: Column(
        children: [
          VlcPlayer(
            controller: _controller,
            placeholder: Center(child: CircularProgressIndicator()),
            aspectRatio: 16 / 9,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _togglePlay,
            child: _isPlaying ? Text('Pause') : Text('Play'),
          ),
          SizedBox(height: 16),
          if (_screenshot != null)
            Image.memory(
              _screenshot!,
              width: 300, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
        ],
      ),
    );
  }
}
