import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/usersauth.dart';

class DatabaseHelper {
  final databaseName = "userauth.db";
  String noteTable =
      "CREATE TABLE notes (noteId INTEGER PRIMARY KEY AUTOINCREMENT, noteTitle TEXT NOT NULL, noteContent TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  //Now we must create our user table into our sqlite db
  // String users =
  //     "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT, usrPassword TEXT)";
  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(noteTable);
    });
  }

  //Login Method
  Future<bool> login(UsersAuth user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
        "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");

    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  //Sign up
  Future<int> signup(UsersAuth user) async {
    final Database db = await initDB();
    return db.insert('users', user.toMap());
  }


  // Get all items
  Future<List<Map<String, dynamic>>> getItems() async {
    final Database db = await initDB();
    return db.query('items', orderBy: "id");
  }

  // Get specific data
  Future<List<Map<String, dynamic>>> getItem(int id) async {
    final Database db = await initDB();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update
  Future<int> updateItem(int id, String title, String? descrption) async {
    final Database db = await initDB();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<List<UsersAuth>> fetchUsers() async {
    final Database db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM users');
    return List.generate(maps.length, (index) => UsersAuth.fromMap(maps[index]));
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final Database db = await DatabaseHelper().initDB();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'userauth.db');
    return path;
  }

  Future<void> deleteDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'userauth.db');
    await deleteDatabase();
  }
}