import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  get radius => null;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getCurrentDateTime();
    // Amplify.DataStore.start();
  }

  Future<void> getCurrentLocation() async {
    // Simulate getting the current location (replace with actual implementation)
    // For demonstration, using fixed coordinates
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

      final key3 = "limon/2024-01-05/" + key2;
      print("filePath");
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
    RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    // if (byteData != null) {
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    // Save image to a temporary file
    final tempDir = await getTemporaryDirectory();
    print("DIRECTORY");
    print(tempDir);
    final file = File('${tempDir.path}/captured_image22.png');
    await file.writeAsBytes(pngBytes!);

    final fileKey = await uploadFile(file);
    print("CHECKKEY");
    print(fileKey);
    await Future.delayed(Duration(seconds: 1));
    final imageUrl = await getImageUrl(fileKey.toString());

    return imageUrl;
  }


  // Upload data
  Future<void> createHistory() async {
    final imageUrlNew = await uploadImage();
    print("IMAGGEURL");
    print(imageUrlNew);
    try {
      final model = History(
          latitude: 100.23,
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
    // Amplify.DataStore.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Submission Screen'),
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
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  color: Colors.white,
                  height: 100, // Adjust the height as needed
                  child: Center(
                    child: Text('TEST WITH SEPRATE DATE'),
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
