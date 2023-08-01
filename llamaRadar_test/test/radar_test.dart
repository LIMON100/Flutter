import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:utllama/ut/RadarNotifcationController.dart';


// class MockBluetoothDevice extends Mock implements BluetoothDevice {}
//
// class MockBluetoothCharacteristic extends Mock
//     implements BluetoothCharacteristic {}
//
// class MockFlutterBlue extends Mock implements FlutterBluePlus {}
// class MockBluetoothService extends Mock implements BluetoothService {}


class MockBluetoothService extends Mock implements BluetoothService {}
class MockBluetoothCharacteristic extends Mock implements BluetoothCharacteristic {}

class MockBluetoothDevice extends Mock implements BluetoothDevice {
  @override
  String get name => 'LLama Radar'; // Provide a default value for the name
}

void main() {

  // DISCONNECT BLE
  // test('Test disconnectFromDevice', () async {
  //   // Create mock objects
  //   final mockDevice = MockBluetoothDevice();
  //
  //   // Create an instance of RadarNotificationController with the mockDevice
  //   final testInstance = RadarNotificationController(mockDevice);
  //
  //   // Set initial state to simulate connected state
  //   expect(testInstance.isDisconnected, false);
  //
  //   // Call the disconnectFromDevice() method
  //   await testInstance.performDisconnection();
  //
  //   // Perform your assertions
  //   expect(testInstance.isDisconnected, true);
  //   // verify(mockDevice.disconnect()).called(1);
  // });

  // Left right blinking
  // test('Test startLeftBlinking', () async {
  //   final mockDevice = MockBluetoothDevice();
  //   final blinkingController = RadarNotificationController(mockDevice);
  //
  //   // Test case: _leftBlinkTimer is null
  //   final result1 = blinkingController.startLeftBlinking();
  //   expect(result1, [true, false]);
  //
  //   // Test case: _leftBlinkTimer not null
  //   final result2 = blinkingController.startLeftBlinking();
  //   expect(result2, [false, false]);
  //
  //   // Test case: Stop after 3 seconds
  //   await Future.delayed(Duration(seconds: 3));
  //   final result3 = blinkingController.isLeftBlinking;
  //   expect(result3, false); // isLeftBlinking is false after 3 seconds
  // });
  //
  // // TEST RIGHT BLIKING
  // test('Test startLeftBlinking', () async {
  //   final mockDevice = MockBluetoothDevice();
  //   final blinkingController = RadarNotificationController(mockDevice);
  //
  //   // Test case: _leftBlinkTimer is null
  //   final result1 = blinkingController.startRightBlinking();
  //   expect(result1, [false, false]); // Timer started and isLeftBlinking is true
  //
  //   // Test case: _leftBlinkTimer not null
  //   final result2 = blinkingController.startRightBlinking();
  //   expect(result2, [false, false]); // Timer stopped and isLeftBlinking is false
  //
  //   // Test case: Stop after 3 seconds
  //   await Future.delayed(Duration(seconds: 3));
  //   final result3 = blinkingController.isRightBlinking;
  //   expect(result3, false); // isLeftBlinking is false after 3 seconds
  // });

  // WARNING TEXT
  test('Test getLocation', () {
    final mockDevice = MockBluetoothDevice();
    final notificationController = RadarNotificationController(mockDevice);

    // Test case 1: _value.length < 29
    notificationController.new_value = ''; // Empty _value
    var result1 = notificationController.getLocation(notificationController.new_value);
    expect(result1, 'Notification Not Available');

    // Test case 2: int.parse(_value[28]) is 1
    notificationController.new_value = 'SomeValue28:1'; // Assuming the value has '1' at the 28th index
    var result2 = notificationController.getLocation(notificationController.new_value);
    expect(result2, 'Right Notification Warning');

    // Test case 3: int.parse(_value[28]) is 2
    notificationController.new_value = 'SomeValue28:2'; // Assuming the value has '2' at the 28th index
    var result3 = notificationController.getLocation(notificationController.new_value);
    expect(result3, 'Right Notification Danger');

    // Test case 4: int.parse(_value[28]) is 3
    notificationController.new_value = 'SomeValue28:3'; // Assuming the value has '3' at the 28th index
    var result4 = notificationController.getLocation(notificationController.new_value);
    expect(result4, 'Left Notification Warning');

    // Test case 5: int.parse(_value[28]) is 4
    notificationController.new_value = 'SomeValue28:4'; // Assuming the value has '4' at the 28th index
    var result5 = notificationController.getLocation(notificationController.new_value);
    expect(result5, 'Left Notification Danger');

    // Test case 6: int.parse(_value[28]) is 5
    notificationController.new_value = 'SomeValue28:5'; // Assuming the value has '5' at the 28th index
    var result6 = notificationController.getLocation(notificationController.new_value);
    expect(result6, 'Rear Notification Danger');
  });

  // SEND DATA - problem
  // group('BLE Connection and Command Test', () {
  //   test('Connect to BLE device with name "Llama" and send command', () async {
  //     // Create mock objects
  //     final mockDevice = MockBluetoothDevice();
  //     final mockService = MockBluetoothService();
  //     final mockCharacteristicWrite = MockBluetoothCharacteristic();
  //
  //     // Set up the responses of the mock objects
  //     when(mockDevice.discoverServices())
  //         .thenAnswer((_) async => [mockService]);
  //     when(mockService.characteristics)
  //         .thenReturn([mockCharacteristicWrite]);
  //
  //     when(mockCharacteristicWrite.uuid.toString())
  //         .thenReturn('beb5483e-36e1-4688-b7f5-ea07361b26a7');
  //
  //     // Create an instance of your BLE connection manager
  //     final bleConnectionManager = RadarNotificationController(mockDevice);
  //
  //     // Call the function to connect to the BLE device and send the command
  //     await bleConnectionManager.connectAndSendCommand();
  //
  //     // Add your assertions to check if the connection and command sending was successful
  //     verify(mockDevice.discoverServices()).called(1);
  //     verify(mockCharacteristicWrite.write(Uint8List.fromList([0x02, 0x01, 0x0A, 0x01, 0x0E]))).called(1);
  //   });
  // });


  // Radar notification test - PROBLEM
  // test('Test connectToDevice', () async {
  //   // Create mock objects
  //   final mockDevice = MockBluetoothDevice();
  //   final mockService1 = MockBluetoothService();
  //   final mockCharacteristicWrite = MockBluetoothCharacteristic();
  //   final mockCharacteristicNotify = MockBluetoothCharacteristic();
  //
  //   // Set up the responses of the mock objects
  //   when(mockDevice.discoverServices()).thenAnswer((_) async => [mockService1]);
  //   when(mockService1.characteristics).thenReturn([mockCharacteristicWrite, mockCharacteristicNotify]);
  //   when(mockCharacteristicWrite.uuid.toString()).thenReturn('beb5483e-36e1-4688-b7f5-ea07361b26a7');
  //   when(mockCharacteristicNotify.uuid.toString()).thenReturn('beb5483e-36e1-4688-b7f5-ea07361b26a8');
  //   when(mockCharacteristicNotify.properties.notify).thenReturn(true);
  //
  //   // Create an instance of RadarNotificationController with the mockDevice
  //   final testInstance = RadarNotificationController(mockDevice);
  //
  //   // Call the function
  //   await testInstance.connectToDevice();
  //
  //   // Perform your assertions
  //   expect(testInstance.device_test, equals(mockDevice));
  //   expect(testInstance.characteristic, equals(mockCharacteristicNotify));
  //   // Add more assertions if necessary
  // });
}
