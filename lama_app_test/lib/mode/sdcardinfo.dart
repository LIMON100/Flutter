import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerFile {
  String filename;
  String url;

  ServerFile({required this.filename, required this.url});
}

class SdCardInfo extends StatefulWidget {

  const SdCardInfo({Key? key}) : super(key: key);

  @override
  _SdCardInfoState createState() => _SdCardInfoState();
}

class _SdCardInfoState extends State<SdCardInfo> {

  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final List<ServerFile> _files = [];

  Future<void> _fetchFiles() async {
    final response = await http.get(Uri.parse('https://example.com/files'));
    if (response.statusCode == 200) {
      final filesJson = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        _files.clear();
        for (final fileJson in filesJson) {
          final file = ServerFile(
            filename: fileJson['filename'] as String,
            url: fileJson['url'] as String,
          );
          _files.add(file);
        }
      });
    } else {
      throw Exception('Failed to load files');
    }
  }

  Future<void> _deleteFile(ServerFile file) async {
    final response = await http.delete(Uri.parse(file.url));
    if (response.statusCode == 200) {
      setState(() {
        _files.remove(file);
      });
    } else {
      throw Exception('Failed to delete file');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFCBBACC), Color(0xFF2580B3)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Sd Card"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: Color(0xFF6497d3),
              color: Color(0xFF2580B3),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start and stop app button and field
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {},
                //       child: Text('Upload file'),
                //     ),
                //     SizedBox(height: 16.0),
                //
                //     ElevatedButton(
                //       onPressed: () {},
                //       child: Text('Delete file'),
                //     ),
                //   ],
                // ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _files.length,
                    itemBuilder: (context, index) {
                      final file = _files[index];
                      return ListTile(
                        title: Text(file.filename),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete File?'),
                                content: Text('Are you sure you want to delete "${file.filename}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await _deleteFile(file);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _fetchFiles,
                    child: const Text('Refresh'),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}