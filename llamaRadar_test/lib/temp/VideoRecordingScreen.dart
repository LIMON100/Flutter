import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({Key? key}) : super(key: key);
  @override
  _VideoRecordingScreenState createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  late VlcPlayerController _controller;
  bool _isRecording = false;
  late String _recordedVideoPath;

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mov',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          ':network-caching=150',
        ]),
      ),
    );
  }

  void _toggleRecording() async {
    final recordCommandUrl = Uri.parse('http://192.168.1.254/?custom=1&cmd=2001&par=1');

    try {
      if (!_isRecording) {
        final response = await http.get(recordCommandUrl);
        if (response.statusCode == 200) {
          print('Video recording started');
          setState(() {
            _isRecording = true;
          });
        } else {
          print('Failed to start video recording');
        }
      } else {
        final stopRecordCommandUrl = Uri.parse('http://192.168.1.254/?custom=1&cmd=2001&par=0');
        final response = await http.get(stopRecordCommandUrl);
        if (response.statusCode == 200) {
          print('Video recording stopped');
          setState(() {
            _isRecording = false;
          });
          await _saveRecordedVideo();
        } else {
          print('Failed to stop video recording');
        }
      }
    } catch (e) {
      print('Error while performing video recording: $e');
    }
  }

  Future<void> _saveRecordedVideo() async {
    final appDir = await getApplicationDocumentsDirectory();
    final recordedVideoDir = Directory('${appDir.path}/RecordedVideos');
    await recordedVideoDir.create(recursive: true);
    final recordedVideoPath = '${recordedVideoDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Rename the last recorded video file
    if (_recordedVideoPath != null) {
      final recordedVideoFile = File(_recordedVideoPath);
      if (await recordedVideoFile.exists()) {
        await recordedVideoFile.rename(recordedVideoPath);
      }
    }

    setState(() {
      _recordedVideoPath = recordedVideoPath;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordedVideoScreen(recordedVideoPath)),
    );
  }

  Future<void> _showRecordedVideo() async {
    final appDir = await getApplicationDocumentsDirectory();
    final recordedVideoDir = Directory('${appDir.path}/RecordedVideos');
    if (await recordedVideoDir.exists()) {
      final recordedVideos = recordedVideoDir.listSync();
      if (recordedVideos.isNotEmpty) {
        final recordedVideoFile = recordedVideos.last;
        final recordedVideoPath = recordedVideoFile.path;
        setState(() {
          _recordedVideoPath = recordedVideoPath;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecordedVideoScreen(recordedVideoPath)),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Recording'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VlcPlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
              placeholder: Center(child: CircularProgressIndicator()),
            ),
          ),
          ElevatedButton(
            onPressed: _toggleRecording,
            child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
          ),
        ],
      ),
    );
  }
}

class RecordedVideoScreen extends StatelessWidget {
  final String videoPath;

  RecordedVideoScreen(this.videoPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recorded Video'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: VlcPlayer(
            controller: VlcPlayerController.file(File(videoPath)),
            aspectRatio: 16 / 9,
            placeholder: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: VideoRecordingScreen(),
//     routes: {
//       '/recordedVideo': (context) => RecordedVideoScreen(ModalRoute.of(context)!.settings.arguments as String),
//     },
//   ));
// }
