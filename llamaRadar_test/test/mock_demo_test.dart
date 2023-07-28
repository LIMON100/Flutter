import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:utllama/ut/DashCamController.dart';
import 'package:utllama/mode/dash_cam.dart';


class MockClient extends Mock implements http.Client {}

void main() async {

  //CHECK Initialize player
  test('Test initializePlayer', () async {
    final mockClient = MockClient();
    final yourFileInstance = DashCamController(mockClient); // Replace YourClass with the actual class where initializePlayer() is defined

    // Perform the test and check the return value
    bool isPlayerInitialized = await yourFileInstance.initializePlayer();
    expect(isPlayerInitialized, true); // Assert that the player is successfully initialized

    // Add additional assertions for other scenarios if needed
  });

  // LIST OF AVAILABLE FILES IN DASHCAM
  test('Test getFilesFromCamera', () async {

    final mockClient = MockClient();

    final yourFileInstance = DashCamController(mockClient);

    await yourFileInstance.getFilesFromCamera();

    final images = yourFileInstance.images;
    final videos = yourFileInstance.videos;
    // Assert that the images and videos lists are updated correctly
    expect(images.length, 2);
    // expect(videos.length, 327);
    expect(images[0].name, '20230712001034_001616.JPG');
    expect(videos[0].name, '20230712001040_001617.MP4');
  });

  // Recording start
  test('Test recording',() async{
    final mockClient = MockClient();
    final recording = DashCamController(mockClient);

    bool isRecording = await recording.startRecordingCmd();
    expect(isRecording, true); // Assert that the player is successfully initialized
  });


  // TAKE PICTURES
  test('Test getFilesFromCamera', () async {

    final mockClient = MockClient();

    final dashController = DashCamController(mockClient);

    bool testResult = await dashController.takePicture();
    expect(testResult, true);

    await dashController.getFilesFromCamera();
    final images = dashController.images;
    // Assert that the images and videos lists are updated correctly
    expect(images.length, 22);
  });

  // DELETE SINGLE FILE
  test('Test getFilesFromCamera', () async {

    final mockClient = MockClient();

    final dashController = DashCamController(mockClient);

    bool testResult = await dashController.deleteFile('20230712001410_001624.MP4');
    expect(testResult, true);

    await dashController.getFilesFromCamera();
    final videos = dashController.videos;
    // Assert that the images and videos lists are updated correctly
    bool videoFound = false;
    for (var video in videos) {
      if (video.name == '20230712001040_001617.MP4') {
        videoFound = true;
        break;
      }
    }
    expect(videoFound, true);
  });

  // DELETE ALL FILE
  test('Test getFilesFromCamera', () async {

    final mockClient = MockClient();

    final dashController = DashCamController(mockClient);

    bool testResult = await dashController.deleteAllFiles();
    expect(testResult, true);

    await dashController.getFilesFromCamera();
    final videos = dashController.videos;
    final images = dashController.videos;
    // Assert that the images and videos lists are updated correctly
    expect(images.length, 0);
    expect(videos.length, 0);

  });
}

