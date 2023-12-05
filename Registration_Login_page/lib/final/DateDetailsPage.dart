import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'sqflite/sqlite.dart';
import 'package:sqflite/sqflite.dart';

class DateDetailsPage extends StatefulWidget  {
  final String date;
  DateDetailsPage({required this.date});

  @override
  _DateDetailsPageState createState() => _DateDetailsPageState();
}

class _DateDetailsPageState extends State<DateDetailsPage> {
  List<Map<String, dynamic>> _gpsCoordinates = [];
  late ImagePicker _imagePicker;
  XFile? _imageFile;
  List<Uint8List> _imageList = [];

  @override
  void initState() {
    super.initState();
    _fetchGpsCoordinates();
    _fetchImages();
  }

  // Fetch all data based on date
  Future<void> _fetchGpsCoordinates() async {
    final Database db = await GpsDatabaseHelper().initDatabase();
    final List<Map<String, dynamic>> gpsCoordinates = await db.query(
      'gps_coordinates',
      where: 'date = ?',
      whereArgs: [widget.date],
    );

    setState(() {
      _gpsCoordinates = gpsCoordinates;
    });
  }

 // Fetch images from database
  Future<void> _fetchImages() async {
    try {
      final Database db = await GpsDatabaseHelper().initDatabase();
      final List<Map<String, dynamic>> images = await db.query(
        'gps_coordinates',
        where: 'date = ?',
        whereArgs: [widget.date],
      );
      setState(() {
        _imageList = images.map((e) => e['image'] as Uint8List).toList();
        print("image2");
        print(_imageList);
      });
      print('Images fetched from database for date: ${widget.date}');
    } catch (e) {
      print('Error fetching images: $e');
    }
  }
  // Future<void> _fetchImages() async {
  //   try {
  //     final Database db = await GpsDatabaseHelper().initDatabase();
  //     final List<Map<String, dynamic>> images = await db.query(
  //       'gps_coordinates',
  //       where: 'date = ?',
  //       whereArgs: [widget.date],
  //     );
  //     setState(() {
  //       _imageList = images
  //           .map((e) => e['image'] as Uint8List)
  //           .where((imageData) => isValidImage(imageData))
  //           .toList();
  //       print("image2");
  //       print(_imageList);
  //     });
  //     print('Images fetched from database for date: ${widget.date}');
  //   } catch (e) {
  //     print('Error fetching images: $e');
  //   }
  // }



  bool isValidImage(Uint8List? imageData) {
    return imageData != null && imageData.isNotEmpty;
  }

  

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Details for $widget.date'),
  //     ),
  //     body: ListView.builder(
  //       itemCount: _gpsCoordinates.length,
  //       itemBuilder: (context, index) {
  //         final gpsCoordinate = _gpsCoordinates[index];
  //         // Check if both latitude and longitude are not null
  //         if (gpsCoordinate['latitude'] != null &&
  //             gpsCoordinate['longitude'] != null) {
  //           return GestureDetector(
  //             onTap: () {
  //               // Navigate to details page for the selected gps coordinate
  //             },
  //             child: ListTile(
  //               title: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Latitude: ${gpsCoordinate['latitude']}, Longitude: ${gpsCoordinate['longitude']}',
  //                   ),
  //                   Text(
  //                     'Time: ${gpsCoordinate['time']}',
  //                   ),
  //                   SizedBox(height: 8.0),
  //                   // Display the image if it exists and is valid
  //                   // if (_imageList.isNotEmpty)
  //                   Image.memory(
  //                     _imageList[index]!,
  //                     height: 100.0,
  //                     width: 100.0,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         } else {
  //           // If latitude or longitude is null, return an empty container
  //           return Container();
  //         }
  //       },
  //     ),
  //   );
  // }
}
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Details for $widget.date'),
  //     ),
  //     body: ListView.builder(
  //       itemCount: _gpsCoordinates.length,
  //       itemBuilder: (context, index) {
  //         final gpsCoordinate = _gpsCoordinates[index];
  //
  //         // Check if both latitude and longitude are not null
  //         if (gpsCoordinate['latitude'] != null && gpsCoordinate['longitude'] != null) {
  //           return GestureDetector(
  //             onTap: () {
  //               // Navigate to details page for the selected gps coordinate
  //             },
  //             child: ListTile(
  //               title: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Latitude: ${gpsCoordinate['latitude']}, Longitude: ${gpsCoordinate['longitude']}',
  //                   ),
  //                   Text(
  //                     'Time: ${gpsCoordinate['time']}',
  //                   ),
  //                   SizedBox(height: 8.0),
  //                   // Display the image if it exists
  //                   if (_imageList.isNotEmpty)
  //                     Image.memory(
  //                       _imageList[index]!,
  //                       height: 100.0,
  //                       width: 100.0,
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         } else {
  //           // If latitude or longitude is null, return an empty container
  //           return Container();
  //         }
  //       },
  //     ),
  //   );
  // }



//
// class _DateDetailsPageState extends State<DateDetailsPage> {
//   List<Map<String, dynamic>> _gpsCoordinates = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchGpsCoordinates();
//   }
//
//   Future<void> _fetchGpsCoordinates() async {
//     final Database db = await GpsDatabaseHelper().initDatabase();
//     final List<Map<String, dynamic>> gpsCoordinates = await db.query(
//       'gps_coordinates',
//       where: 'date = ?',
//       whereArgs: [widget.date],
//     );
//     setState(() {
//       _gpsCoordinates = gpsCoordinates;
//     });
//   }
//
//   Future<void> _pickAndShowImage(String imagePath) async {
//     // Display the image using Image.file
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             padding: EdgeInsets.all(16.0),
//             child: Image.file(
//               File(imagePath),
//               height: 200.0,
//               width: 200.0,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Details for ${widget.date}'),
//       ),
//       body: ListView.builder(
//         itemCount: _gpsCoordinates.length,
//         itemBuilder: (context, index) {
//           final gpsCoordinate = _gpsCoordinates[index];
//           return GestureDetector(
//             onTap: () {
//               // Pick and show the image when tapped
//               _pickAndShowImage(gpsCoordinate['image']);
//             },
//             child: ListTile(
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Latitude: ${gpsCoordinate['latitude']}, Longitude: ${gpsCoordinate['longitude']}',
//                   ),
//                   Text(
//                     'Time: ${gpsCoordinate['time']}',
//                   ),
//                   SizedBox(height: 8.0),
//                   // Display the image if it exists
//                   if (gpsCoordinate['image'] != null)
//                     Image.asset(
//                       gpsCoordinate['image'], // use the asset name directly
//                       height: 100.0,
//                       width: 100.0,
//                     )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// //

// if (gpsCoordinate['image'] != null)
//   Image.asset(
//     gpsCoordinate['image'], // use the asset name directly
//     height: 100.0,
//     width: 100.0,
//   )