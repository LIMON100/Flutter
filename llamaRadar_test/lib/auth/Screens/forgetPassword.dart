import 'dart:async';
import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lamaradar/sqflite/sqlite.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/usersauth.dart';
import 'LogInScreen.dart';
import 'PasswordUpdate.dart';


class ForgetPasword extends StatefulWidget {
  const ForgetPasword({Key? key}) : super(key: key);

  @override
  _ForgetPaswordState createState() => _ForgetPaswordState();
}

class _ForgetPaswordState extends State<ForgetPasword> {

  List<UsersAuth>? users;
  bool _isLoading = false;
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _fetchUsers();
  }


  // Future<void> _fetchUsers() async {
  //   final future = DatabaseHelper().fetchUsers();
  //   setState(() => users = null);
  //   final result = await future;
  //   setState(() {
  //     users = result;
  //     _isLoading = false;
  //   });
  // }
  //
  // Future<void> updateUser(int userId, String username, String password) async {
  //   final db = await DatabaseHelper().initDB();
  //   await db.update(
  //     'users',
  //     {'usrName': username, 'usrPassword': "ff3"},
  //     where: 'usrId = ?',
  //     whereArgs: [userId],
  //   );
  //   _fetchUsers();
  // }

  void _onRecoverPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      showCircularProgressIndicator();

      await Amplify.Auth.resetPassword(username: _usernameController.text);

      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordUpdate(emailController: _usernameController),
        ),
      );
    }
    on AuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar("EMAIL incorrect");
    }
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
    Future.delayed(Duration(seconds: 2), () {
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
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
  // Future<String> databasePath = DatabaseHelper().getDatabasePath();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        elevation: 0.0, // Remove any shadow
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Forgot Password', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Colors.grey,
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
                  BorderRadius.all(Radius.circular(80))),
              child: TextFormField(
                controller: _usernameController,
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
            SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                // onPressed: _navigateToPage2,
                onPressed: _onRecoverPassword,
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  primary: Colors.black45, // Change to your preferred color
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}