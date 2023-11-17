import 'package:flutter/material.dart';
import 'package:lamaradar/temp/checkdb.dart';

import '../model/usersauth.dart';
import '../sqflite/sqlite.dart';
import 'Screens/LogInScreen.dart';

class PasswordUpdate extends StatefulWidget {
  final String username;

  const PasswordUpdate({Key? key, required this.username}) : super(key: key);

  @override
  State<PasswordUpdate> createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isVisible = false;
  bool _isUpdatingPassword = false;
  String _updateMessage = '';
  List<UsersAuth>? users;

  Future<void> updateUser(String username, String password) async {
    final db = await DatabaseHelper().initDB();
    await db.update(
      'users',
      {'usrPassword': password},
      where: 'usrName = ?',
      whereArgs: [username],
    );
  }

  Color _updateMessageColor = Colors.black;
  void _updatePassword() async {
    if (_passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty) {
      if (_passwordController.text == _confirmPasswordController.text) {
        setState(() {
          _isUpdatingPassword = true;
          _updateMessage = '';
        });

        updateUser(widget.username, _confirmPasswordController.text);

        setState(() {
          _isUpdatingPassword = false;
          _updateMessage = 'Password updated successfully!';
          _updateMessageColor = Colors.yellow; // Set the color for success message
        });
      } else {
        setState(() {
          _updateMessage = 'Passwords do not match!';
          _updateMessageColor = Colors.red.shade800; // Set the color for error message
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Update Password for ${widget.username}'),
      ),
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
          // TextField(
          //   controller: _passwordController,
          //   obscureText: true,
          //   decoration: const InputDecoration(
          //     labelText: 'New Password',
          //   ),
          // ),
          // const SizedBox(height: 20),
          // TextField(
          //   controller: _confirmPasswordController,
          //   obscureText: true,
          //   decoration: const InputDecoration(
          //     labelText: 'Confirm Password',
          //   ),
          // ),
          const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: _updatePassword,
          //   child: _isUpdatingPassword ? const CircularProgressIndicator() : const Text('Update Password'),
          // ),
          ElevatedButton(
            onPressed: _updatePassword,
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
          const SizedBox(height: 5),
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
    );
  }
}