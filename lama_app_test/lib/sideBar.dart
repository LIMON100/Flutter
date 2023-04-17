<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamaAppR/custom_icon_icons.dart';
import 'open_camera.dart';
import 'qrviewexample.dart';
import 'db_icons.dart';
import 'llama_web_menu.dart';


class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        color: Color(0xFF2580B3),
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
                color: Color(0xFF2580B3),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            ListTile(
              leading: Icon(CustomIcon.scooter, color: Colors.black, size: size.width * 0.07,),
              title: Text(
                'Llama Eye',
                style: TextStyle(
                  fontFamily: 'Montserrat',
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
                    builder: (context) => const LlamaWebMenu(),
                  ),
                );
              }
            ),
            // Divider(),
            ListTile(
              leading: Icon(CustomIcon.car, color: Colors.black,size: size.width * 0.07,),
              title:
              Text(
                'Llama Radar',
                style: TextStyle(
                  fontFamily: 'Quicksand-VariableFont_wght',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              onTap: () => null,
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
                  fontFamily: 'Montserrat',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              onTap: () => null,
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
              onTap: () => null,
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
              fontFamily: 'Montserrat',
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
=======
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamaAppR/custom_icon_icons.dart';
import 'open_camera.dart';
import 'qrviewexample.dart';
import 'db_icons.dart';
import 'llama_web_menu.dart';


class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        color: Color(0xFF2580B3),
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
                color: Color(0xFF2580B3),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            ListTile(
              leading: Icon(CustomIcon.scooter, color: Colors.black, size: size.width * 0.07,),
              title: Text(
                'Llama Eye',
                style: TextStyle(
                  fontFamily: 'Montserrat',
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
                    builder: (context) => const LlamaWebMenu(),
                  ),
                );
              }
            ),
            // Divider(),
            ListTile(
              leading: Icon(CustomIcon.car, color: Colors.black,size: size.width * 0.07,),
              title:
              Text(
                'Llama Radar',
                style: TextStyle(
                  fontFamily: 'Quicksand-VariableFont_wght',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              onTap: () => null,
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
                  fontFamily: 'Montserrat',
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              onTap: () => null,
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
              onTap: () => null,
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
              fontFamily: 'Montserrat',
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
>>>>>>> 250b952e07f49b770a400a3c33aa3901b793e33e
