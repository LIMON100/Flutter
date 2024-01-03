import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamaradar/auth/Screens/LogInScreen.dart';
import 'package:lamaradar/icons/custom_icon_icons.dart';
import 'package:lamaradar/icons/db_icons.dart';
import 'package:camera/camera.dart';
import 'package:lamaradar/ride_history/mapView.dart';
import 'package:lamaradar/ride_history/maps/marker_info.dart';
import 'package:lamaradar/ride_history/maps/maker_with_image.dart';
import 'package:lamaradar/ride_history/maps/temp/CustomMarkerInfoWindowScreen.dart';
import 'package:lamaradar/ride_history/maps/temp/custom_marker_with_network_image.dart';
import 'package:lamaradar/ride_history/showGpsData.dart';
import 'package:lamaradar/mode/ConnectWifiForDashCam.dart';
import 'package:lamaradar/temp/NetworkStreamPlayer.dart';
import 'package:lamaradar/temp/TestGps.dart';
import 'package:lamaradar/temp/VlcPlayerPage.dart';
import 'package:lamaradar/temp/checkdb.dart';
import 'package:lamaradar/temp/test_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'auth/firebase/temp/features/user_auth/presentation/pages/login_page.dart';
import 'mode/llamaGuardSetting.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';

class SideBar extends StatefulWidget {
  SideBar({Key? key}) : super(key: key);
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
// class SideBar extends StatelessWidget {
  late final CameraDescription camera;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String userUniqueName = '';


  @override
  void initState() {
    super.initState();
    getCurrentUserID();
  }

  Future<void> getCurrentUserID() async {
    final currentUser = await Amplify.Auth.getCurrentUser();
    Map<String, dynamic> signInDetails = currentUser.signInDetails.toJson();
    userUniqueName = signInDetails['username'];
    setState(() {});
  }

  bool isLoggedIn = true;
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }


  @override
  Widget build(BuildContext context) {
    // user = FirebaseAuth.instance.currentUser;
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        color: Color(0xFF517fa4),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              // accountName: Text('   LLAMA'),
              accountName: Text(userUniqueName ?? 'Not logged in'),
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
            LayoutBuilder(
              builder: (context, constraints) {
                final fontSize = constraints.maxWidth * 0.06;
                return ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Colors.black,
                    size: constraints.maxWidth * 0.07,
                  ),
                  title: Text(
                    'Ride History',
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
                        builder: (context) =>  ShowGpsData(), //ConnectWifiForDashCam
                      ),
                    );
                  },
                );
              },
            ),
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
                    'Test AWS DATA',
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
                        builder: (context) =>  TestScreen(),//MarkerWithImage(date: '2023-12-01'), //TestGps
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
            //         'TEST VLC 2 ',
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
            //             builder: (context) =>  TestGps(),//CheckDB(), //ConnectWifiForDashCam
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
                    Icons.logout,
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
                                onPressed: () async{
                                  setState(() {
                                    isLoggedIn = false;
                                    saveLoginStatus(isLoggedIn);
                                  });
                                  await Amplify.Auth.signOut();
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
