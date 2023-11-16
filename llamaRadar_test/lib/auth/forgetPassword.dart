import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lamaradar/sqflite/sqlite.dart';
import 'package:sqflite/sqflite.dart';

import '../model/usersauth.dart';
import 'PasswordUpdate.dart';


class ForgetPasword extends StatefulWidget {
  const ForgetPasword({Key? key}) : super(key: key);

  @override
  _ForgetPaswordState createState() => _ForgetPaswordState();
}

class _ForgetPaswordState extends State<ForgetPasword> {

  List<UsersAuth>? users;
  bool _isLoading = true;

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
  final TextEditingController _usernameController = TextEditingController();

  void _navigateToPage2() {
    if (_usernameController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PasswordUpdate(username: _usernameController.text)),
      );
    }
  }

  Future<String> databasePath = DatabaseHelper().getDatabasePath();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 2, vertical: 5),
            decoration: BoxDecoration(
              // color: Color(0xfff5f8fd),
                color: Colors.white38,
                borderRadius:
                BorderRadius.all(Radius.circular(20))),
            child: TextFormField(
              controller: _usernameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "username is required";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Email/User-name",
                border: InputBorder.none,
                prefixIcon:
                Icon(Icons.email, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child: ElevatedButton(
              onPressed: _navigateToPage2,
              style: ElevatedButton.styleFrom(
                elevation: 3,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                primary: Colors.black45, // Change to your preferred color
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              child: Text(
                "Proceed Next",
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
    );
  }
}