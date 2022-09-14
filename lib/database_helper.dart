import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pokemon_offlinefirst/consts.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  ///instace of database
  DatabaseHelper._instance();

  /// Database helper
  static final DatabaseHelper db = DatabaseHelper._instance();
  late Database _database;

///database will initialize the db with [_initDB] and return it
  Future<Database> get database async {
    _database = await _initDB();

    return _database;
  }

///Get the application data directory and create a database path with
///directory path and a const database name (offline_first.db)
///opens database, passing the path, version and [_onCreate]
  Future<Database> _initDB() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String databasePath = directory.path + DATABASE_NAME;

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  ///creates the table
  void _onCreate(Database db, int version) async {
    await db.execute(CREATE_POKEMON_TABLE);
  }
///closes the database
  Future close() async {
    var dbClient = await database;
    return dbClient.close();
  }
}