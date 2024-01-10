import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:lamaradar/temp/showAWSData.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uuid/uuid.dart';
import '../models/History.dart';


class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  GlobalKey globalKey = GlobalKey();
  String name = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String date = "";
  String time = "";

  String fileKeyFinal = "";
  String userUniqueName = "";
  String currentUniqueUser = "";
  get radius => null;

  @override
  void initState() {
    super.initState();
    getCurrentUserID();
    getCurrentLocation();
    getCurrentDateTime();
  }

  // VLC PLAYER START--------------------------------
  late VlcPlayerController _videoPlayerController;
  bool isCameraStreaming = false;
  Uint8List? _screenshot;
  Orientation currentOrientation = Orientation.portrait;
  bool isRearCamOpen = false;
  double rotationAngle = 0.0;

  Future<void> _takeScreenshot() async {
    try {
      final screenshot = await _videoPlayerController.takeSnapshot();
      setState(() {
        _screenshot = screenshot;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://192.168.1.254/xxxx.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(
          video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
            VlcVideoOptions.skipFrames(false)],),
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(30),
            VlcAdvancedOptions.clockJitter(0),
            VlcAdvancedOptions.fileCaching(30),
            VlcAdvancedOptions.liveCaching(30),
            VlcAdvancedOptions.clockSynchronization(1),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
            ":rtsp-tcp",
          ]),
          extras: ['--h264-fps=60'],
          // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
          sout: VlcStreamOutputOptions([
            VlcStreamOutputOptions.soutMuxCaching(0),
          ])
      ),);
    await _videoPlayerController!.initialize();
  }


  void toggleCameraStreaming() {
    if (isCameraStreaming) {
      _videoPlayerController.stop();
      _videoPlayerController.dispose();
    }
    else {
      Connectivity().onConnectivityChanged.listen((connectivity) {
        if (connectivity == ConnectivityResult.wifi) {
          _videoPlayerController = VlcPlayerController.network(
            'rtsp://192.168.1.254/xxxx.mp4',
            // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
            hwAcc: HwAcc.disabled,
            autoPlay: true,
            options: VlcPlayerOptions(
                video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
                  VlcVideoOptions.skipFrames(false)],),
                advanced: VlcAdvancedOptions([
                  VlcAdvancedOptions.networkCaching(30),
                  VlcAdvancedOptions.clockJitter(0),
                  VlcAdvancedOptions.fileCaching(30),
                  VlcAdvancedOptions.liveCaching(30),
                  VlcAdvancedOptions.clockSynchronization(1),
                ]),
                rtp: VlcRtpOptions([
                  VlcRtpOptions.rtpOverRtsp(true),
                  ":rtsp-tcp",
                ]),
                extras: ['--h264-fps=60'],
                // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
                sout: VlcStreamOutputOptions([
                  VlcStreamOutputOptions.soutMuxCaching(0),
                ])
            ),);
          _videoPlayerController.initialize().then((_) {
            _videoPlayerController.play();
          });
        }
      });

      _videoPlayerController = VlcPlayerController.network(
        'rtsp://192.168.1.254/xxxx.mp4',
        hwAcc: HwAcc.disabled,
        autoPlay: true,
        options: VlcPlayerOptions(
            video: VlcVideoOptions([VlcVideoOptions.dropLateFrames(true),
              VlcVideoOptions.skipFrames(false)],),
            advanced: VlcAdvancedOptions([
              VlcAdvancedOptions.networkCaching(30),
              VlcAdvancedOptions.clockJitter(0),
              VlcAdvancedOptions.fileCaching(30),
              VlcAdvancedOptions.liveCaching(30),
              VlcAdvancedOptions.clockSynchronization(1),
            ]),
            rtp: VlcRtpOptions([
              VlcRtpOptions.rtpOverRtsp(true),
              ":rtsp-tcp",
            ]),
            extras: ['--h264-fps=60'],
            // extras: [':network-caching=0', ':live-caching=0', ':file-caching=0', ':clock-jitter=0', ':clock-synchro=0','--h264-fps=60'],
            sout: VlcStreamOutputOptions([
              VlcStreamOutputOptions.soutMuxCaching(0),
            ])
        ),);
      _videoPlayerController.initialize().then((_) {
        _videoPlayerController.play();
      });
    }

    setState(() {
      isCameraStreaming = !isCameraStreaming;
      isRearCamOpen = !isRearCamOpen;
    });
  }

  Widget buildCameraButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (isCameraStreaming) // Show "Stop Rear Camera" button when streaming
              ElevatedButton(
                onPressed: toggleCameraStreaming,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  'Stop Rear Camera',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            if (!isCameraStreaming) // Show "Open Rear Cam" button when not streaming
              ElevatedButton(
                onPressed: toggleCameraStreaming,
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  'Open Rear Cam',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // VLC PLAYER END ----------------------------
  Future<void> getCurrentUserID() async {
    final currentUser = await Amplify.Auth.getCurrentUser();
    Map<String, dynamic> signInDetails = currentUser.signInDetails.toJson();
    currentUniqueUser = currentUser.userId;
    userUniqueName = signInDetails['username'];
    print(currentUser);
    setState(() {});
  }

  Future<void> getCurrentLocation() async {
    latitude = 37.7749;
    longitude = -122.4194;
  }

  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    date = DateFormat('yyyy-MM-dd').format(now);
    time = DateFormat('HH:mm:ss').format(now);
  }

  Future<void> captureAndSave() async {
    RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    // Simulate saving data (replace with actual implementation)
    // For demonstration, printing the data
    print('Name: $name');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('Date: $date');
    print('Time: $time');
    print('Screenshot: ${byteData?.lengthInBytes} bytes');

    // Clear the name field after submission (optional)
    setState(() {
      name = "";
    });
  }


  // Upload images
  Future<String> getImageUrl2(String key) async {
    print("STORAGEKEY");
    print(key);
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(days: 1),
          ),
        ),
      ).result;
      print(result.url.toString());
      return result.url.toString();
    } catch (e) {
      // Handle exceptions, log them, or return a default value if necessary
      print('Error in getImageUrl: $e');
      return ''; // Return a default value or handle the error appropriately
    }
  }



  Future<String> getImageUrl(String key) async {
    print("STORAGEKEY");
    print(key);
    try {
      final result = await Amplify.Storage.getUrl(
        key: key,
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(days: 1),
          ),
        ),
      ).result;
      return result.url.toString();
    } catch (e) {
      // Handle exceptions, log them, or return a default value if necessary
      print('Error in getImageUrl: $e');
      return ''; // Return a default value or handle the error appropriately
    }
  }


  // 1st test it save images with key+extension only, 2nd test it return key+png as a KEY
  Future<String?> uploadFile(File file) async {
    try {
      final extension = file.path;
      final key = const Uuid().v1() + extension;
      final key2 = const Uuid().v1() + '.png';
      final awsFile = AWSFile.fromPath(file.path);

      final key3 = "$userUniqueName/$date/" + key2;
      print("filePath");
      print(userUniqueName);
      print(key2);
      print(key3);
      // print(file.path);
      await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key: key3,
        onProgress: (progress) {
          progress.fractionCompleted;
        },
      );
      int index = key.indexOf("/data");
      String extractedValue = await index != -1 ? key.substring(0, index) : key;

      List<String> pathComponents = key.split('/');
      String uuidPart = pathComponents[0];
      String filename = pathComponents.last;
      String desiredKey = '$uuidPart/$filename';
      print("NEWNAMEW");
      print(desiredKey);

      fileKeyFinal = key3;
      return fileKeyFinal!;
    }
    on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> uploadImage()
  async {
    if (_screenshot != null) {
      File tempFile = await _createTemporaryFile(_screenshot!);
      print("CHECKKEY");
      print(_screenshot);
      print(tempFile);
      final fileKey = await uploadFile(tempFile);
      await Future.delayed(Duration(seconds: 1));
      final imageUrl = await getImageUrl(fileKey.toString());

      return imageUrl;
    }
  }

  Future<File> _createTemporaryFile(Uint8List data) async {
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/temp_file.png');
    await tempFile.writeAsBytes(data);
    return tempFile;
  }

  // Upload data
  Future<void> createHistory() async {
    _takeScreenshot();
    final imageUrlNew = await uploadImage();
    print("IMAGGEURL");
    print(imageUrlNew);
    try {
      final model = History(
          userUniqueId: userUniqueName,
          latitude: 9.2,
          longitude: longitude,
          date: TemporalDate.fromString(date),
          time: TemporalTime.fromString(time),
          position: "left",
          imageUrl: imageUrlNew.toString(),
          imagekey: fileKeyFinal
      );
      final request = ModelMutations.create(model);
      final response = await Amplify.API.mutate(request: request).response;

      final createdHistory = response.data;
      if (createdHistory == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      // safePrint('Mutation result: ${createdHistory.id}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  // Query data
  late List<History?> historyList = []; // Initialize with an empty list

  Future<List<History?>> queryListItems() async {
    try {
      final request = ModelQueries.list(History.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      print("ITEMS");
      historyList = items ?? []; // Assign items or an empty list if items is null

      if (items == null) {
        print('errors: ${response.errors}');
        return <History?>[];
      }
      return items;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return <History?>[];
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Latitude: $latitude'),
              Text('Longitude: $longitude'),
              Text('Date: $date'),
              Text('Time: $time'),
              SizedBox(height: 16),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align children to the start (left)
                  children: [
                    SizedBox(width: 70),
                    buildCameraButton(),
                    SizedBox(width: 75),
                  ],
                ),
              ),
              RepaintBoundary(
                key: GlobalKey(),
                child: Container(
                  height: 280,
                  width: 300,
                  child: Center(
                    child: Stack(
                      children: [
                        isCameraStreaming && _videoPlayerController != null
                            ? Transform.rotate(
                          angle: rotationAngle * 3.14159265359 / 180,
                          child: VlcPlayer(
                            controller: _videoPlayerController,
                            aspectRatio: currentOrientation == Orientation.portrait
                                ? 16 / 9
                                : 9 / 16,
                          ),
                        )
                            : Image.asset(
                          'images/test_background3.jpg',
                          fit: BoxFit.fitWidth,
                        ),
                        if (isCameraStreaming)
                          Positioned(
                            bottom: 16.0,
                            right: 16.0,
                            child: IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.cameraswitch_outlined),
                              onPressed: (){},
                              iconSize: 40.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => createHistory(),
                child: Text('SUBMIT'),
              ),

              ElevatedButton(
                // onPressed: () => getImageUrl2('283e3e80-a897-11ee-b57a-9707fee91674.png'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  ShowAwsData(),//MarkerWithImage(date: '2023-12-01'), //TestGps
                    ),
                  );
                },
                child: Text('Retreive data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
