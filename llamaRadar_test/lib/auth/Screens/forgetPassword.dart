import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool _isLoading = true;
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }


  Future<void> _fetchUsers() async {
    final future = DatabaseHelper().fetchUsers();
    setState(() => users = null);
    final result = await future;
    setState(() {
      users = result;
      _isLoading = false;
    });
  }

  Future<void> updateUser(int userId, String username, String password) async {
    final db = await DatabaseHelper().initDB();
    await db.update(
      'users',
      {'usrName': username, 'usrPassword': "ff3"},
      where: 'usrId = ?',
      whereArgs: [userId],
    );
    _fetchUsers();
  }

  // Update password with firebase
  // Future passwordChange() async{
  //   try{
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: _usernameController.text.trim());
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Text("Password reset link sent. Check your email inbox or spam folder"),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => SignIn())
  //                 );
  //               },
  //               child: Text("OK"),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  //   on FirebaseAuthException catch(e){
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Text(e.message.toString()),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text("OK"),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  void _onRecoverPassword() async {
    try {
      // showCircularProgressIndicator();
      await Amplify.Auth.resetPassword(username: _usernameController.text);
      // if (res) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordUpdate(emailController: _usernameController),
        ),
      );
    }
    on AuthException catch (e) {
      // Handle authentication exception and display error message
      showSnackBar("EMAIL incorrect");
    }
  }

  void hideCircularProgressIndicator() {
    Navigator.of(context).pop(); // Close the dialog
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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