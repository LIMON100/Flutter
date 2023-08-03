import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:utllama/mode/dash_cam.dart';
import 'package:utllama/main.dart' as app;
import 'package:utllama/temp/glowing_button.dart';
import 'package:utllama/mode/bleScreen.dart' as newapp;

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // BLUETOOTH PAIR BUTTON
  testWidgets('Test Bluetooth Device Pairing', (WidgetTester tester) async {
    // Build the app
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

  });

}