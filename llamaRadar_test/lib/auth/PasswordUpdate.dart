import 'package:flutter/material.dart';
import 'package:lamaradar/temp/checkdb.dart';

import '../model/usersauth.dart';
import '../sqflite/sqlite.dart';

class PasswordUpdate extends StatefulWidget {
  final String username;

  const PasswordUpdate({Key? key, required this.username}) : super(key: key);

  @override
  State<PasswordUpdate> createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
        });
      } else {
        setState(() {
          _updateMessage = 'Passwords do not match!';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Password for ${widget.username}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updatePassword,
            child: _isUpdatingPassword ? const CircularProgressIndicator() : const Text('Update Password'),
          ),
          const SizedBox(height: 20),
          Text(_updateMessage),
          ElevatedButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckDB()),
              );
            },
            child: Text('Go to CHECK DB'),
          ),
        ],
      ),
    );
  }
}