import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    // Initialize the databaseFactoryFfi
    databaseFactory = databaseFactoryFfi;

    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'your_database.db');

    // Delete the database if it already exists (for testing purposes)
    // await deleteDatabase(path);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        city TEXT,
        referredBy TEXT,
        personName TEXT,
        personMobile TEXT,
        professionalIntro TEXT,
        website TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> userData) async {
    var dbClient = await db;
    return await dbClient.insert('user', userData);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    var dbClient = await db;
    return await dbClient.query('user');
  }

  Future<Map<String, dynamic>> getUserData() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('user');
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      throw Exception('User data not found');
    }
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    final dbClient = await db;
    await dbClient.update('user', userData);
  }
}
