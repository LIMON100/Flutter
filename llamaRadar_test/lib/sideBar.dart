import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamaradar/custom_icon_icons.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:lamaradar/mode/dash_cam.dart';
import 'db_icons.dart';

import 'package:lamaradar/temp/home_page.dart';
import 'package:camera/camera.dart';
import 'package:lamaradar/temp/WarningPage.dart';
import 'package:lamaradar/temp/BLEScannerScreen.dart';
import 'package:lamaradar/temp/CollisionWarningPage.dart';
import 'package:lamaradar/temp/bluetooth_controller.dart';
import 'package:lamaradar/temp/BluetoothLightsPage.dart';
import 'package:lamaradar/temp/BluetoothNotification.dart';
import 'package:lamaradar/temp/BLEDevicePage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lamaradar/mode/LlamaDefenderPage.dart';
import 'package:lamaradar/temp/BottomNavBar.dart';
import 'package:lamaradar/temp/BleWriteTest.dart';

class SideBar extends StatelessWidget {

  late final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        color: Color(0xFF517fa4),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('   LLAMA'),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset('images/llamalogo_no_txt.jpg',
                    fit: BoxFit.cover,
                    // width: 90,
                    // height: 90,
                    width: size.width * 0.3,
                    height: size.height * 0.15,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF517fa4),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            // Divider(),
            ListTile(
              leading: Icon(Icons.wifi_protected_setup, color: Colors.black,size: size.width * 0.07,),
              title:
              Text(
                'Llama Defender',
                style: TextStyle(
                  fontFamily: 'Quicksand-VariableFont_wght',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const LlamaDefender()
                  ),
                );
              },
            ),
            // Divider(),
            ListTile(
              leading: Icon(
                CustomIcon.webcam,
                color: Colors.black,
                size: size.width * 0.07,
              ),
              title: Text(
                'Dash Cam',
                style: TextStyle(
                  fontFamily: 'Quicksand-VariableFont_wght',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DashCam()
                  ),
                );
              },
            ),
            ListTile(
                leading: Icon(Icons.history, color: Colors.black, size: size.width * 0.07,),
                title: Text(
                  'Ride History',
                  style: TextStyle(
                    fontFamily: 'Quicksand-VariableFont_wght',
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 2.0,
                  ),
                ),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const LlamaWebMenu(),
                  //   ),
                  // );
                }
            ),
            // Divider(),

            ListTile(
              leading: Icon(
                DBIcons.logo,
                color: Colors.black,
                size: size.width * 0.07,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  fontFamily: 'Quicksand-VariableFont_wght',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) => BleWriteTest2()
                //   ),
                // );
              },
            ),
            // Divider(),
            ListTile(
              title:
              // Text(
              //   'Exit',
              //   style: TextStyle(fontSize: size.width * 0.05),
              // ),
              Text(
                'Exit',
                style: TextStyle(
                  // fontFamily: 'Montserrat',
                  fontFamily: 'Quicksand-VariableFont_wght',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              leading: Icon(
                CustomIcon.exit,
                color: Colors.black,
                size: size.width * 0.07,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context){
                      return Container(
                        child: AlertDialog(
                          title: Text("Are you sure to exit"),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  // Navigator.of(context).pop(true);
                                  SystemNavigator.pop();
                                },
                                child: Text("Yes")),
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop(false);
                                },
                                child: Text("No"))
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
