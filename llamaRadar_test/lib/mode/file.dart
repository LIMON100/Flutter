import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
class Files extends StatefulWidget {
  List<FileItem> images = [];
  List<FileItem> videos = [];

  Files({
    required this.images,
    required this.videos,
  });

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {

  String? selectedFilePath;
  VideoPlayerController? videoController;

  List<String> items = [
    "All",
    "Video",
    "Photos",
  ];

  /// List of body icon
  List<IconData> icons = [
    Icons.home,
    Icons.video_file,
    Icons.photo,
  ];
  int current = 0;
  List<FileItem> images = [];
  List<FileItem> videos = [];
  List<FileName> imagesName = [];
  List<FileName> videoName = [];
  bool isLoadingFiles = false;


  @override
  void initState() {
    super.initState();
    cyclicRecordStateOn();
    images = widget.images;
    videos = widget.videos;
    Connectivity().onConnectivityChanged.listen((connectivity) {
      if (connectivity == ConnectivityResult.wifi) {
        getFilesFromCamera();
      }
    });
    getFilesFromCamera();
  }

  // auto record on/off
  Future<void> cyclicRecordStateOn() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2012&par=1'));
    if (response.statusCode == 200) {
      //fileList = json.decode(response.body);
      print('HDR');
    } else {
      print('Cam error: ${response.statusCode}');
    }
  }

