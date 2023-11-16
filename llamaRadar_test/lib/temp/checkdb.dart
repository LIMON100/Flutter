import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lamaradar/auth/forgetPassword.dart';
import 'package:lamaradar/sqflite/sqlite.dart';

import '../model/usersauth.dart';
import 'SQLHelper.dart';

class CheckDB extends StatefulWidget {
  const CheckDB({Key? key}) : super(key: key);

  @override
  _CheckDBState createState() => _CheckDBState();
}

class _CheckDBState extends State<CheckDB> {

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

  void _deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _fetchUsers();
  }

  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: users?.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(users![index].usrName),
              subtitle: Text(users![index].usrPassword),
              trailing: SizedBox(
                width: 100,
                child: Flexible(
                  child: Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.delete),
                      //   onPressed: () =>
                      //       _deleteItem(users![index].usrId!),
                      // ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          if (users![index].usrId != null) {
                            updateUser(users![index].usrId!, 'limon12', 'newPassword');
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.ad_units),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>  ForgetPasword() //ConnectWifiForDashCam,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }
}