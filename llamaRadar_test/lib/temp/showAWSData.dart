import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uuid/uuid.dart';
import '../models/History.dart';


class ShowAwsData extends StatefulWidget {
  @override
  _ShowAwsDataState createState() => _ShowAwsDataState();
}

class _ShowAwsDataState extends State<ShowAwsData> {
  GlobalKey globalKey = GlobalKey();
  String name = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String date = "";
  String time = "";

  String fileKeyFinal = "";
  late final History newHistory;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 3));
    await queryListItems();
  }


  // Query data
  late List<History?> historyList = []; // Initialize with an empty list

  Future<List<History?>> queryListItems() async {
    try {
      final request = ModelQueries.list(History.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      print("ITEMS");
      historyList = items ?? []; // Assign items or an empty list if items is null

      if (items != null && items.isNotEmpty) {
        newHistory = items[0]!; // Assuming you want the first item
      }

      if (items == null) {
        print('errors: ${response.errors}');
        return <History?>[];
      }
      return items;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return <History?>[];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: 500,
              alignment: Alignment.center,
              // color: Colors,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: newHistory.imageUrl != null
                        ? Stack(
                      children: [
                        const Center(child: CircularProgressIndicator()),
                        CachedNetworkImage(
                          errorWidget: (context, url, dynamic error) =>
                          const Icon(Icons.error_outline_outlined),
                          imageUrl: newHistory.imageUrl!,
                          cacheKey: newHistory.imagekey,
                          width: double.maxFinite,
                          height: 500,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.fill,
                        ),
                      ],
                    )
                        : Image.asset(
                      'images/new_lama.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        newHistory.latitude.toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 8, 4),
            child: DefaultTextStyle(
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      newHistory.longitude.toString(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                  Text(
                    newHistory.date.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    newHistory.time.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Data Submission Screen'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: ListView.builder(
  //         itemCount: historyList.length,
  //         itemBuilder: (context, index) {
  //           History? history = historyList[index];
  //           return ListTile(
  //             title: Text('ID: ${history!.id}'),
  //             subtitle: Text('Date: ${history.date} Time: ${history.time}'),
  //             leading: Image.network(history.imageUrl!),
  //             // Add more widgets to display other details as needed
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}
