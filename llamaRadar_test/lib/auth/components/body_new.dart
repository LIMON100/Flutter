import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lamaradar/auth/size_config.dart';
import 'package:flutter/material.dart';
import '../../model/usersauth.dart';
import '../../sqflite/sqlite.dart';
import '../Screens/LogInScreen.dart';
import '../firebase/temp/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import '../firebase/temp/global/common/toast.dart';
import 'land.dart';
import 'sun.dart';

class BodyNew extends StatefulWidget {
  @override
  _BodyNewState createState() => _BodyNewState();
}

class _BodyNewState extends State<BodyNew> {
  final user = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final FirebaseAuthService _auth = FirebaseAuthService();
  bool isSigningUp = false;

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

  void _signUp() async {

    setState(() {
      isSigningUp = true;
    });

    User? user = await _auth.signUpWithEmailAndPassword(username.text, confirmPassword.text);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "New User is successfully created");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
      );
    }
    else {
      showToast(message: "Some error happend");
    }
  }

  @override
  void dispose() {
    super.dispose();
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
    var customColors2 = [
      Color(0xFF7A2832),
      Color(0xFF97989D),
      Color(0xFF278BD9),
    ];
    List<Color> lightBgColors2 = [
      Color(0xFFA85B3A),
      Color(0xFFBB783B),
      Color(0xFFB98454),
      if (isFullSun) Color(0xFFFF9D80),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFA85B3A),
        elevation: 0.0, // Remove any shadow
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Registration', style: TextStyle(color: Colors.black)),
      ),

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
                colors: isDayMood ? lightBgColors2 : darkBgColors,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SizedBox(height: 75),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 300,
                        width: 400,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/images/logo.png",),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalSpacing(of: 1, key: UniqueKey()),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                              // color: Color(0xfff5f8fd),
                                color: Colors.white38,
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            child: TextFormField(
                              controller: user,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "username is required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Username",
                                border: InputBorder.none,
                                prefixIcon:
                                Icon(Icons.people, color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                              // color: Color(0xfff5f8fd),
                                color: Colors.white38,
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            child: TextFormField(
                              controller: username,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email is required";
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
                                horizontal: 2, vertical: 2),
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
                          ),
                          SizedBox(height: 25),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
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
                          SizedBox(height:10),
                          SizedBox(height:20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _signUp();
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
                          SizedBox(height: 15),
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
      ),
    );
  }
}
