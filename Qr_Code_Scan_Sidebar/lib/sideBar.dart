import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scan_sidebar/custom_icon_icons.dart';
import 'open_camera.dart';
import 'qrviewexample.dart';
import 'db_icons.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('LLAMA'),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('images/llamalogo_no_txt.jpg',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(CustomIcon.scooter, color: Colors.black,),
            title: Text('Llama Eye'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context){
                    return Container(
                      child: AlertDialog(
                        title: Text("Want to open web tool"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const OpenCamera(),
                                  ),
                                );
                              },
                              child: Text("Yes")),
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("No"))
                        ],
                      ),
                    );
                  });
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(CustomIcon.car, color: Colors.black,),
            title: Text(' Llama Radar'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(CustomIcon.webcam, color: Colors.black,),
            title: Text('Dash Cam'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(DBIcons.logo, color: Colors.black,),
            title: Text('Settings'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(CustomIcon.exit, color: Colors.black,),
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
    );
  }
}
