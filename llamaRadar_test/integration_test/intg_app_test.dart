import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utllama/mode/LlamaDefenderPage.dart';
import 'package:utllama/mode/dash_cam.dart';
import 'package:utllama/main.dart' as app;
import 'package:utllama/temp/ConnectWifiForDashCam.dart';
import 'package:utllama/temp/glowing_button.dart';
import 'package:utllama/mode/bleScreen.dart' as newapp;
import 'package:utllama/mode/goToRide.dart' as rideapp;
import 'package:utllama/temp/CollisionWarningPage2.dart' as collisionapp;
import 'package:utllama/temp/CollisionWarningPage2.dart';
import 'package:utllama/sideBar.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../test/radar_test.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

class WifiService {
  Future<bool?> scanWifi() async {
    return await FlutterIotWifi.scan();
  }
}

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
  //   // expect(find.text("Turn on wifi & Go to ride"), findsOneWidget);
  //
  //   await tester.pump(Duration(seconds: 2));
  //   final findButton2 = find.byKey(Key("TurnOnWifiButton"));
  //
  //   await tester.tap(findButton2);
  //   await tester.pumpAndSettle();
  //
  //   expect(collisionapp.CollisionWarningPage2, findsOneWidget);
  //
  //
  //   // final device = MockBluetoothDevice();
  //   //
  //   // // Build the app
  //   // await tester.pumpWidget(
  //   //   MaterialApp(
  //   //     home: rideapp.GoToRide(device: device),
  //   //   ),
  //   // );
  //   //
  //   // expect(find.byType(rideapp.GoToRide), findsOneWidget);
  //   //
  //   // final findButton2 = find.byKey(Key("Turn on wifi & Go to ride"));
  //   // await tester.pump(Duration(seconds: 3));
  //   //
  //   // await tester.tap(findButton2);
  //   // await tester.pumpAndSettle();
  //
  //   // Build the app
  //   // await tester.pumpWidget(
  //   //   MaterialApp(
  //   //     home: collisionapp.CollisionWarningPage2(device: device),
  //   //   ),
  //   // );
  //   //
  //   // expect(find.byType(collisionapp.CollisionWarningPage2), findsOneWidget);
  // });

  // testWidgets('Test ConnectWifiForDashCam', (WidgetTester tester) async {
  //   // Build the app
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: ConnectWifiForDashCam(),
  //     ),
  //   );
  //
  //   // Wait for the initial animations and transitions to complete
  //   await tester.pumpAndSettle();
  //
  //   // Tap the "Connect Wifi" button
  //   final connectWifiButton = find.byIcon(Icons.wifi);
  //   await tester.tap(connectWifiButton);
  //
  //   // Wait for the dialog to appear
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 5));
  //
  //   // Find and tap the Wi-Fi network that starts with "Mahmudur"
  //   final wifiNetwork = find.widgetWithText(showDialog, "Mahmudur");
  //   await tester.tap(wifiNetwork);
  //
  //   // Wait for the Wi-Fi connection to complete
  //   await tester.pumpAndSettle();
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

  testWidgets('Test _startWifiScan dialog', (WidgetTester tester) async {
    // Mock FlutterIotWifi method channel
    final mockWifiService = WifiService();
    when(mockWifiService.scanWifi()).thenAnswer((_) => Future.value(true));

    // Build the app
    await tester.pumpWidget(
      MaterialApp(
        home: ConnectWifiForDashCam(wifiService: mockWifiService),
      ),
    );

    // Wait for the initial animations and transitions to complete
    await tester.pumpAndSettle();

    // Mock successful Wi-Fi scan result
    mockMethodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'scan') {
        return true;
      }
      return null;
    });

    // Trigger _startWifiScan
    final connectWifiButton = find.byIcon(Icons.wifi);
    await tester.tap(connectWifiButton);
    await tester.pumpAndSettle();

    // Verify that the dialog is displayed
    expect(find.byType(Dialog), findsOneWidget);

    // You can further test the dialog content and interactions here
    // For example, you can tap on a Wi-Fi network and verify that _connect is called
  });

}