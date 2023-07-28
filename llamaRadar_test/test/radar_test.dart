// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:utllama/ut/RadarNotifcationController.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:mockito/mockito.dart';
//
// // class MockFlutterBlue extends Mock implements FlutterBluePlus {
// //   // Define mock implementation of startScan method
// //
// //   Future<void> startScan({Duration? timeout}) async {
// //     // setState(() {
// //     //   _isScanning = true;
// //     //   _scanError = null;
// //     // });
// //
// //     try {
// //       await FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
// //     } catch (e) {
// //       print("Error starting scan: $e");
// //       // setState(() {
// //       //   _scanError = e.toString();
// //       // });
// //     }
// //
// //     // setState(() {
// //     //   _isScanning = false;
// //     // });
// //   }
// // }
//
// class MockFlutterBluePlus extends Mock implements FlutterBluePlus {
//   @override
//   Future<void> startScan({
//     bool allowDuplicates = false,
//     bool androidUsesFineLocation = true,
//     List<String>? macAddresses,
//     ScanMode scanMode = ScanMode.lowLatency,
//     Duration? timeout,
//     List<Guid>? withDevices,
//     List<Guid>? withServices,
//   }) async {
//     // Implement the behavior you want to test here
//     // For example, you can return a list of mock devices
//     // or simply return void to simulate a successful scan.
//   }
// }
//
// void main() {
//   testWidgets('Test _startScan', (WidgetTester tester) async {
//     // Create a mock FlutterBlue instance
//     final mockFlutterBlue = MockFlutterBluePlus();
//
//     // Wrap the widget that calls _startScan with a MaterialApp
//     await tester.pumpWidget(MaterialApp(
//       home: YourWidget(flutterBlue: mockFlutterBlue), // Pass the mock FlutterBlue instance
//     ));
//
//     // Call the _startScan function
//     await tester.runAsync(() async {
//       await tester.tap(find.byType()); // Replace YourStartScanButton with the actual widget that calls _startScan
//       await tester.pump();
//
//       // Add assertions here to verify the behavior of _startScan
//       // For example, you can check if the scanning state is set correctly
//       expect(find.text('Scanning...'), findsOneWidget);
//
//       // You can also simulate a scan error and verify if the error state is set correctly
//       // when(mockFlutterBlue.startScan(timeout: anyNamed('timeout'))).thenThrow(Exception('Scan Error'));
//       // await tester.tap(find.byType(YourStartScanButton));
//       // await tester.pump();
//       // expect(find.text('Error: Scan Error'), findsOneWidget);
//     });
//   });
// }


import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mockito/mockito.dart';



class MockScanController {
  bool _isScanning = false;
  late String _scanError;

  Future<bool> startScan() {
    _isScanning = true;
    return Future.value(true);
  }

  void stopScan() {
    _isScanning = false;
  }

  void setScanError(String error) {
    _scanError = error;
  }

  bool get isScanning => _isScanning;
  String get scanError => _scanError;
}

class StartScanTest {
  late MockScanController scanController;

  void setUp() {
    scanController = MockScanController();
  }

  void tearDown() {
    // scanController = null;
  }

  Future<bool> _startScan() async {
    return await scanController.startScan();
  }

  void test_startScan_success() async {
    // Arrange
    when(scanController.startScan()).thenAnswer((_) async => Future.value(true));

    // Act
    bool success = await _startScan();

    // Assert
    verify(scanController.startScan());
    assert(success);
  }

  void test_startScan_error() async {
    // Arrange
    when(scanController.startScan()).thenThrow(Exception("An error occurred"));

    // Act
    bool success = await _startScan();

    // Assert
    verify(scanController.startScan());
    assert(!success);
  }
}