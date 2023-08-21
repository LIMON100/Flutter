import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lamaradar/SideBar.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:lamaradar/mode/goToRide.dart';
import 'package:lamaradar/temp/CollisionWarningPage2.dart';

import '../test/radar_test.dart';

void main(){
  // Test sidebar options
  // testWidgets("Sidebar test", (WidgetTester tester) async{
  //   final lamadefender = find.text("Llama Defender");
  //   final dashcam = find.text("Dash Cam");
  //   final ride = find.text("Ride History");
  //   final settings = find.text("Settings");
  //   final exit = find.text("Exit");
  //
  //   await tester.pumpWidget(MaterialApp(home: SideBar()));
  //   expect(lamadefender, findsOneWidget);
  //   expect(dashcam, findsOneWidget);
  //   expect(ride, findsOneWidget);
  //   expect(settings, findsOneWidget);
  //   expect(exit, findsOneWidget);
  //
  //   await tester.tap(lamadefender);
  //   await tester.pump();
  //
  //   expect(find.byKey(Key("DEFERNDER")), findsOneWidget);
  // });

  //
  // testWidgets("BLE connect button test", (WidgetTester tester) async{
  //   final bleConnector = find.byKey(Key("PairDevice"));
  //
  //   await tester.pumpWidget(MaterialApp(home: BleScreen(title: ' ')));
  //   expect(bleConnector, findsOneWidget);
  //
  //   await tester.tap(bleConnector);
  //   await tester.pumpAndSettle(Duration(seconds: 10));
  //   // await tester.pump(Duration(seconds: 3));
  //
  //
  //   // await tester.pump(Duration(seconds: 3)); // Increase the duration if needed
  //   // expect(find.byType(ListView), findsOneWidget);
  // });

  // Check pair deivce button for ble
  // testWidgets("BLE connect button test", (WidgetTester tester) async{
  //   final bleConnector = find.byKey(Key("PairDevice"));
  //
  //   await tester.pumpWidget(MaterialApp(home: BleScreen(title: ' ')));
  //   expect(bleConnector, findsOneWidget);
  // });


  // DISCONNECT BUTTON IN RIDE
  // testWidgets('Test GoToRide', (WidgetTester tester) async {
  //   // Build the GoToRide widget
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: GoToRide(
  //         device: MockBluetoothDevice(), // Provide your BluetoothDevice or a mock
  //       ),
  //     ),
  //   );
  //
  //   // Find and tap the Disconnect button
  //   final disconnectButton = find.byKey(Key("DISCONNECTBUTTON"));
  //   expect(disconnectButton, findsOneWidget);
  //   await tester.tap(disconnectButton);
  //   await tester.pumpAndSettle();
  //
  //   // Verify that the button text changes to "Disconnected"
  //   final disconnectedText = find.text("Disconnected");
  //   expect(disconnectedText, findsOneWidget);
  // });

  // Go to CollisionPage
  // testWidgets('CollisionPage test', (WidgetTester tester) async {
  //   // Build the GoToRide widget
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: GoToRide(
  //         device: MockBluetoothDevice(), // Provide your BluetoothDevice or a mock
  //       ),
  //     ),
  //   );
  //
  //   // Find and tap the Disconnect button
  //   final rideButton = find.byKey(Key("TurnOnWifiButton"));
  //   expect(rideButton, findsOneWidget);
  //   await tester.tap(rideButton);
  //   await tester.pumpAndSettle();
  //
  //   // Verify that the navigation to CollisionWarningPage2 occurs
  //   expect(find.byType(CollisionWarningPage2), findsOneWidget);
  // });

  // Left indicator test
  // testWidgets('Test Left Blinking', (WidgetTester tester) async {
  //   // Build your widget that contains the button calling _startLeftBlinking
  //   await tester.pumpWidget(MaterialApp(
  //     home: CollisionWarningPage2(device: MockBluetoothDevice()),
  //   ));
  //
  //   // Find and tap the button
  //   final buttonFinder = find.byKey(Key('leftINDICATOR')); // Replace with your button's key
  //   expect(buttonFinder, findsOneWidget);
  //   await tester.tap(buttonFinder);
  //   await tester.pumpAndSettle();
  //
  //   // Verify the initial blinking state
  //   final initialBlinkingState = find.text('Initial Blinking State');
  //   expect(initialBlinkingState, findsOneWidget);
  //
  //   // Wait for the first toggle
  //   await tester.pump(Duration(milliseconds: 500));
  //
  //   // Verify the updated blinking state
  //   final updatedBlinkingState = find.text('Updated Blinking State');
  //   expect(updatedBlinkingState, findsOneWidget);
  //
  //   // Wait for the timer to complete (30 seconds)
  //   await tester.pumpAndSettle(Duration(seconds: 30));
  //
  // });
  //
  // // Right indicator test
  // testWidgets('Test Right Blinking', (WidgetTester tester) async {
  //   // Build your widget that contains the button calling _startLeftBlinking
  //   await tester.pumpWidget(MaterialApp(
  //     home: CollisionWarningPage2(device: MockBluetoothDevice()),
  //   ));
  //
  //   // Find and tap the button
  //   final buttonFinder = find.byKey(Key('rightINDICATOR')); // Replace with your button's key
  //   expect(buttonFinder, findsOneWidget);
  //   await tester.tap(buttonFinder);
  //   await tester.pumpAndSettle();
  //
  //   // Verify the initial blinking state
  //   final initialBlinkingState = find.text('Initial Blinking State');
  //   expect(initialBlinkingState, findsOneWidget);
  //
  //   // Wait for the first toggle
  //   await tester.pump(Duration(milliseconds: 500));
  //
  //   // Verify the updated blinking state
  //   final updatedBlinkingState = find.text('Updated Blinking State');
  //   expect(updatedBlinkingState, findsOneWidget);
  //
  //   // Wait for the timer to complete (30 seconds)
  //   await tester.pumpAndSettle(Duration(seconds: 30));
  //
  // });


  // Distance check
  // testWidgets('Test button press triggers blinking', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: CollisionWarningPage2(device: MockBluetoothDevice()),
  //   ));
  //
  //   // Find the IconButton using its icon
  //   final iconButtonFinder = find.byIcon(Icons.social_distance_rounded);
  //   expect(iconButtonFinder, findsOneWidget);
  //
  //   // Tap the IconButton
  //   await tester.tap(iconButtonFinder);
  //   await tester.pump();
  // });

  // Tailight check
  // testWidgets('Test _tailight toggles when button is pressed', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home: CollisionWarningPage2(device: MockBluetoothDevice()))); // Replace with your app's main widget
  //
  //   // Find the IconButton using its icon
  //   final iconButtonFinder = find.byIcon(Icons.lightbulb_outline);
  //   expect(iconButtonFinder, findsOneWidget);
  //
  //   // Initial state: _tailight is false, so the button should have the 'lightbulb_outline' icon
  //   expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
  //   expect(find.byIcon(Icons.lightbulb), findsNothing);
  //
  //   // Tap the IconButton
  //   await tester.tap(iconButtonFinder);
  //   await tester.pump();
  //
  //   // After tap: _tailight should be true, so the button should have the 'lightbulb' icon
  //   expect(find.byIcon(Icons.lightbulb_outline), findsNothing);
  //   expect(find.byIcon(Icons.lightbulb), findsOneWidget);
  // });

  //Test Open rear cam button
  // testWidgets('Test camera button toggles text on press', (WidgetTester tester) async {
  //   bool isCameraStreaming = false; // Initialize as per your app's state logic
  //
  //   await tester.pumpWidget(MaterialApp(home: CollisionWarningPage2(device: MockBluetoothDevice()))); // Replace with your app's main widget
  //
  //   // Find the ElevatedButton using its text
  //   final buttonFinder = find.text('Open Rear Cam');
  //   expect(buttonFinder, findsOneWidget);
  //
  //   // Initial state: button text should be 'Open Rear Cam'
  //   expect(find.text('Open Rear Cam'), findsOneWidget);
  //   expect(find.text('Stop Rear Camera'), findsNothing);
  //
  //   // Tap the ElevatedButton
  //   await tester.tap(buttonFinder);
  //   await tester.pump();
  //
  //   // After tap: button text should change to 'Stop Rear Camera'
  //   expect(find.text('Stop Rear Camera'), findsOneWidget);
  //   expect(find.text('Open Rear Cam'), findsNothing);
  // });

  //Test Stop ride
  // testWidgets('Test Stop Ride button navigation', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home: CollisionWarningPage2(device: MockBluetoothDevice()))); // Replace with your app's main widget
  //   print(tester.getCenter(find.byType(TextButton)));
  //
  //   // Find the TextButton using its text
  //   // final buttonFinder = find.text('Stop Ride');
  //   final buttonFinder = find.byType(TextButton);
  //   expect(buttonFinder, findsOneWidget);
  //
  //   // Tap the TextButton
  //   await tester.tap(buttonFinder);
  //   await tester.pumpAndSettle();
  //   expect(find.byType(BleScreen), findsOneWidget);
  // });

  // Ride page->Blescreen page
  // testWidgets('Test navigation to BleScreen using AppBar back button', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home: GoToRide(device: MockBluetoothDevice()))); // Replace with your app's main widget
  //
  //   // Tap the AppBar's back button to navigate
  //   final backButtonFinder = find.byIcon(Icons.arrow_back);
  //   expect(backButtonFinder, findsOneWidget);
  //   await tester.tap(backButtonFinder);
  //   await tester.pumpAndSettle(); // Wait for navigation and animations to complete
  //
  //   // Verify that the BleScreen widget is displayed
  //   expect(find.byType(BleScreen), findsOneWidget);
  // });

  // Collision page->Ride page
  // testWidgets('Test navigation to BleScreen using AppBar back button', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home: CollisionWarningPage2(device: MockBluetoothDevice()))); // Replace with your app's main widget
  //
  //   // Tap the AppBar's back button to navigate
  //   final backButtonFinder = find.byIcon(Icons.arrow_back);
  //   expect(backButtonFinder, findsOneWidget);
  //   await tester.tap(backButtonFinder);
  //   await tester.pumpAndSettle(); // Wait for navigation and animations to complete
  //
  //   // Verify that the BleScreen widget is displayed
  //   expect(find.byType(GoToRide), findsOneWidget);
  // });
}

