import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:utllama/mode/dash_cam.dart';
import 'package:utllama/main.dart' as app;
import 'package:utllama/temp/glowing_button.dart';
import 'package:utllama/mode/bleScreen.dart' as newapp;

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets('Test Bluetooth Device Pairing', (WidgetTester tester) async {
  //   // Build the app
  //   app.main();
  //   newapp.BleScreen(title: '');
  //   await tester.pumpAndSettle();
  //   // Tap the "Pair Device to Start" button
  //   // await tester.pumpAndSettle();
  //
  //   final findButton = find.byKey(Key("PairDevice"));
  //   // await tester.pumpAndSettle();
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Verify that the CircularProgressIndicator is shown while scanning
  //   // if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
  //   //   print("CircularProgressIndicator not found");
  //   //   await tester.pumpAndSettle();
  //   //   // debugDumpApp();
  //   // }
  //   //
  //   // expect(find.byType(CircularProgressIndicator), findsOneWidget);
  //   //
  //   // // Delay for a short period to simulate the scan duration
  //   // await tester.pump(Duration(seconds: 5)); // Increase the duration if needed
  //   //
  //   // // Print widget tree for debugging
  //   // // debugDumpApp();
  //   //
  //   // // Verify that the CircularProgressIndicator is no longer present after scanning
  //   // if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
  //   //   print("CircularProgressIndicator still found");
  //   //   await tester.pumpAndSettle();
  //   //   // debugDumpApp();
  //   // }
  //   //
  //   // expect(find.byType(CircularProgressIndicator), findsNothing);
  // });

  // BLUETOOTH PAIR BUTTON
  testWidgets('Test Bluetooth Device Pairing', (WidgetTester tester) async {
    // Build the app
    app.main();

    // Delay for a short period to allow the app to render
    await tester.pump(Duration(seconds: 2));

    final findButton = find.byKey(Key("PairDevice"));

    await tester.tap(findButton);
    await tester.pumpAndSettle();

    // Verify that the CircularProgressIndicator is shown while scanning
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Delay for a short period to simulate the scan duration
    await tester.pump(Duration(seconds: 5)); // Increase the duration if needed

    // Verify that the list of available devices is shown
    expect(find.byType(ListView), findsOneWidget);
  });

}