  // Open File
  void openImageOrPlayVideo(String file) {
    if (file.endsWith('.JPG')) {
      // Display the image
      String thumbnailUrl = 'http://192.168.1.254/CARDV/Photo/$file';
      // Show the image using a dialog or navigate to a new screen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: Image.network(thumbnailUrl),
        ),
      );
    } else if (file.endsWith('.MP4')) {
      // Play the video
      String videoUrl = 'http://192.168.1.254/CARDV/Movie/$file';

      // Initialize the video player controller
      VideoPlayerController controller = VideoPlayerController.network(videoUrl);

      // Show the video player widget
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing the dialog with a tap outside
        builder: (context) {
          // Add a listener to detect when the dialog is dismissed
          void handleDialogDismiss() {
            controller.pause(); // Pause the video playback
            controller.seekTo(Duration.zero); // Rewind the video to the beginning
            controller.dispose(); // Dispose of the video player controller
          }

          // Create the dialog content with video player and cross icon
          Widget dialogContent = GestureDetector(
            onTap: () {}, // Prevent accidental tap dismissal
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(controller),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),
                      color: Colors.red, // Set the color to red
                      onPressed: () {
                        handleDialogDismiss();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );

          // Initialize and play the video
          controller.initialize().then((_) {
            controller.play();
          });

          // Add a listener to detect when the dialog is dismissed
          return WillPopScope(
            onWillPop: () async {
              handleDialogDismiss();
              return true;
            },
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0.0),
              content: dialogContent,
            ),
          );
        },
      );
    }
  }

  Future<void> getFilesFromCamera() async {
    String url = 'http://192.168.1.254/?custom=1&cmd=3015';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final xmlDoc = xml.XmlDocument.parse(response.body);
        final fileElements = xmlDoc.findAllElements('File');

        // Clear the existing lists before updating
        setState(() {
          images.clear();
          videos.clear();
        });

        for (final fileElement in fileElements) {
          final nameElement = fileElement.findElements('NAME').single;
          final filePathElement = fileElement.findElements('FPATH').single;
          final timeElement = fileElement.findElements('TIME').single;

          final name = nameElement.text;
          final filePath = filePathElement.text;
          final time = timeElement.text;

          final fileItem = FileItem(name, filePath, time);
          final fileName = FileName(name);

          if (name.endsWith('.JPG')) {
            setState(() {
              images.add(fileItem);
              imagesName.add(fileName);
            });
          } else if (name.endsWith('.MP4')) {
            setState(() {
              videos.add(fileItem);
              videoName.add(fileName);
            });
          }
        }
      } else {
        print('Error occurred: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Delete file
  Future<void> deleteFile(String filePath) async {
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
      } else {
        print('Failed to delete file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to delete file: $e');
    }
  }

  Future<void> deleteAllFiles() async {
    try {
      if (current == 0) {
        // Delete all files
        final allFilesUrl = Uri.parse('http://192.168.1.254/?custom=1&cmd=4004');
        final response = await http.get(allFilesUrl);
        if (response.statusCode == 200) {
          print('All files deleted successfully');
          await getFilesFromCamera();
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
            } else {
              print('Failed to delete file: $fileName. Status code: ${deleteResponse.statusCode}');
            }
          }
          await getFilesFromCamera();
        }
        else {
          print('Failed to delete images. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Failed to delete files: $e');
    }
  }

  // Download files
  bool _isDownloading = false;
  double _progress = 0.0;
  int? _downloadIndex;
  // int receivedBytes = 0;

  void _downloadFile(String url, int index) async {
    if (url.endsWith('.JPG')) {
      url = 'http://192.168.1.254/CARDV/photo/$url';
    } else {
      url = 'http://192.168.1.254/CARDV/Movie/$url';
    }

    setState(() {
      _isDownloading = true;
      _progress = 0.0;
      _downloadIndex = index;
    });

    try {
      final response = await http.get(Uri.parse(url),
          headers: {'Accept-Encoding': 'identity'});

      if (response.statusCode == 200) {
        final totalBytes = response.contentLength?.toDouble() ?? 0.0;
        final fileName = url.split('/').last;
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        int receivedBytes = 0;

        final bytes = response.bodyBytes;

        final completer = Completer<void>();

        final fileStream = file.openWrite();

        fileStream.add(bytes);
        receivedBytes += bytes.length;
        print("Progress in receivebytes");
        setState(() {
          _progress = receivedBytes.toDouble() / totalBytes;
        });

        await fileStream.close();


        if (url.endsWith('.JPG')) {
          await GallerySaver.saveImage(filePath);
        } else {
          await GallerySaver.saveVideo(filePath);
        }

        print('File saved to gallery: $fileName');

        setState(() {
          _isDownloading = false;
        });

        Fluttertoast.showToast(
          msg: 'Download complete',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        print('Error downloading file: ${response.statusCode}');
        setState(() {
          _isDownloading = false;
        });
      }
    } catch (e) {
      print('Error downloading file: $e');
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    List<FileItem> displayItems;

    if (current == 1) {
      // Show videos
      displayItems = videos;
    } else if (current == 2) {
      // Show images
      displayItems = images;
    } else {
      // Show all items
      displayItems = [...videos, ...images];
    }

    final bool allFiles = videos.isNotEmpty;
    final bool hasVideos = videos.isNotEmpty;
    final bool hasImages = images.isNotEmpty;
    final bool showTabs = hasVideos || hasImages;
    final bool showEmptyTabs = videos.isEmpty || images.isEmpty;


    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: const Text('FILES'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(45),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  final bool showTab =
                      (index == 0 && (allFiles || !showTabs || showEmptyTabs)) || (index == 1 && (hasVideos || !showTabs || showEmptyTabs)) || (index == 2 && (hasImages || !showTabs || showEmptyTabs));
                  return Visibility(
                    visible: showTab,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 90,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index ? Colors.white70 : Colors.white54,
                              borderRadius: current == index ? BorderRadius.circular(15) : BorderRadius.circular(10),
                              border: current == index ? Border.all(color: Colors.deepPurpleAccent, width: 2) : null,
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: GoogleFonts.laila(
                                  fontWeight: FontWeight.w500,
                                  color: current == index ? Colors.black : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: current == index,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (displayItems.isNotEmpty)
                        ListTile(
                          leading: Icon(Icons.delete_forever),
                          title: Text('Delete All Files'),
                          onTap: () {
                            deleteAllFiles();
                          },
                        ),
                      if (displayItems.isEmpty)
                        Icon(
                          icons[current],
                          size: 200,
                          color: Colors.deepPurple,
                        ),
                      if (displayItems.isEmpty) const SizedBox(height: 10),
                      if (displayItems.isEmpty)
                        Text(
                          items[current],
                          style: GoogleFonts.laila(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                            color: Colors.deepPurple,
                          ),
                        ),
                      SizedBox(height: 20),
                      if (displayItems.isNotEmpty)
                      // WITH ICON
                      //   ListView.builder(
                      //     shrinkWrap: true,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemCount: displayItems.length,
                      //     itemBuilder: (context, index) {
                      //       final bool isImage = displayItems[index].name.endsWith('.JPG');
                      //       final bool isVideo = displayItems[index].name.endsWith('.MP4');
                      //
                      //       IconData iconData;
                      //       if (isImage) {
                      //         iconData = Icons.photo;
                      //       } else if (isVideo) {
                      //         iconData = Icons.videocam;
                      //       } else {
                      //         // Handle other file types if needed
                      //         iconData = Icons.insert_drive_file;
                      //       }
                      //       if (_isDownloading && _downloadIndex == index) {
                      //         // Show circular progress bar and cancel option
                      //         return ListTile(
                      //           leading: SizedBox(
                      //             width: 30,
                      //             height: 30,
                      //             child: CircularProgressIndicator(
                      //               value: _progress,
                      //               strokeWidth: 2.0,
                      //               backgroundColor: Colors.black,
                      //               valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      //             ),
                      //           ),
                      //           title: Text(displayItems[index].name),
                      //           subtitle: Text(displayItems[index].time),
                      //           trailing: IconButton(
                      //             icon: Icon(Icons.close),
                      //             onPressed: () {
                      //               setState(() {
                      //                 _isDownloading = false;
                      //                 _downloadIndex = -1;
                      //               });
                      //             },
                      //           ),
                      //         );
                      //       } else {
                      //         // Show regular list tile with download button
                      //         return ListTile(
                      //           leading: Icon(iconData),
                      //           title: Text(displayItems[index].name),
                      //           subtitle: Text(displayItems[index].time),
                      //           trailing: Row(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               IconButton(
                      //                 icon: Icon(Icons.delete),
                      //                 onPressed: () {
                      //                   deleteFile(displayItems[index].name.toString());
                      //                 },
                      //               ),
                      //               IconButton(
                      //                 icon: Icon(Icons.download),
                      //                 onPressed: _isDownloading
                      //                     ? null
                      //                     : () => _downloadFile(displayItems[index].name.toString(), index),
                      //               ),
                      //             ],
                      //           ),
                      //           onTap: () {
                      //             openImageOrPlayVideo(displayItems[index].name);
                      //           },
                      //         );
                      //       }
                      //     },
                      //   ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: displayItems.length,
                          itemBuilder: (context, index) {
                            final bool isImage = displayItems[index].name.endsWith('.JPG');
                            final bool isVideo = displayItems[index].name.endsWith('.MP4');

                            IconData iconData;
                            if (isImage) {
                              iconData = Icons.photo;
                            } else if (isVideo) {
                              iconData = Icons.videocam;
                            } else {
                              // Handle other file types if needed
                              iconData = Icons.insert_drive_file;
                            }

                            Widget leadingWidget;
                            if (isVideo) {
                              // Generate and display video thumbnail
                              leadingWidget = FutureBuilder<Uint8List?>(
                                future: VideoThumbnail.thumbnailData(
                                  video: displayItems[index].name, // Provide the video file path
                                  imageFormat: ImageFormat.JPEG,
                                  maxWidth: 100, // Adjust the size as needed
                                  quality: 25, // Adjust the quality as needed
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                    return Image.memory(snapshot.data!); // Use snapshot.data! to access non-nullable value
                                  } else {
                                    return Icon(iconData); // Display an icon if thumbnail loading fails
                                  }
                                },
                              );
                            } else {
                              leadingWidget = Icon(iconData);
                            }

                            if (_isDownloading && _downloadIndex == index) {
                              // Show circular progress bar and cancel option
                              return ListTile(
                                leading: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    value: _progress,
                                    strokeWidth: 2.0,
                                    backgroundColor: Colors.black,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                  ),
                                ),
                                title: Text(
                                  displayItems[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold), // Make the name bold
                                ),
                                subtitle: Text(displayItems[index].time),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _isDownloading = false;
                                      _downloadIndex = -1;
                                    });
                                  },
                                ),
                              );
                            } else {
                              // Show regular list tile with download button
                              return ListTile(
                                leading: leadingWidget,
                                title: Text(
                                  displayItems[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold), // Make the name bold
                                ),
                                subtitle: Text(displayItems[index].time),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        deleteFile(displayItems[index].name.toString());
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.download),
                                      onPressed: _isDownloading
                                          ? null
                                          : () => _downloadFile(displayItems[index].name.toString(), index),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  openImageOrPlayVideo(displayItems[index].name);
                                },
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
