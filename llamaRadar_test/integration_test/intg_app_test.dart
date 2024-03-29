import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lamaradar/mode/llamaGuardSetting.dart';
import 'package:mockito/mockito.dart';
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
  // testWidgets('Test ConnectWifiForDashCam', (WidgetTester tester) async {
  //   // Build the app
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: ConnectWifiForDashCam(),
  //     ),
  //   );
  //   await tester.pumpAndSettle();
  //
  //   // Find and tap the button to scan WiFi networks
  //   final scanButton = find.byKey(Key('scanButton')); // Replace with your button's key
  //   expect(scanButton, findsOneWidget);
  //   await tester.tap(scanButton);
  //   await tester.pumpAndSettle();
  //
  //   await tester.pump(Duration(seconds: 10));
  //   // Find and tap the WiFi network starting with "CARDV"
  //   final wifiNetworkItem = find.byWidgetPredicate((widget) {
  //     if (widget is ListTile && widget.title is Text) {
  //       final text = (widget.title as Text).data;
  //       return text != null && text.startsWith('CARDV');
  //     }
  //     return false;
  //   });
  //   // expect(wifiNetworkItem, findsOneWidget);
  //   await tester.tap(wifiNetworkItem);
  //   await tester.pumpAndSettle();
  //
  //   await tester.pump(Duration(seconds: 5));
  //
  //   final connectButton = find.text('Open Dashcam');
  //   // expect(connectButton, findsOneWidget);
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //
  //   // await tester.pump(Duration(seconds: ));
  //   expect(DashCam, findsOneWidget);
  // });


  // TEST tailight mode (Not worked)
  // testWidgets('Test Tailight', (WidgetTester tester) async {
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
  //   expect(find.text('Close') , findsOneWidget);
  // });

  //Check tailight mode (Not worked)
  // testWidgets('Select option in CollisionWarningPage2 and verify in LlamaGuardSetting', (WidgetTester tester) async {
  //   // Build the app and navigate to CollisionWarningPage2
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
  //   // await tester.pumpWidget(MaterialApp(
  //   //   home: CollisionWarningPage2(device: MockBluetoothDevice()),
  //   // ));
  //   await tester.pump(Duration(seconds: 3));
  //   // Verify that the default option ('OFF') is displayed in LlamaGuardSetting
  //   expect(find.text('Current Mode: OFF'), findsOneWidget);
  //
  //   // Open the dropdown menu and select a different option
  //   await tester.tap(find.byKey(Key("DROPDOWNBUTTON")));
  //   await tester.pumpAndSettle();
  //
  //   await tester.tap(find.text('ON')); // Select 'ON' option, adjust this based on your UI
  //   await tester.pumpAndSettle();
  //
  //   // Verify that the selected option ('ON') is displayed in LlamaGuardSetting
  //   expect(find.text('Current Mode: ON'), findsOneWidget);
  // });

  // Custom tailight change
  // testWidgets('Test custom dialog functionality', (WidgetTester tester) async {
  //   // Build the app and navigate to the widget containing your DropdownButton and custom dialog
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
  //   await tester.pump(Duration(seconds: 3));
  //
  //   // Find the DropdownButton and select the "CUSTOM" option
  //   await tester.tap(find.byKey(Key("DROPDOWNBUTTON")));
  //   await tester.pumpAndSettle();
  //
  //   await tester.tap(find.text('CUSTOM')); // Select 'CUSTOM' option
  //   await tester.pumpAndSettle();
  //
  //   // Find the sliders in the custom dialog and set their values
  //   await tester.drag(find.byType(Slider).first, Offset(300.0, 0.0));
  //   await tester.drag(find.byType(Slider).last, Offset(300.0, 0.0));
  //   await tester.pumpAndSettle();
  //
  //   // Find the SAVE button in the custom dialog and press it
  //   await tester.tap(find.text('Save'));
  //   await tester.pumpAndSettle();
  //
  //   // Add expectations to verify the changes you expect in your UI or state after pressing SAVE
  //   expect(find.text('Custom dialog changes verified'), findsOneWidget);
  // });

  // Left indicator 10 second timer
  // testWidgets('Test startLeftBlinking with different values', (WidgetTester tester) async {
  //   app.main();
  //
  //   // Delay for a short period to allow the app to render
  //   await tester.pump(Duration(seconds: 2));
  //
  //   final findButton = find.text('Pair Device to Start');
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 2));
  //
  //   // Verify that the list of available devices is shown
  //   // expect(find.byType(ListView), findsOneWidget);
  //
  //   final connectButton = find.text('Connect');
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //   await tester.pump(Duration(seconds: 5));
  //
  //   // Find the IconButton with the key "LEFTBLINK"
  //   final button = find.byKey(Key("LEFTBLINK"));
  //
  //   // Initial conditions
  //   expect(find.text("Blinking: false"), findsOneWidget);
  //
  //   // 1. Test when the value is 0 (should blink for 10 seconds)
  //   await tester.tap(button);
  //   await tester.pump();
  //
  //   // The button press should initiate blinking
  //   expect(find.text("Blinking: true"), findsOneWidget);
  //
  //   await Future.delayed(Duration(seconds: 10)); // Wait for 10 seconds
  //
  //   // The button should now stop blinking automatically
  //   expect(find.text("Blinking: false"), findsOneWidget);
  //
  //   // 2. Test when the value is 1 or 2 (should blink for 3 seconds)
  //   await tester.tap(button);
  //   await tester.pump();
  //
  //   // The button press should initiate blinking
  //   expect(find.text("Blinking: true"), findsOneWidget);
  //
  //   await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds
  //
  //   // The button should now stop blinking automatically
  //   expect(find.text("Blinking: false"), findsOneWidget);
  // });

  // check wifi ssid and password
  // testWidgets('Integration test for checking current Wi-Fi SSID and password', (WidgetTester tester) async {
  //   bool isResetPress = false;
  //   String _selectedOption = 'OFF';
  //   // await tester.pumpWidget(MaterialApp(
  //   //   home: Scaffold(
  //   //     body: CollisionWarningPage2(device: MockBluetoothDevice())
  //   //   ),
  //   // ));
  //   app.main();
  //
  //   final findButton = find.byKey(Key("PairDevice"));
  //
  //   await tester.tap(findButton);
  //   await tester.pumpAndSettle();
  //
  //   // Delay for a short period to simulate the scan duration
  //   await tester.pump(Duration(seconds: 3));
  //
  //   // Verify that the list of available devices is shown
  //   // expect(find.byType(ListView), findsOneWidget);
  //
  //   final connectButton = find.text('Connect');
  //   await tester.tap(connectButton);
  //   await tester.pumpAndSettle();
  //
  //   // Initial conditions
  //   // expect(find.text('Press to check current ssid and password'), findsOneWidget);
  //   // expect(find.text('Current SSID:'), findsNothing); // SSID should not be visible initially
  //   // expect(find.text('Current Password:'), findsNothing); // Password should not be visible initially
  //
  //   final guardButton = find.byKey(Key("GUARDP"));
  //   await tester.tap(guardButton);
  //   await tester.pump();
  //
  //   // Tap the ListTile with key "GETWIFI"
  //   await tester.tap(find.byKey(Key("GETWIFI")));
  //   await tester.pump();
  //
  //   // Check if it shows current SSID and password
  //   expect(find.text('Current SSID:'), findsOneWidget);
  //   expect(find.text('Current Password:'), findsOneWidget);
  //
  //   await Future.delayed(Duration(seconds: 3));
  //
  //   // Replace these with the actual SSID and password you expect
  //   String expectedSSID = 'Limonpacenet';
  //   String expectedPassword = '121345678';
  //
  //   // Verify if the current SSID and password match the expected values
  //   expect(find.text(expectedSSID), findsOneWidget);
  //   expect(find.text(expectedPassword), findsOneWidget);
  // });

  testWidgets('Generate WiFi Command', (WidgetTester tester) async {
    // Define your test SSID and password
    final testSSID = 'TestSSID';
    final testPassword = 'TestPassword';
    String _selectedOption = 'OFF';
    // Build your widget tree
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: LlamaGuardSetting(device: MockBluetoothDevice(), selectedOption: _selectedOption)
      ),
    ));

    // Find and interact with the text fields
    await tester.enterText(find.byKey(Key('SSIDTextField')), testSSID);
    await tester.enterText(find.byKey(Key('PasswordTextField')), testPassword);

    // Tap the "SAVE" button
    await tester.tap(find.text('SAVE'));
    await tester.pump();

    // Wait for the SnackBar
    await tester.pump(const Duration(seconds: 1));

    // Find the generated command and checksum
    final generatedCommand = find.text('GeneratedCommand').evaluate().single.widget as Text;
    final checksum = find.text('Checksum').evaluate().single.widget as Text;

    // Validate the generated command
    expect(
      generatedCommand.data,
      '0x02,0x01,0x21,0x00,0x${testSSID.length.toRadixString(16)},${getHexString(testSSID)},0x${testPassword.length.toRadixString(16)},${getHexString(testPassword)},${checksum.data}',
    );
  });
}

String getHexString(String input) {
  String hexString = '';
  for (int i = 0; i < input.length; i++) {
    hexString += '0x${input.codeUnitAt(i).toRadixString(16)},';
  }
  return hexString.substring(0, hexString.length - 1);
}