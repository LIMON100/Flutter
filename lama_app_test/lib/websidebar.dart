import 'package:flutter/material.dart';
import 'package:lamaAppR/custom_icon_icons.dart';
import 'package:lamaAppR/mode/applicationinfo.dart';
import 'package:lamaAppR/mode/testwifi.dart';
import 'package:lamaAppR/temp/UploadFilePage.dart';
import 'db_icons.dart';
import 'llama_web_menu.dart';
import 'mode/wifiInfo.dart';
import 'mode/systeminfo.dart';
import 'mode/camerainfo.dart';
import 'mode/applicationinfo.dart';
import 'mode/sdcardinfo.dart';
import 'mode/modelfirmwareinfo.dart';
import 'mode/wifiscreen.dart';
import 'mode/wifiform.dart';
import 'mode/testfw.dart';
import 'mode/testwifi.dart';
import 'mode/testmode.dart';
import 'mode/bleinfo.dart';
import 'package:lamaAppR/temp/UploadFilePage.dart';

class WebSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFCBBACC), Color(0xFF2580B3)],
          ),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8.0,
                    left: 4.0,
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                image: DecorationImage(
                  image: AssetImage('images/llama_img_web.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.camera, color: Colors.black,),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CameraInfo(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.note, color: Colors.black,),
              title: Text(' Application'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ApplicationInfo(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.black,),
              title: Text('Device'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SystemInfo(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.wifi, color: Colors.black,),
              title: Text('Wifi'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TestWifi(),
                  ),
                );
              }
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.sd_card, color: Colors.black,),
              title: Text('Sd card'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SdCardInfo(),
                  ),
                );
              }
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.upload, color: Colors.black,),
              title: Text('Models & Firmware'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TestFw(),
                  ),
                );
              }
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.audio_file, color: Colors.black,),
              title: Text('Audio'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TestMode(),
                  ),
                );
              }
            ),
            Divider(),
            ListTile(
                leading: Icon(Icons.bluetooth, color: Colors.black,),
                title: Text('BLE'),
                onTap: ()
                {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BleInfo(),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
