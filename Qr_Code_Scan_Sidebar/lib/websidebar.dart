import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamaApp/custom_icon_icons.dart';
import 'db_icons.dart';
import 'llama_web_menu.dart';
import 'mode/wifiInfo.dart';
import 'mode/systeminfo.dart';
import 'mode/camerainfo.dart';

class WebSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                image: AssetImage('images/llama_img.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(DBIcons.logo, color: Colors.black,),
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
            leading: Icon(CustomIcon.car, color: Colors.black,),
            title: Text(' Application'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(CustomIcon.webcam, color: Colors.black,),
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
            leading: Icon(DBIcons.logo, color: Colors.black,),
            title: Text('Wifi'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WifiInfo(),
                ),
              );
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(DBIcons.logo, color: Colors.black,),
            title: Text('Sd card'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(DBIcons.logo, color: Colors.black,),
            title: Text('Models'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(DBIcons.logo, color: Colors.black,),
            title: Text('Firmware'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(DBIcons.logo, color: Colors.black,),
            title: Text('Audio'),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
}
