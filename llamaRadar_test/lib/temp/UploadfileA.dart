import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lamaradar/ride_history/maps/maker_with_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/History.dart';
import '../sqflite/sqlite.dart';

class UploadFileA extends StatefulWidget  {
  final String email;
  UploadFileA({required this.email});

  @override
  _UploadFileAState createState() => _UploadFileAState();
}

class _UploadFileAState extends State<UploadFileA> {
  List<Map<String, dynamic>> _gpsCoordinates = [];
  late ImagePicker _imagePicker;
  XFile? _imageFile;
  List<Uint8List?> _imageList = [];

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
    _fetchGpsCoordinates();
  }

  // Fetch all data based on date
  Future<void> _fetchGpsCoordinates() async {
    final Database db = await GpsDatabaseHelper().initDatabase();
    final List<Map<String, dynamic>> gpsCoordinates = await db.query(
      'gps_coordinates_A',
      where: 'email = ?',
      whereArgs: [widget.email.toString()],
    );

    setState(() {
      _gpsCoordinates = gpsCoordinates;
      //Extra
      _imageList = _gpsCoordinates
          .map<Uint8List?>((coordinate) => _getImageBytes(coordinate['image']))
          .toList();
    });
    print("GPSLENGHTH");
    print(_gpsCoordinates.length);
  }

  Uint8List? _getImageBytes(dynamic imageData) {
    if (imageData is Uint8List) {
      return imageData;
    }
    else if (imageData is String) {
      return Uint8List.fromList(base64Decode(imageData));
    }
    return null;
  }

  bool isValidImage(Uint8List? imageData) {
    return imageData != null && imageData.isNotEmpty;
  }


  // AWS UPLOADING PART---------------------------
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
  Future<String?> uploadFile(File file, String newDate) async {
    try {
      final extension = file.path;
      final key = const Uuid().v1() + extension;
      final key2 = const Uuid().v1() + '.png';
      final awsFile = AWSFile.fromPath(file.path);

      final key3 = "$userUniqueName/$newDate/" + key2;
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

  Future<String?> uploadImage(Uint8List? _screenshotVLC, String date)
  async {
    if (_screenshotVLC != null) {
      File tempFile = await _createTemporaryFile(_screenshotVLC!);
      print("CHECKKEY");
      print(_screenshotVLC);
      print(tempFile);
      final fileKey = await uploadFile(tempFile, date);
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

  Future<void> createHistory() async {
    // final imageUrlNew = await uploadImage();
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading..."),
              ],
            ),
          );
        },
      );

      for (int i = 0; i < _gpsCoordinates.length; i++) {
        print(_gpsCoordinates[i]);
        // print(_gpsCoordinates[i]['image']);
        // print("\n");
        final imageUrlNew = await uploadImage(_gpsCoordinates[i]['image'], _gpsCoordinates[i]['date'].toString());
        final model = History(
          userUniqueId: userUniqueName,
          latitude: _gpsCoordinates[i]['latitude'],
          longitude: _gpsCoordinates[i]['longitude'],
          date: TemporalDate.fromString(_gpsCoordinates[i]['date']),
          time: TemporalTime.fromString(_gpsCoordinates[i]['time']),
          position: _gpsCoordinates[i]['position'],
          imageUrl: imageUrlNew,
          imagekey: fileKeyFinal,
        );

        final request = ModelMutations.create(model);
        final response = await Amplify.API.mutate(request: request).response;

        final createdHistory = response.data;
        if (createdHistory == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    } finally {
      Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text("TEST LOCAL Upload"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await createHistory();
              },
              style: ElevatedButton.styleFrom(
                elevation: 3,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                primary: Colors.blueGrey, // Change to your preferred color
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              child: Text(
                "UPLOAD TO AWS",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}