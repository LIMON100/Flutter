import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';
import 'package:lamaradar/mode/LlamaDefenderPage.dart';
import 'package:lamaradar/mode/dash_cam.dart';
import 'package:lamaradar/main.dart' as app;
import 'package:lamaradar/temp/ConnectWifiForDashCam.dart';
import 'package:lamaradar/temp/glowing_button.dart';
import 'package:lamaradar/mode/bleScreen.dart' as newapp;
import 'package:lamaradar/mode/goToRide.dart' as rideapp;
// import 'package:lamaradar/temp/CollisionWarningPage2.dart' as collisionapp;
import 'package:lamaradar/temp/CollisionWarningPage2.dart';
import 'package:lamaradar/mode/goToRide.dart';
import 'package:lamaradar/sideBar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../test/radar_test.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

class WifiService {
  Future<bool?> scanWifi() async {
    return await FlutterIotWifi.scan();
  }
}

class MockAudioPlayer extends Mock implements AudioPlayer {}

class FakeLocationService {
  String getLocation() {
    return 'Left Notification Danger';
  }
}

class FakeYourWidget extends CollisionWarningPage2 {
  @override
  String _value = '33';

  FakeYourWidget({required super.device, required FakeLocationService locationService, required MockAudioPlayer audioPlayer}); // Control the value returned by _getLocation()
}


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

  // CHECK WIFI LIST SHOW
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
  //   // expect(find.byType(Dialog), findsOneWidget);
  //
  //   // Verify that the popup widget contains a list of Wi-Fi names.
  //   expect(find.byType(ListView), findsOneWidget);
  //   expect(find.byType(ListTile), greaterThan(0));
  //   // Tap the "Connect Wifi" button
  //   // final connectWifiButton = find.byIcon(Icons.wifi);
  //   // await tester.tap(connectWifiButton);
  //   //
  //   // // Wait for the dialog to appear
  //   // await tester.pumpAndSettle();
  //   // await tester.pump(Duration(seconds: 5));
  //   //
  //   // // Find and tap the Wi-Fi network that starts with "Mahmudur"
  //   // final wifiNetwork = find.widgetWithText(showDialog, "Mahmudur");
  //   // await tester.tap(wifiNetwork);
  //   //
  //   // // Wait for the Wi-Fi connection to complete
  //   // await tester.pumpAndSettle();
  //
  //   // Verify the connection status based on the isConnected variable
  //   // final isConnected = tester.state<ConnectWifiForDashCamState>(
  //   //   find.byType(ConnectWifiForDashCam),
  //   // ).isConnected;
  //   //
  //   // // Assert the connectivity status
  //   // expect(isConnected, isTrue); // Use isFalse if you expect disconnection
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
  //   // await tester.pumpWidget(
  //   //   MaterialApp(
  //   //     home: collisionapp.CollisionWarningPage2(device: MockBluetoothDevice()),
  //   //   ),
  //   // );
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
  testWidgets('Test Pop-up Dashcam Dialog', (WidgetTester tester) async {

    app.main();

    // Delay for a short period to allow the app to render
    await tester.pump(Duration(seconds: 2));

    // final findButton = find.byKey(Key("PairDevice"));
    final findButton = find.text('Pair Device to Start');

    await tester.tap(findButton);
    await tester.pumpAndSettle();

    // Delay for a short period to simulate the scan duration
    await tester.pump(Duration(seconds: 2)); // Increase the duration if needed

    // Verify that the list of available devices is shown
    expect(find.byType(ListView), findsOneWidget);

    // Delay to allow navigation to complete
    await tester.pumpAndSettle();

    final connectButton = find.text('Connect');
    // Tap the "Connect" button
    await tester.tap(connectButton);
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 16));
    expect(find.text('Close') , findsOneWidget);
  });

}