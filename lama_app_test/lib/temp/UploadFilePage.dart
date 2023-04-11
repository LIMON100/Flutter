import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class UploadFilePage extends StatefulWidget {
  const UploadFilePage({Key? key}) : super(key: key);

  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  double _progress = 0.0;
  File? _file;

  Future<void> _uploadFile() async {
    if (_file == null) return;

    final url = 'http://your-api-url.com/upload';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', _file!.path));

    final response = await request.send();
    final completer = Completer<http.Response>();
    response.stream.listen((data) {}, onDone: () async {
      final httpResponse = await http.Response.fromStream(response);
      completer.complete(httpResponse);
    });

    final httpResponse = await completer.future;
    final fileLength = httpResponse.contentLength ?? 0;

    final responseBytes = await httpResponse.bodyBytes;
    final responseStream = Stream.fromIterable([responseBytes]);

    await responseStream.listen((event) {
      setState(() {
        _progress = event.length / fileLength;
      });
    }).asFuture();

    setState(() {
      _progress = 0.0;
      _file = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File uploaded successfully')),
    );
  }




  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null || result.files.isEmpty) return;

    setState(() {
      _file = File(result.files.single.path!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_file != null) ...[
              const SizedBox(height: 20),
              Text('Selected file: ${_file!.path}'),
            ],
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectFile,
              child: const Text('Select file'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: const Text('Upload file'),
            ),
          ],
        ),
      ),
    );
  }
}
