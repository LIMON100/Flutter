import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamaradar/auth/Screens/forgetPassword.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_screen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {

  final username = TextEditingController();
  final password = TextEditingController();
  final _passwordController = TextEditingController();
  // final FirebaseAuthService _auth = FirebaseAuthService();
  bool isLoginTrue = false;
  bool isVisible = false;
  bool _isLoading = false;

  // final db = DatabaseHelper();
  final formKey = GlobalKey<FormState>();
  bool _isSigning = false;

  // AWS amplify log in
  void _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      showCircularProgressIndicator();
      // Show circular progress indicator while waiting for the authentication process
      final signInOptions = const SignInOptions();
      await Amplify.Auth.signIn(
        username: username.text,
        password: _passwordController.text,
        options: signInOptions,
      );

      // Show a success message
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BleScreen(title: ''),
        ),
      );

      showSnackBar("Logged In successfully");
    }
    on AuthException catch (e) {
      showSnackBar(e.message);
      setState(() {
        _isLoading = false;
      });
    }
    on Exception catch (e) {
      print("SNACKBAR");
      print(e);
      showSnackBar("An error occurred during login");
    }
    finally {}
  }

  void showCircularProgressIndicator() {
    // Create a Completer to control when to stop the spinner
    Completer<void> spinnerCompleter = Completer<void>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Start the spinner
        _startSpinner(spinnerCompleter);

        return Center(
          child: FutureBuilder(
            future: spinnerCompleter.future,
            builder: (context, snapshot) {
              // Check if the Future is complete (spinner duration reached)
              if (snapshot.connectionState == ConnectionState.done) {
                // Stop the spinner
                Navigator.of(context).pop();
                return Container(); // You can replace Container() with any other widget or an empty Container
              } else {
                // Show the spinner while the duration is not reached
                return SpinKitDancingSquare(
                  color: Colors.blue,
                  size: 150.0,
                );
              }
            },
          ),
        );
      },
    );
  }

// Function to start the spinner and complete it after 3 seconds
  void _startSpinner(Completer<void> completer) {
    Future.delayed(Duration(seconds: 6), () {
      completer.complete();
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }


  bool isLoggedIn = false;
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  void dispose() {
    username.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
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
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffe8ebed),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                50, //For moving according to the screen when the keyboard popsup.
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(30),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffe1e2e3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ]),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w800),
                                    )),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff5f8fd),
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
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20))),
                                  child: TextFormField(
                                    obscureText:!isVisible,
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "password is required";
                                      }
                                      return null;
                                    },
                                    // obscureText: true,
                                    decoration: InputDecoration(
                                        prefixIcon:
                                        Icon(Icons.vpn_key, color: Colors.black),
                                        border: InputBorder.none,
                                        hintText: "Password",
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
                                    // decoration: InputDecoration(
                                    //   hintText: "Password",
                                    //   border: InputBorder.none,
                                    //   prefixIcon:
                                    //       Icon(Icons.vpn_key, color: Colors.grey),
                                    // ),
                                  ),
                                ),
                              ]),
                        ),

                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ForgetPasword())
                                  );
                                },
                                child: Container(
                                  child: Text("Forgot Password?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red)),
                                ),
                              )
                          ),
                        ),

                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  // login();
                                  _login();
                                }
                                setState(() {
                                  isLoggedIn = true;
                                  saveLoginStatus(isLoggedIn);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 3,
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                                primary: Colors.deepPurpleAccent, // Change to your preferred color
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     await Amplify.Auth.signOut();
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     elevation: 3,
                        //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                        //     primary: Colors.deepPurpleAccent, // Change to your preferred color
                        //     shape: RoundedRectangleBorder(
                        //       side: BorderSide(color: Colors.white70),
                        //       borderRadius: BorderRadius.all(Radius.circular(30)),
                        //     ),
                        //   ),
                        //   child: Text(
                        //     "Sign Out",
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text("Don't have an account?"),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegistrationScreen())
                              );
                            },
                            child: Container(
                              child: Text("Register now",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.deepPurpleAccent)),
                            ),
                          )
                        ]),
                        isLoginTrue
                            ? const Text(
                          "Username or passowrd is incorrect",
                          style: TextStyle(color: Colors.red),
                        )
                            : const SizedBox(),
                      ],
                    ),
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
