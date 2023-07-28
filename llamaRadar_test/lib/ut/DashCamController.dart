import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';

class FileItem {
  final String name;
  final String filePath;
  // final String size;
  final String time;

  FileItem(this.name, this.filePath, this.time);
}

class FileName {
  final String name;
  FileName(this.name);
}


class DashCamController {
  final http.Client client;
  DashCamController(this.client);

  late VlcPlayerController _videoPlayerController;
  List<FileItem> images = [];
  List<FileItem> videos = [];


  // Initialize player
  Future<bool> initializePlayer() async {
    try {
      _videoPlayerController = VlcPlayerController.network(
        'rtsp://192.168.1.254/xxxx.mp4?network-caching=1?clock-jitter=0?clock-synchro=0',
        hwAcc: HwAcc.disabled,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
      return true; // Return true if the player is initialized successfully
    } catch (e) {
      print('Error initializing player: $e');
      return false; // Return false if there is an error while initializing the player
    }
  }

  // List of available files in sd-card
  Future<void> getFilesFromCamera() async {

    String url = 'http://192.168.1.254/?custom=1&cmd=3015';

    try {
      // final response = await http.get(Uri.parse(url));
      final response = await http
          .get(Uri.parse(url));

      if (response.statusCode == 200) {
        final xmlDoc = xml.XmlDocument.parse(response.body);
        final fileElements = xmlDoc.findAllElements('File');

        for (final fileElement in fileElements) {
          final nameElement = fileElement.findElements('NAME').single;
          final filePathElement = fileElement.findElements('FPATH').single;
          final timeElement = fileElement.findElements('TIME').single;

          final name = nameElement.text;
          final filePath = filePathElement.text;
          final time = timeElement.text;

          final fileItem = FileItem(name, filePath, time);

          if (name.endsWith('.JPG')) {
            images.add(fileItem);
          } else if (name.endsWith('.MP4')) {
            videos.add(fileItem);
          }
        }
      } else {
        print('Error occurred: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Start recording
  Future<bool> startRecordingCmd() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=2001&par=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Recording started...');
        return true; // Return true if recording started successfully
      } else {
        print('Error occurred: ${response.statusCode}');
        return false; // Return false if there was an error
      }
    } catch (e) {
      print('Error: $e');
      return false; // Return false if there was an exception
    }
  }

  // Stop recording
  Future<bool> stopRecordingCmd() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=2001&par=0';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Recording stopped...');
        return true;
      } else {
        print('Error occured while stopping record: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  //Take pictures
  Future<bool> takePicture() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=1001';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Image captured');
        await getFilesFromCamera();
        return true;

      } else {
        print('Error occured: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Delete file
  Future<bool> deleteFile(String filePath) async {
    final Uri url;

    if (filePath.endsWith('.JPG')) {
      url = Uri.parse('http://192.168.1.254/CARDV/photo/$filePath');
    } else {
      url = Uri.parse('http://192.168.1.254/CARDV/Movie/$filePath');
    }

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('File deleted successfully');
        await getFilesFromCamera();
        return true;
      } else {
        print('Failed to delete file. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Failed to delete file: $e');
      return false;
    }
  }

  //Delete All files
  int current = 0;
  List<FileName> imagesName = [];
  List<FileName> videoName = [];
  Future<bool> deleteAllFiles() async {
    try {
      bool success = false;

      if (current == 0) {
        // Delete all files
        final allFilesUrl = Uri.parse('http://192.168.1.254/?custom=1&cmd=4004');
        final response = await http.get(allFilesUrl);
        if (response.statusCode == 200) {
          print('All files deleted successfully');
          await getFilesFromCamera();
          success = true;
        } else {
          print('Failed to delete all files. Status code: ${response.statusCode}');
        }
      } else if (current == 1) {
        // Delete only videos
        final videosUrl = Uri.parse('http://192.168.1.254/CARDV/movie/');
        final response = await http.get(videosUrl);
        if (response.statusCode == 200) {
          for (final fileName in videoName) {
            final filePath = fileName.name;
            final deleteUrl = Uri.parse('http://192.168.1.254/CARDV/movie/$filePath');
            final deleteResponse = await http.delete(deleteUrl);
            if (deleteResponse.statusCode == 200) {
              print('Deleted file: $fileName');
              success = true;
            } else {
              print('Failed to delete file: $fileName. Status code: ${deleteResponse.statusCode}');
            }
          }
          await getFilesFromCamera();
        } else {
          print('Failed to delete videos. Status code: ${response.statusCode}');
        }
      } else if (current == 2) {
        // Delete only images
        final imagesUrl = Uri.parse('http://192.168.1.254/CARDV/photo/');
        final response = await http.get(imagesUrl);
        if (response.statusCode == 200) {
          for (final fileName in imagesName) {
            final filePath = fileName.name;
            final deleteUrl2 = Uri.parse('http://192.168.1.254/CARDV/photo/$filePath');
            final deleteResponse = await http.delete(deleteUrl2);
            if (deleteResponse.statusCode == 200) {
              print('Deleted file: $fileName');
              success = true;
            } else {
              print('Failed to delete file: $fileName. Status code: ${deleteResponse.statusCode}');
            }
          }
          await getFilesFromCamera();
        } else {
          print('Failed to delete images. Status code: ${response.statusCode}');
        }
      }

      return success;
    } catch (e) {
      print('Failed to delete files: $e');
      return false;
    }
  }

  // Download file -> 20210101000013_000000.MP4
  // bool isDownloading = false;
  // double _progress = 0.0;
  // int? downloadIndex;
  //
  // Future<bool> downloadFile(String url, int index) async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //
  //   if (url.endsWith('.JPG')) {
  //     url = 'http://192.168.1.254/CARDV/photo/$url';
  //   } else {
  //     url = 'http://192.168.1.254/CARDV/Movie/$url';
  //   }
  //
  //   isDownloading = true;
  //   _progress = 0.0;
  //   downloadIndex = index;
  //
  //
  //   try {
  //     print("INSIDE DOWNLOAD TRY");
  //     final response = await http.get(Uri.parse(url), headers: {'Accept-Encoding': 'identity'});
  //
  //     if (response.statusCode == 200) {
  //       final totalBytes = response.contentLength?.toDouble() ?? 0.0;
  //       final fileName = url.split('/').last;
  //       final directory = await getTemporaryDirectory();
  //       final filePath = '${directory.path}/$fileName';
  //       final file = File(filePath);
  //       int receivedBytes = 0;
  //
  //       final bytes = response.bodyBytes;
  //
  //       final fileStream = file.openWrite();
  //
  //       fileStream.add(bytes);
  //       receivedBytes += bytes.length;
  //
  //
  //       await fileStream.close();
  //
  //       // if (url.endsWith('.JPG')) {
  //       //   await GallerySaver.saveImage(filePath);
  //       // } else {
  //       //   await GallerySaver.saveVideo(filePath);
  //       // }
  //
  //       print('File saved to gallery: $fileName');
  //
  //
  //       isDownloading = false;
  //
  //
  //       // Return true since the download is completed successfully
  //       return true;
  //     } else {
  //       print('Error downloading file: ${response.statusCode}');
  //
  //       isDownloading = false;
  //
  //       // Return false since there was an error during download
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error downloading file: $e');
  //
  //     isDownloading = false;
  //
  //     // Return false since there was an error during download
  //     return false;
  //   }
  // }



}
