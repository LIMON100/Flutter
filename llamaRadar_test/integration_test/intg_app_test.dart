import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:utllama/mode/LlamaDefenderPage.dart';
import 'package:utllama/mode/dash_cam.dart';
import 'package:utllama/main.dart' as app;
import 'package:utllama/temp/glowing_button.dart';
import 'package:utllama/mode/bleScreen.dart' as newapp;
import 'package:utllama/mode/goToRide.dart' as rideapp;
import 'package:utllama/temp/CollisionWarningPage2.dart';
import 'package:utllama/sideBar.dart';

import '../test/radar_test.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // BLUETOOTH PAIR BUTTON
  // testWidgets('Test Bluetooth Device Pairing', (WidgetTester tester) async {
  //   // Build the app
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
  //
  //   // Tap the "Connect" button
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay to allow navigation to GoToRide page
  //   await tester.pumpAndSettle();
  //
  //   // Verify that the app navigated to the GoToRide page
  //   expect(find.byType(GoToRide), findsOneWidget);
  // });

  testWidgets('Test Go to Ride page', (WidgetTester tester) async {

    app.main();

    // Delay for a short period to allow the app to render
    await tester.pump(Duration(seconds: 2));

    final findButton = find.byKey(Key("PairDevice"));

    await tester.tap(findButton);
    await tester.pumpAndSettle();

    // Delay for a short period to simulate the scan duration
    await tester.pump(Duration(seconds: 3)); // Increase the duration if needed

    // Verify that the list of available devices is shown
    expect(find.byType(ListView), findsOneWidget);

    // Delay to allow navigation to complete
    await tester.pumpAndSettle();

    final connectButton = find.text('Connect');

    // Tap the "Connect" button
    await tester.tap(connectButton);
    await tester.pumpAndSettle();

    final device = MockBluetoothDevice();

    // Build the app
    await tester.pumpWidget(
      MaterialApp(
        home: rideapp.GoToRide(device: device),
      ),
    );

    // Delay for a short period to allow the app to render
    await tester.pumpAndSettle();

    final findButton2 = find.byKey(Key("Turn on wifi & Go to ride"));

    await tester.tap(findButton2);
    await tester.pumpAndSettle();

    // Delay for a short period to simulate the scan duration
    await tester.pump(Duration(seconds: 3)); // Increase the duration if needed

    // Verify that the ElevatedButton is shown
    expect(find.byKey(Key("CameraButton")), findsOneWidget);
  });
}