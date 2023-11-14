import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:lamaradar/auth/size_config.dart';
import 'package:flutter/material.dart';
import '../../model/usersauth.dart';
import '../../sqflite/sqlite.dart';
import '../Screens/LogInScreen.dart';
import 'land.dart';
import 'sun.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool isVisible = false;
  bool isFullSun = false;
  bool isDayMood = true;
  Duration _duration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isFullSun = true;
      });
    });
  }

  void changeMood(int activeTabNum) {
    if (activeTabNum == 0) {
      setState(() {
        isDayMood = true;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isFullSun = true;
        });
      });
    } else {
      setState(() {
        isFullSun = false;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isDayMood = false;
        });
      });
    }
  }
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    List<Color> lightBgColors = [
      Color(0xFF8C2480),
      Color(0xFFCE587D),
      Color(0xFFFF9485),
      if (isFullSun) Color(0xFFFF9D80),
    ];
    var darkBgColors = [
      Color(0xFF0D1441),
      Color(0xFF283584),
      Color(0xFF376AB2),
    ];
    var customColors = [
      Color(0xFF1354A1),
      Color(0xFF97989D),
      Color(0xFF0F2642),
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: AnimatedContainer(
            duration: _duration,
            curve: Curves.easeInOut,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDayMood ? customColors : darkBgColors,
              ),
            ),
            child: Stack(
              children: [
                // Replace the following placeholders with your Sun and Land widgets
                Sun(duration: _duration, isFullSun: isFullSun, key: UniqueKey()),
                Land(key: UniqueKey()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpacing(of: 50, key: UniqueKey()),
                        // VerticalSpacing(key: UniqueKey()),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          decoration: BoxDecoration(
                            // color: Color(0xfff5f8fd),
                              color: Colors.white38,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: TextFormField(
                            controller: username,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "username is required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              prefixIcon:
                              Icon(Icons.email, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          decoration: BoxDecoration(
                            // color: Color(0xfff5f8fd),
                              color: Colors.white38,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: TextFormField(
                            obscureText:!isVisible,
                            controller: password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "password is required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon:
                                Icon(Icons.vpn_key, color: Colors.black),
                                border: InputBorder.none,
                                hintText: "Type Password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      //In here we will create a click to show and hide the password a toggle button
                                      setState(() {
                                        //toggle button
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off))),
                          ),
                            // decoration: InputDecoration(
                            //   hintText: "Type Password",
                            //   border: InputBorder.none,
                            //   prefixIcon:
                            //   Icon(Icons.vpn_key, color: Colors.black),
                            // ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          decoration: BoxDecoration(
                            // color: Color(0xfff5f8fd),
                              color: Colors.white38,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: TextFormField(
                            obscureText: !isVisible,
                            controller: confirmPassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "password is required";
                              } else if (password.text != confirmPassword.text) {
                                return "Passwords don't match";
                              }
                              return null;
                            },
                            // decoration: InputDecoration(
                            //   hintText: "Again type Password",
                            //   border: InputBorder.none,
                            //   prefixIcon:
                            //   Icon(Icons.vpn_key, color: Colors.black),
                            // ),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key, color: Colors.black),
                                border: InputBorder.none,
                                hintText: "Again Type Password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      //In here we will create a click to show and hide the password a toggle button
                                      setState(() {
                                        //toggle button
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off))),
                          ),
                        ),
                        SizedBox(height:25),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final db = DatabaseHelper();
                                db.signup(UsersAuth(
                                    usrName: username.text,
                                    usrPassword: password.text,

                                    ))
                                    .whenComplete(() {
                                  //After success user creation go to login screen
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignIn()));
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                              primary: Colors.blueGrey, // Change to your preferred color
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),

                            // Add the "Sign in" button
                            TextButton(
                              onPressed: () {
                                // Navigate to another page when the button is pressed
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignIn()),
                                );
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// function to save the user's login status to the database.
// Future<void> saveUserLoginStatus(UserLoginStatus userLoginStatus) async {
//   // final db = await DatabaseHelper();
//   Database db = await DatabaseHelper.initDB();
//   await db.insert('UserLoginStatus', userLoginStatus.toMap());
// }
// //
// // // Create a function to check the user's login status.
// Future<bool> checkUserStatus(int userId) async {
//   DatabaseHelper.
//   var result = await db.rawQuery(
//       "select user_status from users where usrId = ?", whereArgs: [userId]);
//   return result.first['user_status'];
// }
//
// // When the user logs in, call the function to save the user's login status to the database.
// void login(int userId) {
//   saveUserLoginStatus(UserLoginStatus(id: userId, loggedIn: true));
// }
//
// // When the user logs out, call the function to clear the user's login status from the database.
// void logout() {
//   saveUserLoginStatus(UserLoginStatus(id: 1, loggedIn: false));
// }
//
// // On every page load, check the user's login status. If the user is logged in, redirect the user to the home page. If the user is not logged in, redirect the user to the login page.
// Future<void> checkLoginStatus() async {
//   final isLoggedIn = await checkUserLoginStatus(1);
//   if (isLoggedIn) {
// // Redirect the user to the home page.
//   } else {
// // Redirect the user to the login page.
//   }
// }