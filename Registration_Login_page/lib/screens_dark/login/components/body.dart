import 'dart:async';

import 'package:testgpss/size_config.dart';
import 'package:flutter/material.dart';

import '../../../Screens23/LogInScreen.dart';
import '../../../screens/Login/login_screen.dart';
import 'land.dart';
import 'rounded_text_field.dart';
import 'sun.dart';
import 'tabs.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
                          // obscureText: true,
                          decoration: InputDecoration(
                            hintText: "User name",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            prefixIcon:
                            Icon(Icons.people, color: Colors.black),
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
                          // obscureText: true,
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
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                            prefixIcon:
                            Icon(Icons.vpn_key, color: Colors.black),
                          ),
                        ),
                      ),
                      // SizedBox(height: 25),
                      // TextField(
                      //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      //   decoration: InputDecoration(
                      //     labelText: "User-name",
                      //     hintText: "Enter your user name",
                      //     labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      //     hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      // SizedBox(height: 25),
                      // TextField(
                      //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      //   decoration: InputDecoration(
                      //     labelText: "Email",
                      //     hintText: "dudecoderr@gmail.com",
                      //     labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      //     hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      // SizedBox(height: 25),
                      // TextField(
                      //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      //   obscureText: true,
                      //   decoration: InputDecoration(
                      //     labelText: "Password",
                      //     hintText: "XXXXXXX",
                      //     labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      //     hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      SizedBox(height:25),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your onPressed logic here
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
                          // Your existing sign-up widgets here...

                          // Add the "Already have an account? Sign in" text
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
    );
  }
}
