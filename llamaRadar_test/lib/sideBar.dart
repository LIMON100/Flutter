import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamaradar/auth/Screens/LogInScreen.dart';
import 'package:lamaradar/icons/custom_icon_icons.dart';
import 'package:lamaradar/icons/db_icons.dart';
import 'package:camera/camera.dart';
import 'package:lamaradar/temp/ConnectWifiForDashCam.dart';
import 'package:lamaradar/temp/TestGps.dart';
import 'package:lamaradar/temp/VlcPlayerPage.dart';
import 'package:lamaradar/temp/checkdb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mode/llamaGuardSetting.dart';

class SideBar extends StatefulWidget {
  SideBar({Key? key}) : super(key: key);
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
// class SideBar extends StatelessWidget {
  late final CameraDescription camera;

  bool isLoggedIn = true;
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }


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
                  child: Image.asset(
                    'images/llamalogo_no_txt.jpg',
                    fit: BoxFit.cover,
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
            LayoutBuilder(
              builder: (context, constraints) {
                final fontSize = constraints.maxWidth * 0.06;
                return ListTile(
                  leading: Icon(
                    CustomIcon.webcam,
                    color: Colors.black,
                    size: constraints.maxWidth * 0.07,
                  ),
                  title: Text(
                    'Dash Cam',
                    style: TextStyle(
                      fontFamily: 'Quicksand-VariableFont_wght',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ConnectWifiForDashCam(), //ConnectWifiForDashCam
                      ),
                    );
                  },
                );
              },
            ),
            // LayoutBuilder(
            //   builder: (context, constraints) {
            //     final fontSize = constraints.maxWidth * 0.06;
            //     return ListTile(
            //       leading: Icon(
            //         CustomIcon.webcam,
            //         color: Colors.black,
            //         size: constraints.maxWidth * 0.07,
            //       ),
            //       title: Text(
            //         'NETWORK',
            //         style: TextStyle(
            //           fontFamily: 'Quicksand-VariableFont_wght',
            //           fontSize: fontSize,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black,
            //           letterSpacing: 2.0,
            //         ),
            //       ),
            //       onTap: () {
            //         Navigator.pop(context);
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) =>  NetworkStreamPlayer(), //ConnectWifiForDashCam
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
            // LayoutBuilder(
            //   builder: (context, constraints) {
            //     final fontSize = constraints.maxWidth * 0.06;
            //     return ListTile(
            //       leading: Icon(
            //         CustomIcon.webcam,
            //         color: Colors.black,
            //         size: constraints.maxWidth * 0.07,
            //       ),
            //       title: Text(
            //         'VLC',
            //         style: TextStyle(
            //           fontFamily: 'Quicksand-VariableFont_wght',
            //           fontSize: fontSize,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black,
            //           letterSpacing: 2.0,
            //         ),
            //       ),
            //       onTap: () {
            //         Navigator.pop(context);
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) =>  TestGps(), //ConnectWifiForDashCam
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),

            // LayoutBuilder(
            //   builder: (context, constraints) {
            //     final fontSize = constraints.maxWidth * 0.06;
            //     return ListTile(
            //       leading: Icon(
            //         CustomIcon.webcam,
            //         color: Colors.black,
            //         size: constraints.maxWidth * 0.07,
            //       ),
            //       title: Text(
            //         'Check DB ',
            //         style: TextStyle(
            //           fontFamily: 'Quicksand-VariableFont_wght',
            //           fontSize: fontSize,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black,
            //           letterSpacing: 2.0,
            //         ),
            //       ),
            //       onTap: () {
            //         Navigator.pop(context);
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) =>  CheckDB(), //ConnectWifiForDashCam
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
            LayoutBuilder(
              builder: (context, constraints) {
                final fontSize = constraints.maxWidth * 0.06;
                return ListTile(
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      fontFamily: 'Quicksand-VariableFont_wght',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                  leading: Icon(
                    CustomIcon.exit,
                    color: Colors.black,
                    size: constraints.maxWidth * 0.07,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                          child: AlertDialog(
                            title: Text("Are you sure to log out?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLoggedIn = false; // Update login status
                                  });

                                  saveLoginStatus(isLoggedIn); // Save login status to shared preferences

                                  // Clear login status before navigating back
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(), //ConnectWifiForDashCam
                                    ),
                                  );
                                },
                                child: Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text("No"),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final fontSize = constraints.maxWidth * 0.06;
                return ListTile(
                  title: Text(
                    'Exit',
                    style: TextStyle(
                      fontFamily: 'Quicksand-VariableFont_wght',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                  leading: Icon(
                    CustomIcon.exit,
                    color: Colors.black,
                    size: constraints.maxWidth * 0.07,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                          child: AlertDialog(
                            title: Text("Are you sure to exit?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Navigator.of(context).pop(true);
                                  SystemNavigator.pop();
                                },
                                child: Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text("No"),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
