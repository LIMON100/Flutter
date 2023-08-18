import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_saver/files.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:integration_test/integration_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';
import 'package:lamaradar/mode/LlamaDefenderPage.dart';
import 'package:lamaradar/mode/dash_cam.dart';
import 'package:lamaradar/main.dart' as app;
import 'package:lamaradar/temp/ConnectWifiForDashCam.dart';
import 'package:lamaradar/temp/glowing_button.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:lamaradar/mode/bleScreen.dart' as newapp;
import 'package:lamaradar/mode/goToRide.dart' as rideapp;
// import 'package:lamaradar/temp/CollisionWarningPage2.dart' as collisionapp;
import 'package:lamaradar/temp/CollisionWarningPage2.dart';
import 'package:lamaradar/mode/goToRide.dart';
import 'package:lamaradar/sideBar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import '../test/radar_test.dart';


class MockMethodChannel extends Mock implements MethodChannel {}

class WifiService {
  Future<bool?> scanWifi() async {
    return await FlutterIotWifi.scan();
  }
}

class MockAudioPlayer extends Mock implements AudioPlayer {}
class MockHttpClient extends Mock implements http.Client {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final circleButtonKey = GlobalKey();

  // PAIR AND NOTIFICATION PAGE
  // testWidgets('Test Go to Ride page', (WidgetTester tester) async {
  //   // final device = MockBluetoothDevice();
  //   app.main();
  //
  //   // Delay for a short period to allow the app to render
  //   await tester.pump(Duration(seconds: 2));
  //
  //   final findButton = find.byKey(Key("PairDevice"));
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 3)); // Increase the duration if needed
  //
  //   // Verify that the list of available devices is shown
  //   expect(find.byType(ListView), findsOneWidget);
  //
  //   // Delay to allow navigation to complete
  //   await tester.pumpAndSettle();
  //
  //   final connectButton = find.text('Connect');
  //   // Tap the "Connect" button
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //
  //
  //   await tester.pump(Duration(seconds: 2));
  //   // final findButton2 = find.byKey(Key("TurnOnWifiButton"));
  //   // final findButton21 = find.byWidget(ElevatedButton);
  //   final findButton2 = find.byType(ElevatedButton);
  //
  //   await tester.tap(findButton2);
  //   await tester.pumpAndSettle();
  //
  //   // expect(collisionapp.CollisionWarningPage2, findsOneWidget);
  //
  // });

  // testWidgets('Test ConnectWifiForDashCam', (WidgetTester tester) async {
  //   // Build the app
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: rideapp.GoToRide(device: MockBluetoothDevice()),
  //     ),
  //   );
  //
  //   final rideButton = find.byKey(Key("TurnOnWifiButton"));
  //   expect(rideButton, findsOneWidget);
  //   await tester.tap(rideButton);
  //   await tester.pumpAndSettle();
  //
  //   // Verify that the navigation to CollisionWarningPage2 occurs
  //   expect(find.byType(CollisionWarningPage2), findsOneWidget);
  //
  //   // Wait for the initial animations and transitions to complete
  //   await tester.pumpAndSettle();
  //
  //   await tester.pump(Duration(seconds: 5));
  //
  //   // Expect the dialog to appear
  //   // expect(find.byType(Dialog), findsOneWidget);
  //
  //   // Wait for the dialog to appear and settle
  //   await tester.pumpAndSettle();
  //   expect(find.byType(ListView), findsOneWidget);
  //
  //   // Now, search for the ListView widget inside the dialog content
  //   // final listViewFinder = find.descendant(
  //   //   of: find.byType(Dialog),
  //   //   matching: find.byType(ListView),
  //   // );
  //   // expect(listViewFinder, findsOneWidget);
  // });

  //SEND BLE WRITE DATA
  // testWidgets('Test BLE Data Sending', (WidgetTester tester) async {
  //
  //   app.main();
  //
  //   // Delay for a short period to allow the app to render
  //   await tester.pump(Duration(seconds: 2));
  //
  //   final findButton = find.byKey(Key("PairDevice"));
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 3)); // Increase the duration if needed
  //
  //   // Verify that the list of available devices is shown
  //   expect(find.byType(ListView), findsOneWidget);
  //
  //   // Delay to allow navigation to complete
  //   await tester.pumpAndSettle();
  //
  //   final connectButton = find.text('Connect');
  //   // Tap the "Connect" button
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //
  //
  //   await tester.pump(Duration(seconds: 2));
  //   // final findButton2 = find.byKey(Key("TurnOnWifiButton"));
  //   final findButton2 = find.text("Turn on wifi & Go to ride");
  //   // final findButton2 = find.byType(ElevatedButton);
  //   //
  //   await tester.tap(findButton2);
  //
  //   // Wait for the app to fully start
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 3));
  //
  //   // Find and tap the right button
  //   final rightButton = find.byKey(Key("LEFTBLINK"));
  //   expect(rightButton, findsOneWidget);
  //   await tester.tap(rightButton);
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 2));
  //
  //
  //   // Find and tap the left button
  //   final leftButton = find.byKey(Key("RIGHTBLINK"));
  //   expect(leftButton, findsOneWidget);
  //   await tester.tap(leftButton);
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 2));
  // });

  // Wifi list collisionpage
  // testWidgets('Test _wifiDialog CollisionPage', (WidgetTester tester) async {
  //   // Build the app
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: rideapp.GoToRide(device: MockBluetoothDevice()),
  //     ),
  //   );
  //
  //   final rideButton = find.byKey(Key("TurnOnWifiButton"));
  //   expect(rideButton, findsOneWidget);
  //   await tester.tap(rideButton);
  //   await tester.pumpAndSettle();
  //
  //   // Verify that the navigation to CollisionWarningPage2 occurs
  //   expect(find.byType(CollisionWarningPage2), findsOneWidget);
  //
  //   // Wait for the initial animations and transitions to complete
  //   await tester.pumpAndSettle();
  //
  //   await tester.pump(Duration(seconds: 5));
  //
  //   // Wait for the dialog to appear and settle
  //   await tester.pumpAndSettle();
  //   expect(find.byType(ListView), findsOneWidget);
  //
  // });

  // //Receive Left warning Notification
  // testWidgets('Test Left Blink + audio', (WidgetTester tester) async {
  //
  //   app.main();
  //
  //   // Delay for a short period to allow the app to render
  //   await tester.pump(Duration(seconds: 2));
  //
  //   // final findButton = find.byKey(Key("PairDevice"));
  //   final findButton = find.text('Pair Device to Start');
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 2)); // Increase the duration if needed
  //
  //   // Verify that the list of available devices is shown
  //   expect(find.byType(ListView), findsOneWidget);
  //
  //   // Delay to allow navigation to complete
  //   await tester.pumpAndSettle();
  //
  //   final connectButton = find.text('Connect');
  //   // Tap the "Connect" button
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 16));
  //   await tester.pumpAndSettle();
  //   expect(find.byKey(Key("LEFTANIMATION")), findsOneWidget);
  // });

  // //Receive Right warning Notification
  // testWidgets('Test Right Blink + audio', (WidgetTester tester) async {
  //
  //   app.main();
  //
  //   // Delay for a short period to allow the app to render
  //   await tester.pump(Duration(seconds: 2));
  //
  //   // final findButton = find.byKey(Key("PairDevice"));
  //   final findButton = find.text('Pair Device to Start');
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 2)); // Increase the duration if needed
  //
  //   // Verify that the list of available devices is shown
  //   expect(find.byType(ListView), findsOneWidget);
  //
  //   // Delay to allow navigation to complete
  //   await tester.pumpAndSettle();
  //
  //   final connectButton = find.text('Connect');
  //   // Tap the "Connect" button
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 16));
  //   await tester.pumpAndSettle();
  //   expect(find.byKey(Key("RIGHTANIMATION")), findsOneWidget);
  // });

  // //Receive Rear warning Notification
  // testWidgets('Test Rear Blink + audio', (WidgetTester tester) async {
  //
  //   app.main();
  //
  //   // Delay for a short period to allow the app to render
  //   await tester.pump(Duration(seconds: 2));
  //
  //   // final findButton = find.byKey(Key("PairDevice"));
  //   final findButton = find.text('Pair Device to Start');
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 2)); // Increase the duration if needed
  //
  //   // Verify that the list of available devices is shown
  //   expect(find.byType(ListView), findsOneWidget);
  //
  //   // Delay to allow navigation to complete
  //   await tester.pumpAndSettle();
  //
  //   final connectButton = find.text('Connect');
  //   // Tap the "Connect" button
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 16));
  //   await tester.pumpAndSettle();
  //   expect(find.byKey(Key("REARANIMATION")), findsOneWidget);
  // });

  //Show popDialog for dashcam
  // testWidgets('Test Pop-up Dashcam Dialog', (WidgetTester tester) async {
  //
  //   app.main();
  //
  //   // Delay for a short period to allow the app to render
  //   await tester.pump(Duration(seconds: 2));
  //
  //   // final findButton = find.byKey(Key("PairDevice"));
  //   final findButton = find.text('Pair Device to Start');
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 2)); // Increase the duration if needed
  //
  //   // Verify that the list of available devices is shown
  //   expect(find.byType(ListView), findsOneWidget);
  //
  //   // Delay to allow navigation to complete
  //   await tester.pumpAndSettle();
  //
  //   final connectButton = find.text('Connect');
  //   // Tap the "Connect" button
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 16));
  //   expect(find.text('Close') , findsOneWidget);
  // });

  // STOP ride
  // testWidgets('Test Stop ride', (WidgetTester tester) async {
  //
  //   app.main();
  //
  //   // Delay for a short period to allow the app to render
  //   await tester.pump(Duration(seconds: 2));
  //
  //   // final findButton = find.byKey(Key("PairDevice"));
  //   final findButton = find.text('Pair Device to Start');
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 2)); // Increase the duration if needed
  //
  //   // Verify that the list of available devices is shown
  //   expect(find.byType(ListView), findsOneWidget);
  //
  //   // Delay to allow navigation to complete
  //   await tester.pumpAndSettle();
  //
  //   final connectButton = find.text('Connect');
  //   // Tap the "Connect" button
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 5));
  //
  //   final stopButton = find.byType(TextButton);
  //   await tester.tap(stopButton);
  //   await tester.pumpAndSettle();
  //   expect(BleScreen, findsOneWidget);
  // });

  // CHECK WIFI LIST For Dashcam
  // testWidgets('Test ConnectWifiForDashCam', (WidgetTester tester) async {
  //   // Build the app
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: ConnectWifiForDashCam(),
  //     ),
  //   );
  //
  //   final wifiButton = find.text('Connect WIFI');
  //   expect(wifiButton, findsOneWidget);
  //   await tester.tap(wifiButton);
  //   await tester.pumpAndSettle();
  //
  //   await tester.pump(Duration(seconds: 10));
  //   // expect(find.byType(Dialog), findsOneWidget);
  //   expect(find.text('wifiDialog'), findsOneWidget);
  // });


  // Download files
  // testWidgets('Test File Download', (WidgetTester tester) async {
  //
  //   await tester.pumpWidget(MaterialApp(home: Files(isCameraStreaming: false, images: [], videos: [])));
  //
  //   // Simulate button press
  //   await tester.pump(Duration(seconds: 3));
  //   // final downloadButton = find.byKey(Key('DownloadFILES'));
  //   final downloadButton = find.widgetWithIcon(IconButton, Icons.download);
  //   expect(downloadButton, findsOneWidget);
  //   await tester.tap(downloadButton);
  //
  //   // Wait for the download to complete
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 5));
  //   expect(find.text('Download complete'), findsOneWidget);
  // });

  // Has some problem to check
  // testWidgets('Test Start and Stop Camera', (WidgetTester tester) async {
  //   // Build the widget tree
  //   await tester.pumpWidget(MaterialApp(home: DashCam()));
  //
  //   // Find and tap the recording button
  //   final recordingButton = find.text('Open Camera');
  //   await tester.tap(recordingButton);
  //   await tester.pumpAndSettle();
  //
  //   // Verify that the recording stopped
  //   expect(find.text('Stop Camera'), findsOneWidget);
  //   // verify(http.get(Uri.parse('http://192.168.1.254/?custom=1&cmd=2001&par=0'))).called(1);
  //
  //   await tester.pump(Duration(seconds: 2));
  //
  //   // Verify that the recording started
  //   final recordingButton2 = find.text('Stop Camera');
  //   await tester.tap(recordingButton2);
  //   await tester.pumpAndSettle();
  //
  //   expect(find.text('Open Camera'), findsOneWidget);
  // });

  // Wifi connection for dashcam
  testWidgets('Test ConnectWifiForDashCam', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(
      MaterialApp(
        home: ConnectWifiForDashCam(),
      ),
    );
    await tester.pumpAndSettle();

    // Find and tap the button to scan WiFi networks
    final scanButton = find.byKey(Key('scanButton')); // Replace with your button's key
    expect(scanButton, findsOneWidget);
    await tester.tap(scanButton);
    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 10));
    // Find and tap the WiFi network starting with "CARDV"
    final wifiNetworkItem = find.byWidgetPredicate((widget) {
      if (widget is ListTile && widget.title is Text) {
        final text = (widget.title as Text).data;
        return text != null && text.startsWith('CARDV');
      }
      return false;
    });
    // expect(wifiNetworkItem, findsOneWidget);
    await tester.tap(wifiNetworkItem);
    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 5));

    final connectButton = find.text('Open Dashcam');
    // expect(connectButton, findsOneWidget);
    await tester.tap(connectButton);
    await tester.pumpAndSettle();

    // await tester.pump(Duration(seconds: ));
    expect(DashCam, findsOneWidget);
  });

}