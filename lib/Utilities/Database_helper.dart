import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'users';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'startup_ignition.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        email TEXT,
        name TEXT,
        phone TEXT,
        city TEXT,
        personName TEXT,
        personPhone TEXT,
        mpin TEXT,
        is_verified INTEGER
      )
    ''');
  }

  Future<Map<String, dynamic>?> getUserData(String email) async {
    try {
      Database db = await instance.database;

      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        return result.first;
      } else {
        print('User not found with email: $email');
        return null;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }

  Future<void> deleteUserTable() async {
    Database db = await instance.database;
    await db.execute('DELETE FROM $tableName where id =1');
  }

  Future<int?> getUserDataCount() async {
    final db = await instance.database;
    int? count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users'));
    return count;
  }

  Future<void> deleteUser() async {
    Database db = await instance.database;
    db.delete(tableName, where: 'id=?', whereArgs: [1]);
  }

  Future<void> updateUserData(int userId, Map<String, dynamic> userData) async {
    Database db = await instance.database;

    await db.update(
      tableName,
      userData,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllUserData() async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<void> updateIsVerifiedStatus(String email, bool isVerified) async {
    try {
      Database db = await instance.database;
      await db.update(
        'users',
        {'is_verified': isVerified ? 1 : 0},
        where: 'email = ?',
        whereArgs: [email],
      );
      print('Updated is_verified status for email: $email to $isVerified');
    } catch (error) {
      print('Error updating is_verified status: $error');
    }
  }

  Future<void> updatemPin(String email, String mpin) async {
    try {
      Database db = await instance.database;
      await db.update(
        'users',
        {'mpin': mpin},
        where: 'email = ?',
        whereArgs: [email],
      );
      print('Updated is_verified status for email: $email to $mpin');
    } catch (error) {
      print('Error updating is_verified status: $error');
    }
  }

  Future<int> insertUserData({
    required String email,
    required String name,
    required String phone,
    required String city,
    required String personName,
    required String mpin,
    required String personPhone,
    required bool isVerified,
  }) async {
    Database db = await database;
    Map<String, dynamic> userData = {
      'email': email,
      'name': name,
      'phone': phone,
      'city': city,
      'personName': personName,
      'personPhone': personPhone,
      'mpin': mpin,
      'is_verified': isVerified ? 1 : 0,
    };
    return await db.insert('users', userData);
  }
}
