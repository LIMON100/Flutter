import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamaradar/temp/checkdb.dart';

import '../../model/usersauth.dart';
import '../../sqflite/sqlite.dart';
import 'LogInScreen.dart';

class PasswordUpdate extends StatefulWidget {
  // final String username;
  final TextEditingController emailController;
  const PasswordUpdate({Key? key, required this.emailController}) : super(key: key);

  @override
  State<PasswordUpdate> createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _passwordController3 = TextEditingController();

  bool isVisible = false;
  bool _isUpdatingPassword = false;
  String _updateMessage = '';
  List<UsersAuth>? users;
  bool _isLoading = false;


  Color _updateMessageColor = Colors.black;

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      showCircularProgressIndicator();
      final res = await Amplify.Auth.confirmResetPassword(
        username: widget.emailController.text,
        newPassword: _confirmPasswordController.text,
        confirmationCode: _passwordController3.text,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Password changed successfully. Please log in',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    }
    on AuthException catch (e) {
      _showError(context, '${e.message} - ${e.underlyingException}');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  void showCircularProgressIndicator() {
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
    Future.delayed(Duration(seconds: 3), () {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Update Password for ${widget.emailController}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 15),
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
                controller: _passwordController,
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
                  horizontal: 2, vertical: 5),
              decoration: BoxDecoration(
                // color: Color(0xfff5f8fd),
                  color: Colors.white38,
                  borderRadius:
                  BorderRadius.all(Radius.circular(20))),
              child: TextFormField(
                obscureText: !isVisible,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "password is required";
                  }
                  else if (_passwordController.text != _confirmPasswordController.text) {
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
                controller: _passwordController3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Code is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Code",
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.numbers,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                elevation: 3,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                primary: Colors.black45, // Change to your preferred color
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              child: _isUpdatingPassword ? const CircularProgressIndicator() : const Text(
                "Update Password",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              _updateMessage,
              style: TextStyle(
                color: _updateMessageColor,
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Go to? ",
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
    );
  }
}