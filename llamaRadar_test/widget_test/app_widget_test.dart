import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lamaradar/SideBar.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:lamaradar/mode/goToRide.dart';
import 'package:lamaradar/mode/llamaGuardSetting.dart';
import 'package:lamaradar/temp/CollisionWarningPage2.dart';
import 'package:lamaradar/temp/ResetButtonWidget.dart';

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

  // Check wifi ssid and password
  // testWidgets('GETWIFI Test', (WidgetTester tester) async {
  //   // Build our widget
  //   String _selectedOption = 'OFF';
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: Scaffold(
  //         body: LlamaGuardSetting(device: MockBluetoothDevice(), selectedOption: _selectedOption),
  //       ),
  //     ),
  //   );
  //
  //   final Finder listItem = find.byType(ListTile);
  //
  //   // Find the Text widget with 'WiFi' title
  //   final wifiTitleText = find.text('WiFi');
  //
  //   // Find the Text widget with 'Press to check current ssid and password'
  //   final pressToCheckText = find.text('Press to check current ssid and password');
  //
  //   // Expect to find the 'WiFi' title in the ListTile
  //   expect(wifiTitleText, findsOneWidget);
  //
  //   // Expect to find the 'Press to check current ssid and password' subtitle initially
  //   expect(pressToCheckText, findsOneWidget);
  //
  //   // Trigger a tap on the ListTile
  //   await tester.tap(listItem);
  //   await tester.pump();
  //
  //   // Find the Text widgets with 'Current SSID: ' and 'Current Password: '
  //   final ssidText = find.text('Current SSID: ');
  //   final passwordText = find.text('Current Password: ');
  //
  //   // Expect to find the 'Current SSID: ' and 'Current Password: ' texts
  //   expect(ssidText, findsOneWidget);
  //   expect(passwordText, findsOneWidget);
  // });

  // Set wifi ssid and password
  // testWidgets('WiFi Settings Tile and Saving Test', (WidgetTester tester) async {
  //   String _selectedOption = 'OFF';
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: Scaffold(
  //         body: LlamaGuardSetting(device: MockBluetoothDevice(), selectedOption: _selectedOption),
  //       ),
  //     ),
  //   );
  //
  //   // Find the ListTile widget with title 'WiFi Settings'
  //   final wifiSettingsTile = find.widgetWithText(ListTile, 'WiFi Settings');
  //
  //   // Find the Text widget with subtitle 'Set SSID/Password'
  //   final setSsidPasswordText = find.text('Set SSID/Password');
  //
  //   // Expect to find the 'WiFi Settings' ListTile
  //   expect(wifiSettingsTile, findsOneWidget);
  //
  //   // Tap the 'WiFi Settings' ListTile
  //   await tester.tap(wifiSettingsTile);
  //   await tester.pump();
  //
  //   // Expect to find the Text widget with 'SSID (1-40 characters)' labelText
  //   expect(find.text('SSID (1-40 characters)'), findsOneWidget);
  //
  //   // Expect to find the Text widget with 'Password (1-40 characters)' labelText
  //   expect(find.text('Password (1-40 characters)'), findsOneWidget);
  //
  //   // Enter a random SSID and password in the TextFields
  //   await tester.enterText(find.byType(TextField).first, 'TestSSID');
  //   await tester.enterText(find.byType(TextField).last, 'TestPassword');
  //
  //   // Find and tap the 'SAVE' button
  //   final saveButton = find.widgetWithText(ElevatedButton, 'SAVE');
  //   await tester.tap(saveButton);
  //   await tester.pump();
  //
  //   // Expect to find a Snackbar with a success message
  //   expect(find.text('SSID and password saved successfully'), findsOneWidget);
  //
  //   // Tap the 'WiFi Settings' ListTile again to close the settings
  //   await tester.tap(wifiSettingsTile);
  //   await tester.pump();
  //
  //   // Expect to find the 'Set SSID/Password' subtitle after closing the settings
  //   expect(setSsidPasswordText, findsOneWidget);
  // });

  // Check firmware version and data
  // testWidgets('Tap ListTile to show firmware version and date', (WidgetTester tester) async {
  //   // Build our widget
  //   String _selectedOption = 'OFF';
  //   await tester.pumpWidget(MaterialApp(
  //     home: LlamaGuardSetting(device: MockBluetoothDevice(), selectedOption: _selectedOption)
  //   ));
  //
  //   // Initially, the firmware version and date should not be visible
  //   expect(find.text('Version: '), findsNothing);
  //   expect(find.text('Date: '), findsNothing);
  //
  //   // Simulate a tap on the ListTile
  //   await tester.tap(find.text('Firmware'));
  //   await tester.pump();
  //
  //   // After the tap, the firmware version and date should be visible
  //   expect(find.text('Version: '), findsOneWidget);
  //   expect(find.text('Date: '), findsOneWidget);
  // });

  // Reset button
  // testWidgets('Press Reset Device button and set isResetPress to true', (WidgetTester tester) async {
  //   bool isResetPress = false; // Initialize isResetPress to false
  //   String _selectedOption = 'OFF';
  //   // Build our widget
  //   await tester.pumpWidget(MaterialApp(
  //     home: Scaffold(
  //       body: LlamaGuardSetting(device: MockBluetoothDevice(), selectedOption: _selectedOption)
  //     ),
  //   ));
  //
  //   // Initially, isResetPress should be false
  //   expect(isResetPress, false);
  //
  //   // Find the Reset Device button and tap it
  //   await tester.tap(find.text('Reset Device'));
  //   await tester.pump();
  //
  //   // After tapping, isResetPress should be true
  //   expect(isResetPress, true);
  // });

  // Tailight
  testWidgets('Verify selected dropdown item is displayed', (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(MaterialApp(
      home: CollisionWarningPage2(device: MockBluetoothDevice()),
    ));

    // Open the dropdown
    await tester.tap(find.byType(DropdownButton));
    await tester.pumpAndSettle();

    // Loop through all the available dropdown items
    for (final item in ['ON', 'FLASHING', 'PULSE', 'PELOTON', 'QUICKLY_FLASH', 'CUSTOM']) {
      // Tap on the item
      await tester.tap(find.text(item));
      await tester.pumpAndSettle();

      // Verify that the selected item is displayed
      expect(find.text('Selected option: $item'), findsOneWidget);
    }
  });

}

